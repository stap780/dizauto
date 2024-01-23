import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage";
import { post } from "@rails/request.js"

// Connects to data-controller="image-upload"
export default class extends Controller {

  static targets = ["filesInput","fileItem"];

  // Bind to normal file selection
  uploadFile(event) {
    const filesInput = this.filesInputTarget;
    const url = filesInput.dataset.directUploadUrl;
    Array.from(filesInput.files).forEach(file => {
      //console.log('file',file)
      this.createUploadController(file, url).start();
    })
    filesInput.value = "";
  }
  removeFile(event) {
    // not use
  }


  createUploadController(file, url) {
    return new DirectUploadController(file, url);
  }
}

class DirectUploadController {
  constructor(file, url) {
    console.log('DirectUploadController');
    this.directUpload = this.createDirectUpload(file, url, this);
    this.file = file;
  }

  start() {
    // console.log('start');
    this.directUpload.create((error, blob) => {
      if (error) {
        // Handle the error
        alert(error);
      } else {
        // console.log('blob',blob);
        this.uploadToActiveStorage(blob);
        // Add an appropriately-named hidden input to the form
        // with a value of blob.signed_id
      }
    })
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress",
      event => this.directUploadDidProgress(event))
  }

  directUploadDidProgress(event) {
    // Use event.loaded and event.total to update the progress bar
  }

  createDirectUpload(file, url, controller) {
    return new DirectUpload(file, url, controller);
  }

  async uploadToActiveStorage(blob) {
    const response = await post("/images/upload", {
      body: JSON.stringify({ blob_signed_id: blob.signed_id}),
      responseKind: "turbo-stream",
    })
    
    return response.status === 204
  }

}