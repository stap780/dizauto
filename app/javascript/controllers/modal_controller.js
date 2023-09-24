import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="modal"
export default class extends Controller {

  connect() {
    console.log("modal work");
    this.modal = new Modal(this.element)
    // this.modal.show()
  }

  // это вариант инструкции когда вызывается модальное окно через - data: {controller: 'turbo'}
  // hideBeforeRender(event) {
  //   if (this.isOpen()) {
  //     event.preventDefault()
  //     this.element.addEventListener('hidden.bs.modal', event.detail.resume)
  //     this.modal.hide()
  //   }
  // }

  // submitEnd(event) {
  //   // console.log('submitEnd', event);
  //   if (this.isOpen()) {
  //     console.log('this.isOpen()', this.isOpen());
  //     if (event.detail.success) {
  //         this.modal.hide();
  //     }
  //   }
  // }

  // isOpen() {
  //   return this.element.classList.contains("show")
  // }

  // disconnect(){
  //   this.modal.hide()
  // }
  // конец 

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
