// app/javascript/controllers/dropzone_controller.js
import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage";
import { Dropzone } from "dropzone";
import {
  getMetaValue,
  findElement,
  removeElement,
  insertAfter,
} from "../helpers/dropzone";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.dropZone = this.createDropZone(this);
    this.hideFileInput();
    this.bindEvents();
    Dropzone.autoDiscover = false;
  }

  // Private
  hideFileInput() {
    this.inputTarget.disabled = true;
    this.inputTarget.style.display = "none";
  }

  bindEvents() {
    this.dropZone.on("addedfile", file => {
      setTimeout(() => {
        file.accepted && this.createDirectUploadController(this, file).start();
      }, 500);
    });

    this.dropZone.on("removedfile", file => {
      file.controller && removeElement(file.controller.hiddenInput);
    });

    this.dropZone.on("canceled", file => {
      file.controller && file.controller.xhr.abort();
    });
  }

  get headers() {
    return { "X-CSRF-Token": getMetaValue("csrf-token") };
  }

  get url() {
    return this.inputTarget.getAttribute("data-direct-upload-url");
  }

  get maxFiles() {
    return this.data.get("maxFiles") || 1;
  }

  get maxFileSize() {
    return this.data.get("maxFileSize") || 256;
  }

  get dictFileTooBig() {
    return this.data.get("dictFileTooBig") || "File sile is {{filesize}} but only files up to {{maxFilesize}} are allowed";
  }

  get dictInvalidFileType() {
    return this.data.get("dictInvalidFileType") || "Invalid file type";
  }

  get acceptedFiles() {
    return this.data.get("acceptedFiles");
  }

  get addRemoveLinks() {
    return this.data.get("addRemoveLinks") || true;
  }

  createDirectUploadController(source, file) {
    return new DirectUploadController(source, file);
  }

  createDropZone(controller) {
    return new Dropzone(controller.element, {
      url: controller.url,
      headers: controller.headers,
      maxFiles: controller.maxFiles,
      maxFilesize: controller.maxFileSize,
      dictFileTooBig: controller.dictFileTooBig,
      dictInvalidFileType: controller.dictInvalidFileType,
      acceptedFiles: controller.acceptedFiles,
      addRemoveLinks: controller.addRemoveLinks,
      autoQueue: false
    });
  }
}

class DirectUploadController {
  constructor(source, file) {
    this.directUpload = this.createDirectUpload(file, source.url, this);
    this.source = source;
    this.file = file;
  }

  start() {
    this.file.controller = this;
    this.hiddenInput = this.createHiddenInput();
    this.directUpload.create((error, attributes) => {
      if (error) {
        removeElement(this.hiddenInput);
        this.emitDropzoneError(error);
      } else {
        console.log('this.hiddenInput', this.hiddenInput);
        this.hiddenInput.value = attributes.signed_id;
        this.emitDropzoneSuccess(attributes);
      }
    });
  }

  createHiddenInput() {
    console.log('this.directUpload', this.directUpload);
    console.log('createHiddenInput this', this);
    console.log('createHiddenInput this.source', this.source);
    console.log('createHiddenInput this.source.inputTarget', this.source.inputTarget);
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = this.source.inputTarget.name;
    insertAfter(input, this.source.inputTarget);
    return input;
  }

  directUploadWillStoreFileWithXHR(xhr) {
    this.bindProgressEvent(xhr);
    this.emitDropzoneUploading();
  }

  bindProgressEvent(xhr) {
    this.xhr = xhr;
    this.xhr.upload.addEventListener("progress", event =>
      this.uploadRequestDidProgress(event)
    );
  }
  bindUploadEnd(xhr) {
    this.xhr = xhr;
    this.xhr.upload.addEventListener("end", event =>
      console.log('bindUploadEnd event', event)
    );
  }

  uploadRequestDidProgress(event) {
    const element = this.source.element;
    const progress = (event.loaded / event.total) * 100;
    findElement(this.file.previewTemplate,".dz-upload").style.width = `${progress}%`;
  }

  emitDropzoneUploading() {
    console.log('emitDropzoneUploading file.status', this.file.status)
    this.file.status = Dropzone.UPLOADING;
    this.source.dropZone.emit("processing", this.file);
    console.log('emitDropzoneUploading file.status', this.file.status)
  }

  emitDropzoneError(error) {
    this.file.status = Dropzone.ERROR;
    this.source.dropZone.emit("error", this.file, error);
    this.source.dropZone.emit("complete", this.file);
  }

  emitDropzoneSuccess(attributes) {
    console.log('emitDropzoneSuccess file.status', this.file.status)
    this.file.status = Dropzone.SUCCESS;
    console.log('emitDropzoneSuccess file.status', this.file.status)
    this.source.dropZone.emit("success", this.file);
    this.source.dropZone.emit("complete", this.file);
    //this.uploadToActiveStorage(attributes);  //not use in production - this need to check
  }

  createDirectUpload(file, url, controller) {
    return new DirectUpload(file, url, controller);
  }

  // this save image to product but not use it. this is example. Not use because 15-20 images by one time give save errors. 
  uploadToActiveStorage(attributes) {
    // console.log('uploadToActiveStorage attributes => ', attributes);
    const form = document.getElementsByClassName("upload-form")[0];
    // console.log('upload-form => ', form);
    const uploadImageUrl = form.dataset.uploadImageUrl;
    const itemId = form.dataset.itemId;
    fetch(uploadImageUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: JSON.stringify({
        // product: {
        //   images: [ attributes.signed_id ],
        // },
        image_file: attributes.signed_id,
        item_id: itemId
      }),
    }).then (response => response.text())
     .then(html => Turbo.renderStreamMessage(html));
  }



}
