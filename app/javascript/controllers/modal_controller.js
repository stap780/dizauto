import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="modal"
export default class extends Controller {

  connect() {
    //console.log("modal work");
    this.modal = new Modal(this.element)
    // this.modal.show()
  }


  // это вариант с сайт (более классический) https://www.hotrails.dev/articles/rails-modals-with-hotwire
  open() {
    if (!this.modal.isOpened) {
      this.modal.show()
    }
  }

  close(event) {
    if (event.detail.success) {
      this.modal.hide()
    }
  }
  // конец 

}
