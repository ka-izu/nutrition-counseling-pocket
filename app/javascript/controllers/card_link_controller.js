import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="card-link"
export default class extends Controller {
  static values = {
    url: String
  }

  go(event) {
    // 削除・編集ボタンがクリックされた場合はカード遷移しない
    if (event.target.closest("a")) return

    window.location.href = this.urlValue
  }
}
