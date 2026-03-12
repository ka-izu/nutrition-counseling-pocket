import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="counter"
export default class extends Controller {
  static targets = ["input", "count"]

  update() {
    this.countTarget.textContent = this.inputTarget.value.length
  }
}
