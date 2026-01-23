import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="card-link"
export default class extends Controller {
  static values = {
    url: String,
    target: String
  }

  go(event) {
    // 削除・編集ボタンがクリックされた場合はカード遷移しない
    if (event.target.closest("a")) return

    if (this.targetValue === "_blank") {
      // 別タブで表示
      window.open(this.urlValue, "_blank", "noopener")
    } else {
      // 同タブで表示
      window.location.href = this.urlValue
    }
  }
}
