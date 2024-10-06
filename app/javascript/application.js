// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "@rails/request.js"
import "./controllers"
import * as bootstrap from "bootstrap"

import "./modules/sidebar"
import "./modules/theme"

import "trix"
import "@rails/actiontext"
import "@fortawesome/fontawesome-free/js/all";

import "./channels"

window.bootstrap = bootstrap;


