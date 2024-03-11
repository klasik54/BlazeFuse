
function sendData(event) {
    // console.log("Sending data")
    // console.log(event.target.closest(".state"))
    // console.log(event.target.closest(".component").querySelector("[name='state']").value)
    // console.log(event.target.parentElement.querySelector("[name='action']").value)
    
    const state = JSON.parse(event.target.closest(".component").querySelector("[name='state']").value)
    const id = event.target.closest(".component").querySelector("[name='id']").value
    const action = JSON.parse(event.target.parentElement.querySelector("[name='action']").value) // event.target.querySelector("[name='action']")?.value
    
    return {
        state: state,
        id: id,
        action: action
    }
}
