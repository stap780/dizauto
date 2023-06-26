
// не используется. но оставил как пример кода

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = ['form'];

  connect() {
    console.log('form submitted connect');
    this.form = this.element.closest("form");
    this.formData = new FormData(this.form);
    this.url = this.form.action+'/create_from_import';
    const requestSend = () => this.sendRequest(this.url, this.formData);
  }

  submitForm(event) {
    event.preventDefault();
    console.log('form submitted click');
    let isValid = this.validateForm(this.formTarget);

    // If our form is invalid, prevent default on the event
    // so that the form is not submitted
    if (!isValid) {
      console.log('form not valid');
    } 
    if (isValid)  {
      this.sendRequest(this.url, this.formData);
    }
  }

  validateForm() {
    let isValid = true;

    let requiredFieldSelectors = 'textarea:required, input:required';

    let requiredFields = this.formTarget.querySelectorAll(requiredFieldSelectors);

    requiredFields.forEach((field) => {
      if (!field.disabled && !field.value.trim()) {
        field.focus();

        isValid = false;

        return false;
      }
    });
    
    // If we already know we're invalid, just return false
    if (!isValid) {
      return false;
    }

    let invalidFields = this.formTarget.querySelectorAll('input:invalid');
    
    invalidFields.forEach((field) => {
      if (!field.disabled) {
        field.focus();
        
        isValid = false;
      }
    });
    
    return isValid;
  }

  save() {
    this.formData = new FormData(this.form);
    console.log("save this.url => ",this.url);
    // Call the debounced request with the new form data.
    this.sendRequest(this.url, this.formData);
  }

  sendRequest(url, formData) {
    console.log("Sending request to " + url);
    // fetch and trigger turbo_stream response

    fetch(url, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")
          .content,
        Accept: "text/vnd.turbo-stream.html",
      },
      credentials: "same-origin",
    }).then((response) => {
      console.log('response => ',response)
      //response.text().then((html) => {
      //  console.log("html", html);
        //document.body.insertAdjacentHTML("beforeend", html);
      //});
    });
  }

}
