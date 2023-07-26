import { Controller } from "@hotwired/stimulus"
import ColorPicker from 'stimulus-color-picker'


export default class extends ColorPicker {

  static targets = [ 'input','button' ]

  connect() {
    super.connect()
    console.log('Do what you want here. ColorPicker')

    // Pickr instance
    this.picker
  }

  // Callback when the color is saved
  onSave(color) {
    super.onSave(color)
  }

  // You can override the components options with this getter.
  // Here are the default options.
  get componentOptions() {
    return {
      preview: true,
      hue: true,

      interaction: {
        input: true,
        clear: true,
        save: true,
      },
    }
  }

  // You can override the swatches with this getter.
  // Here are the default options.
  get swatches() {
    return [
      '#A0AEC0',
      '#F56565',
      '#ED8936',
      '#ECC94B',
      '#48BB78',
      '#38B2AC',
      '#4299E1',
      '#667EEA',
      '#9F7AEA',
      '#ED64A6',
    ]
  }
}