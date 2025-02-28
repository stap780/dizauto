import { Controller } from "@hotwired/stimulus"
import { Offcanvas } from "bootstrap"

// Connects to data-controller="offcanvas"
export default class extends Controller {

  connect() {
    this.offcanvas = new Offcanvas(this.element)
    // console.log('connect Offcanvas')
    // console.log('connect Offcanvas this => ', this)
    // console.log('connect this.offcanvas => ', this.offcanvas)
    // console.log('connect this.offcanvas isOpened => ', this.offcanvas.isOpened)
    // if (!this.offcanvas.isOpened) {
    //   this.offcanvas.show()
    // }    
  }

  show() {
    if (!this.offcanvas.isOpened) {
      this.offcanvas.show()
    }
  }

  hide(event) {
    if (event.detail.success) {
      this.offcanvas.hide()
    }
  }

  showOffcanvasAI(){
    const offcanvasAI = this.element.closest('#offcanvasAI');
    if (offcanvasAI) {
      const offcanvasInstance = Offcanvas.getInstance(offcanvasAI);
      if (offcanvasInstance) {
        offcanvasInstance.show();
      }
    } 
  }

  hideOffcanvasAI() {
    const offcanvasAI = this.element.closest('#offcanvasAI');
    if (offcanvasAI) {
      const offcanvasInstance = Offcanvas.getInstance(offcanvasAI);
      if (offcanvasInstance) {
        offcanvasInstance.hide();
      }
    }
  }

}