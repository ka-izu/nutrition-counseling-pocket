import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="card-link"
export default class extends Controller {
  static values = {
    url: String
  }

  go(event) {
    // 親要素（.card）へのクリックイベント伝播を止める
    if (event.target.closest("[data-stop-card-link]")) {
      event.stopPropagation()
      return
    }

    window.location.href = this.urlValue
  }
}
