import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ['tip', 'subject', 'receiver', 'receivertip', 'receiverValue', 'attachment']
  static classes = ["dnone"]

  connect() {
    this.updateTipVisibility();
    this.changeReceiver();
  }

  changeTip(event) {
    this.updateTipVisibility();
    this.changeReceiver();
  }

  updateTipVisibility() {
    const tip = this.tipTarget.value;
    const subject = this.subjectTarget;
    const receiver = this.receiverTarget;

    if (tip === 'simple') {
      subject.classList.add(this.dnoneClass);
      receiver.classList.add(this.dnoneClass);
    } else if (tip === 'message') {
      subject.classList.remove(this.dnoneClass);
      receiver.classList.remove(this.dnoneClass);
    }
  }
  changeReceiver(event) {
    const receivertip = this.receivertipTarget.value;
    const receiverValue = this.receiverValueTarget;
    if (receivertip == 'client') {
      receiverValue.classList.add(this.dnoneClass);
    } else if (receivertip === 'user') {
      receiverValue.classList.remove(this.dnoneClass);
    }
  }
}