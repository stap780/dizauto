import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"


// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ['informer' ]
  static classes = [ "dnone" ]

  connect() {
    console.log('controller filter');
    //console.log('controller filter', this.element);
  }

  // we can add "data-action" like this <%= f.search_field :name_cont, "data-action": "filters#submit" %>
  // and form will auto submit
  // submit(event) {
  //   this.element.requestSubmit()
  // }

  start_search(event) {
    console.log('start_search', event);
    document.getElementById('filter-informer').classList.remove('d-none');
  }

}
