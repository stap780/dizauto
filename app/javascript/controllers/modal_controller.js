import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="modal"
export default class extends Controller {

  connect() {
    console.log("modal work");
    this.modal = new Modal(this.element)
    this.modal.show()
  }

  hideBeforeRender(event) {
    if (this.isOpen()) {
      event.preventDefault()
      this.element.addEventListener('hidden.bs.modal', event.detail.resume)
      this.modal.hide()
    }
  }

  isOpen() {
    return this.element.classList.contains("show")
  }

  desconnect(){
    this.modal.hide()
  }

}
