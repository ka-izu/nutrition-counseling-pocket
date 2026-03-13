import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ai-loading"
export default class extends Controller {
  static targets = ["button"]

  start() {
    this.buttonTarget.disabled = true

    this.buttonTarget.innerHTML = `
      <span class="loading loading-ring loading-sm"></span>
      アドバイスを生成しています...
    `

    const result = document.getElementById("advice_result")

    result.innerHTML = `
      <div class="card bg-base-200 shadow-md mt-6">
        <div class="card-body">
          <div class="space-y-3">
            <div class="skeleton h-4 w-3/6"></div>
            <div class="skeleton h-4 w-4/6"></div>
            <div class="skeleton h-4 w-4/6"></div>
          </div>

        </div>
      </div>
    `
  }

  finish() {
    this.buttonTarget.disabled = false

    this.buttonTarget.innerHTML = `
      アドバイスのヒントを確認する
    `
  }
}
