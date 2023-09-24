import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="turbo"
export default class extends Controller {
  initialize() {
    this.element.setAttribute("data-action", "click->turbo#click")
  }

  click(e) {
    e.preventDefault()
    // console.log("this.element", this.element);
    this.url = this.element.getAttribute("href")
    console.log("this.url", this.url);
    fetch(this.url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
    .then(r => r.text())
    .then(html => Turbo.renderStreamMessage(html))
  }
}