import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autoclick"
export default class extends Controller {
  connect() {
    console.log('autoclick')
    // console.log('this.element', this.element)
    var button = this.element
    setTimeout(() => {
      button.click()
      button.remove()
    }, 500);
  }
}
