import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"


// Connects to data-controller="action"
export default class extends Controller {
  static targets = ['select', 'action_params_wrap']
  static values = {
    url: String,
    param: String
  }

  connect() {
    if (this.selectTarget.id === "") {
      this.selectTarget.id = Math.random().toString(36)
    }
    if (this.action_params_wrapTarget.id === "") {
      this.action_params_wrapTarget.id = this.selectTarget.id+'_wrap'
    }
  }

  change(event) {
    // console.log('event', event)
    let params = new URLSearchParams()
    params.append(this.paramValue, event.target.selectedOptions[0].value)
    //params.append("target", this.selectTarget.id)
    params.append("wraptarget", this.selectTarget.id+'_wrap')
    params.append("targetname", this.selectTarget.name)
    
    // console.log('params', params)
    // console.log('this.urlValue', this.urlValue)

    get(`${this.urlValue}?${params}`, {
      responseKind: "turbo-stream"
    })
  }

}
