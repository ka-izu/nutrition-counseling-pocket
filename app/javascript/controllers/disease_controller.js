import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="disease"
export default class extends Controller {
  toggle(event) {
    const clicked = event.target

    if (!clicked.checked) return

    this.element.querySelectorAll('input[type="checkbox"]').forEach(box => {
      if (box !== clicked) {
        box.checked = false
      }
    })
  }
}
