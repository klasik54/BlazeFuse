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
