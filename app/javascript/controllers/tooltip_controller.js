import { Controller } from "@hotwired/stimulus"
import { Tooltip } from 'bootstrap'

// Connects to data-controller="tooltip"
export default class extends Controller {
  connect() {
    console.log("Tooltip work");
    this.modal = new Tooltip(this.element)
  }
}
