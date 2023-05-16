import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ['format','attributes','xml' ]
  static classes = [ "dnone" ]

  connect() {
    
  }
  change_format(e) {  
    // console.log(e);
    // console.log(this.formatTarget.value);
    if (this.formatTarget.value == 'xml') {
        this.attributesTarget.classList.add(this.dnoneClass);
        this.xmlTarget.classList.remove(this.dnoneClass);
      }
    if (this.formatTarget.value == 'xlsx') {
        this.xmlTarget.classList.add(this.dnoneClass);
        this.attributesTarget.classList.remove(this.dnoneClass);
    }
    if (this.formatTarget.value == 'csv') {
      this.xmlTarget.classList.add(this.dnoneClass);
      this.attributesTarget.classList.remove(this.dnoneClass);
  }
}
} 