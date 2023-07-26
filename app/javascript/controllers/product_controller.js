import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product"
export default class extends Controller {
  connect() {
    console.log('product controller')
  }

  tab_click(){
    console.log('tab click')
  }

}
