import { Controller } from "@hotwired/stimulus"
import { StreamActions } from "@hotwired/turbo"

// Connects to data-controller="product"
export default class extends Controller {
  connect() {
    console.log('product controller')
  }

  tab_click(){
    console.log('tab click')
  }

}
