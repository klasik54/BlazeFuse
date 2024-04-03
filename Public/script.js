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
})

document.body.addEventListener("htmx:afterSwap", function(event) {
    registerEventDispatchersOn(event.target)
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
