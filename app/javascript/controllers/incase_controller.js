import { Controller } from "@hotwired/stimulus"
import { StreamActions } from "@hotwired/turbo"
import { patch } from "@rails/request.js"
import { Modal } from "bootstrap"


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

StreamActions.set_unchecked = function() {
  // console.log('elements length => ', this.targetElements.length )
  this.targetElements.forEach((element) => {
    element.checked = false
    // console.log('element set_unchecked => ', element)
  });
}

StreamActions.open_modal = function() {
  this.targetElements.forEach((element) => {
    modal = new Modal(element)
    modal.show()
  });
}