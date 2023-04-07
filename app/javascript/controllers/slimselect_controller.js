import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

// Connects to data-controller="slim-select"
export default class extends Controller {
  static targets = [ 'property','characteristic' ]
  connect() {
    //const select = this.element.querySelector('select')
    //console.log('this element', this.element);
  }
  propertyTargetConnected(element) {
    // console.log('propertyTargetConnected element', element);
    var select_property = new SlimSelect({
      select: element,
      closeOnSelect: false
    })
  }
  characteristicTargetConnected(element) {
    var select_characteristic = new SlimSelect({
      select: element,
      closeOnSelect: false
    })
    // select_characteristic.setData([
    //   {text: 'Value 1', value: 'value1'},
    //   {text: 'Value 2', value: 'value2'},
    //   {text: 'Value 3', value: 'value3'}
    // ])
  }
}