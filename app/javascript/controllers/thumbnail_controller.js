import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="thumbnail"
export default class extends Controller {
  static targets = ["skeleton"]

  loaded() {
    this.skeletonTarget.classList.add("hidden")
  }
}
