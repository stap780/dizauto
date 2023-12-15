import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ['tip','attributes' ]
  static classes = [ "dnone" ]

  connect() {
    
  }
  change_tip(e) {  
    if (this.tipTarget.value == 'simple') {
        this.attributesTarget.classList.add(this.dnoneClass);
      }
    if (this.tipTarget.value == 'message') {
        //this.attributesTargets.classList.remove(this.dnoneClass);
        this.attributesTargets.forEach( (elem) => { elem.classList.remove(this.dnoneClass) } )
    }
  }
} 