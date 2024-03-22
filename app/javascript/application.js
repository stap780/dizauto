// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "@rails/request.js"
import "./controllers"
import * as bootstrap from "bootstrap"

import "./modules/sidebar"

import "./modules/theme"
import "./modules/feather"
import "./modules/fancybox"
// Charts
//import "./modules/chartjs"

// Forms
// import "./modules/flatpickr"
 
// // Maps
// import "./modules/vector-maps"

import "trix"
import "@rails/actiontext"
import "@fortawesome/fontawesome-free/js/all";
// import "./live_reload"

import "./channels"
import { StreamActions } from "@hotwired/turbo"
import { Modal } from "bootstrap"

window.bootstrap = bootstrap;

StreamActions.set_unchecked = function() {
  // console.log('elements length => ', this.targetElements.length )
  this.targetElements.forEach((element) => {
    element.checked = false
    // console.log('element set_unchecked => ', element)
  });
}
StreamActions.open_modal = function() {
  this.targetElements.forEach((element) => {
    modal = new Modal(element)
    modal.show()
  });
}
