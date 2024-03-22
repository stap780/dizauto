import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"


// Connects to data-controller="incase"
export default class extends Controller {
  static targets = ['itemStatusResults','itemStatusSelected']
  connect() {

  }

  changeBulkIncaseItemStatus(event){
    console.log(event.target)
    //let selected = document.getElementById('incase_item_status_label')
    let selected = this.itemStatusSelectedTarget
    console.log(selected.value)
    this.itemStatusResultsTargets.forEach((element, index) => {
      element.value = selected.value
    })    
  }
}

