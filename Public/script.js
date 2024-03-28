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
  console.log(childrenStates)

  return {
    state: state,
    props: props,
    id: id,
    action: action,
    childrenStates: childrenStates,
  }
}

document.body.addEventListener('htmx:configRequest', function (event) {
  if (event.target.tagName === 'BUTTON') {
    event.detail.parameters = getButtonData(event)
  }
})

function onMount() {
    registerEventDispatchers()
    registerListeners()
}

// Events

function registerListeners() {
    document.querySelectorAll("[name='listener']").forEach((element) => {
        const parent = element.closest('.component')
//        console.log("Registering listener", "for event", element.value)
        parent.addEventListener(element.value, (event) => {
            console.log("Triggered event", event)
        })
    })
}

function registerEventDispatchers() {
//    console.log("Registering event dispatchers")
    document.querySelectorAll("[name='dispatcher']").forEach((element) => {
//        console.log("Registering event dispatcher", element)
        
        element.addEventListener('click', (event) => {
            console.log("Dispatching event", element.value)
            event.target.dispatchEvent(new CustomEvent(element.value, { bubbles: true }))
        })
    })
}
