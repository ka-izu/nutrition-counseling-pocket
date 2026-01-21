import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sticky-header"
export default class extends Controller {
  static values = {
    shadowClass: String
  }

  connect() {
    this.onScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.onScroll)

    // 初期状態（リロード対策）
    this.onScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
  }

  onScroll() {
    if (window.scrollY > 12) {
      this.element.classList.add(this.shadowClassValue)
    } else {
      this.element.classList.remove(this.shadowClassValue)
    }
  }
}
