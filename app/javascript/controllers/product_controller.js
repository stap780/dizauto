import { Controller } from "@hotwired/stimulus"
import { StreamActions } from "@hotwired/turbo"
import { Modal } from "bootstrap"

// Connects to data-controller="product"
export default class extends Controller {
  connect() {
    console.log('product controller')
  }

  tab_click(){
    console.log('tab click')
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