onMount()

// State
function getChildrensStates(event) {
  const parent = event.target.closest('.component')
  const children = parent.querySelectorAll('.component')
  let childrenStates = []

  for (let i = 0; i < children.length; i++) {
    const childId = children[i].id
    const state = JSON.parse(children[i].querySelector("[name='state']").value)
    childrenStates.push({ id: childId, state: btoa(JSON.stringify(state)) })
  }

  return childrenStates
}

// Action dispatching
function getButtonData(event) {
  const component = event.target.closest('.component')
  const state = JSON.parse(component.querySelector("[name='state']").value)
  const props = JSON.parse(component.querySelector("[name='props']").value)
  const id = component.querySelector("[name='id']").value

  const action = JSON.parse(event.target.querySelector("[name='action']").value)

  // getChildrensStates(event)
  const childrenStates = getChildrensStates(event)

  return {
    state: state,
    props: props,
    id: id,
    action: action,
    childrenStates: childrenStates,
  }
}

document.body.addEventListener('htmx:configRequest', function (event) {
    console.log("htmx:configRequest", event)
    
    // Add Request Data For Event
    if(event.target.tagName === "INPUT" && event.target.getAttribute("name") === "listener") {
        event.detail.parameters = getEventData(event)
    }
    
    // Add Request Data For Action
    if (event.target.tagName === 'BUTTON') {
        event.detail.parameters = getButtonData(event)
    }
})

document.body.addEventListener("htmx:afterSwap", function(event) {
    registerEventDispatchersOn(event.target)
})

function onMount() {
    registerEventDispatchersOn(document)
}

// Events
function getEventData(event) {
    const eventPayload = event.detail.triggeringEvent.detail
    const component = event.target.closest('.component')
    const id = component.querySelector("[name='id']").value
    const state = JSON.parse(component.querySelector("[name='state']").value)
    const props = JSON.parse(component.querySelector("[name='props']").value)
    const childrenStates = getChildrensStates(event)
    
    return {
        id: id,
        props: props,
        eventPayload: btoa(JSON.stringify(eventPayload)),
        eventName: event.detail.triggeringEvent.type,
        state: state,
        childrenStates: childrenStates
    }
}

function registerEventDispatchersOn(element) {
    element.querySelectorAll("[name='dispatcher']").forEach((element) => {
        element.addEventListener('click', (event) => {
//            console.log("Dispatching event", element.value, JSON.parse(element.getAttribute("data")))
            const eventData = JSON.parse(element.getAttribute("data"))
            event.target.dispatchEvent(new CustomEvent(element.value, { bubbles: true, detail: eventData }))
        })
    })
}
