onMount()

// State
function getChildrensStates(component) {
    const children = component.querySelectorAll("[data-node-type='component']")
    let childrenStates = []

    for (let i = 0; i < children.length; i++) {
        const childId = children[i].id
        const state = JSON.parse(children[i].dataset.state)
        childrenStates.push({ id: childId, state: btoa(JSON.stringify(state)) })
    }

    return childrenStates
}

function getComponentData(component) {
    const state = JSON.parse(component.dataset.state)
    const props = JSON.parse(component.dataset.props)
    const componentId = component.id
    const componentName = component.dataset.name
    const childrenStates = getChildrensStates(component)

    return {
        state,
        props,
        componentId,
        componentName,
        childrenStates
    }
}

function getComponentFromEvent(event) {
    return event.target.closest("[data-node-type='component']")
}

// Action dispatching
function getActionData(event) {
    const action = JSON.parse(event.target.dataset.actionData)
    const component = getComponentFromEvent(event)

    return {
        ...getComponentData(component),
        action: action
    }
}

document.body.addEventListener('htmx:configRequest', function (event) {
    // Add Request Data For Action
    if (event.target.dataset.nodeType === "trigger") {
        event.detail.parameters = getActionData(event)
    }
    if(event.target.dataset.nodeType === "input") {
        event.detail.parameters = getInputData(event)
    }
})

document.body.addEventListener("htmx:afterSwap", function(event) {
    registerEventDispatchersOn(event.target)
    setTextAreaHeight(event)
})

function onMount() {
    registerEventDispatchersOn(document)
}

// Events
function registerEventDispatchersOn(element) {
    element.querySelectorAll("[data-node-type='dispatcher']").forEach((element) => {
        element.addEventListener('click', async (event) => {
            const eventName = element.dataset.eventName
            const eventData = JSON.parse(element.dataset.eventData)
            const listeners = document.querySelectorAll(`.listener-${eventName}`)
            const reversedListeners = Array.from(listeners).reverse()
            
            for (const listener of reversedListeners) {
                await htmx.ajax("POST", "/fuse/event", {
                    target: listener,
                    swap: "outerHTML",
                    source: listener,
                    values: {
                        eventPayload: btoa(JSON.stringify(eventData)),
                        eventName: eventName,
                        ...getComponentData(listener)
                    }
                })
            }
        })
    })
}

function getInputData(event) {
    const component = getComponentFromEvent(event)
    const componentData = getComponentData(component)
    const input = event.target
    put(componentData.state, input.name, input.value)
    
    return {
        ...componentData
    }
}

function put(obj, path, val) {

    /**
     * If the path is a string, convert it to an array
     * @param  {String|Array} path The path
     * @return {Array}             The path array
     */
    function stringToPath (path) {

        // If the path isn't a string, return it
        if (typeof path !== 'string') return path;

        // Create new array
        let output = [];

        // Split to an array with dot notation
        path.split('.').forEach(function (item) {

            // Split to an array with bracket notation
            item.split(/\[([^}]+)\]/g).forEach(function (key) {

                // Push to the new array
                if (key.length > 0) {
                    output.push(key);
                }

            });

        });

        return output;

    }

    // Convert the path to an array if not already
    path = stringToPath(path);

    // Cache the path length and current spot in the object
    let length = path.length;
    let current = obj;

    // Loop through the path
    path.forEach(function (key, index) {

        // Check if the assigned key should be an array
        let isArray = key.slice(-2) === '[]';

        // If so, get the true key name by removing the trailing []
        key = isArray ? key.slice(0, -2) : key;

        // If the key should be an array and isn't, create an array
        if (isArray && !Array.isArray(current[key])) {
            current[key] = [];
        }

        // If this is the last item in the loop, assign the value
        if (index === length -1) {

            // If it's an array, push the value
            // Otherwise, assign it
            if (isArray) {
                current[key].push(val);
            } else {
                current[key] = val;
            }
        }

        // Otherwise, update the current place in the object
        else {

            // If the key doesn't exist, create it
            if (!current[key]) {
                current[key] = {};
            }

            // Update the current place in the object
            current = current[key];
        }
    });
}

function setTextAreaHeight(event) {
    const textAreas = event.target.querySelectorAll("textarea")
    
    for (const textArea of textAreas) {
        textArea.parentNode.dataset.replicatedValue = textArea.value
    }
}
