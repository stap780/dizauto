import { Controller } from "@hotwired/stimulus"
import { Checkbox } from 'stimulus-checkbox';

// Connects to data-controller="checkbox" - one of use in Filter
export default class extends Controller {
  static targets = [ "btn", "box" ]
  connect() {
    console.log('connected Checkbox');
  }

  toggle(e) {
  }
  toggleOne(e) {
    //console.log(e);
    var chks = this.btnTargets;
    for (var i = 0; i < chks.length; i++) {
      chks[i].onclick = function () {
          for (var i = 0; i < chks.length; i++) {
              if (chks[i] != this && this.checked) {
                  chks[i].checked = false;
              }
          }
      };
    }
  }

}

//
//
// <div data-controller="checkbox">
// <input type="checkbox" data-checkbox-target="btn" data-action="change->checkbox#toggle">
// <input type="checkbox" data-checkbox-target="box" data-action="change->checkbox#toggleOne">
// </div>
//
//

