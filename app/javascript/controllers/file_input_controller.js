import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file-input"
export default class extends Controller {
  static targets = ["filename"]

  change(event) {
    const file = event.target.files[0]
    this.filenameTarget.textContent =
      file ? file.name : this.filenameTarget.dataset.placeholder
  }
}
