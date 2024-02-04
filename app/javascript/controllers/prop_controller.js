import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="prop"
export default class extends Controller {
  static targets = ['select','characteristic', 'characteristicwrap']
  static values = {
    url: String,
    param: String
  }

  connect() {
    if (this.selectTarget.id === "") {
      this.selectTarget.id = Math.random().toString(36)
    }
    if (this.characteristicwrapTarget.id === "") {
      this.characteristicwrapTarget.id = this.selectTarget.id+'_wrap'
    }
  }

  change(event) {
    console.log('event', event)
    let params = new URLSearchParams()
    params.append(this.paramValue, event.target.selectedOptions[0].value)
    params.append("target", this.selectTarget.id)
    params.append("wraptarget", this.selectTarget.id+'_wrap')
    params.append("targetname", this.selectTarget.name)
    
    // console.log('params', params)
    // console.log('this.urlValue', this.urlValue)

    get(`${this.urlValue}?${params}`, {
      responseKind: "turbo-stream"
    })
  }

  // change_property(e) {  
  //   e.preventDefault();
  //   //console.log('hello');
  //   //console.log('event',e);
  //   //console.log('property e.target',e.target);
  //   //console.log('property selected value',e.target.selectedOptions[0].value)
  //   let property_id = e.target.selectedOptions[0].value
  //   console.log('this.characteristicTarget',this.characteristicTarget);
  //   console.log('this.characteristicwrapTarget',this.characteristicwrapTarget);
  //   // let target = this.characteristicTarget.id
  //   let target = this.characteristicwrapTarget.id
  //   const request = get('/products/characteristics?target='+target+'&property_id='+property_id, {
  //     responseKind: "turbo-stream"
  //   })
  //   request.then((response) => {
  //     console.log('response prop_controller',response)
  //     //console.log('this', this)
  //     //this.loadingTarget.classList.add("hidden")
  //   })
  // }
}
 