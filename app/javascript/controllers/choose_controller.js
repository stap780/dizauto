import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"


// Connects to data-controller="choose"
export default class extends Controller {
  static targets = ['itemResults','itemSelected']
  connect() {

  }

  changeBulkItemStatus(event){
    // console.log(event.target)
    //let selected = document.getElementById('incase_item_status_label')
    let selected = this.itemSelectedTarget
    // console.log(selected.value)
    this.itemResultsTargets.forEach((element, index) => {
      element.value = selected.value
    })    
  }
}

