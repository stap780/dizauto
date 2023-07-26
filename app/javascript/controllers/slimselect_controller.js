import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

// Connects to data-controller="slim-select"
export default class extends Controller {

  //static targets = [ 'property','characteristic','client' ]
  connect() {
    //console.log('connect slimselect')
    new SlimSelect ({
      select: this.element,
      settings: {
        //minSelected: 1,
        maxSelected: 1,
      },
    })
  }
}