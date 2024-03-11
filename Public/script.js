function getButtonData(event) {
  const state = JSON.parse(
    event.target.closest('.component').querySelector("[name='state']").value
  )
  const id = event.target
    .closest('.component')
    .querySelector("[name='id']").value

  const action = JSON.parse(event.target.querySelector("[name='action']").value)

  return {
    state: state,
    id: id,
    action: action,
  }
}

document.body.addEventListener('htmx:configRequest', function (event) {
  if (event.target.tagName === 'BUTTON') {
    event.detail.parameters = getButtonData(event)
  }
})
