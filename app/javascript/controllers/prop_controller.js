import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="prop"
export default class extends Controller {
  static targets = ['characteristic', 'characteristicwrap']
  connect() {
    
  }
  change_property(e) {  
    e.preventDefault();
    //console.log('hello');
    //console.log('event',e);
    //console.log('property e.target',e.target);
    //console.log('property selected value',e.target.selectedOptions[0].value)
    let property_id = e.target.selectedOptions[0].value
    console.log('this.characteristicTarget',this.characteristicTarget);
    console.log('this.characteristicwrapTarget',this.characteristicwrapTarget);
    // let target = this.characteristicTarget.id
    let target = this.characteristicwrapTarget.id
    const request = get('/products/characteristics?target='+target+'&property_id='+property_id, {
      responseKind: "turbo-stream"
    })
    request.then((response) => {
      console.log('response',response)
      //console.log('this', this)
      //this.loadingTarget.classList.add("hidden")
    })
  }
}
