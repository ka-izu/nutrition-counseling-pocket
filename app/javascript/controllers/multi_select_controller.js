import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="multi-select"
export default class extends Controller {
  // HTML 側で指定した target を定義
  // labels      : 選択済みバッジを表示する領域
  // placeholder : 「選択してください」のテキスト
  // inputs      : hidden input を挿入する領域（form送信用）
  static targets = ["labels", "placeholder", "inputs"]

  connect() {
    // 初期表示時、checked状態の checkbox をすべて拾う
    const checkedBoxes =
      this.element.querySelectorAll('input[type="checkbox"]:checked')

    checkedBoxes.forEach((checkbox) => {
      const id = checkbox.value
      const name = checkbox.dataset.name

      this.addBadge(id, name)
      this.addInput(id)
    })

    this.syncPlaceholder()
  }

  /**
   * checkbox がクリックされたときに呼ばれる
   * data-action="multi-select#toggle"
   */
  toggle(event) {
    const checkbox = event.target

    // 疾患ID（value 属性）
    const id = checkbox.value

    // 疾患名（data-name 属性）
    const name = checkbox.dataset.name

    if (checkbox.checked) {
      // チェック ON → バッジ追加 + hidden input 追加
      this.addBadge(id, name)
      this.addInput(id)
    } else {
      // チェック OFF → バッジ削除 + hidden input 削除
      this.removeBadge(id)
      this.removeInput(id)
    }

    // 選択数に応じて placeholder 表示を切り替える
    this.syncPlaceholder()
  }

  /**
   * 選択済みバッジを追加する
   */
  addBadge(id, name) {
    // すでに同じIDのバッジがあれば何もしない（二重防止）
    if (this.labelsTarget.querySelector(`[data-id="${id}"]`)) return

    // バッジ要素を生成
    const badge = document.createElement("span")
    badge.className = "badge badge-primary badge-sm"
    badge.dataset.id = id
    badge.textContent = name

    // バッジ表示エリアに追加
    this.labelsTarget.appendChild(badge)
  }

  /**
   * 選択済みバッジを削除する
   */
  removeBadge(id) {
    this.labelsTarget
      .querySelector(`[data-id="${id}"]`)
      ?.remove()
  }

  /**
   * form 送信用の hidden input を追加する
   */
  addInput(id) {
    // すでに同じ value の input があれば何もしない
    if (this.inputsTarget.querySelector(`input[value="${id}"]`)) return

    const input = document.createElement("input")
    input.type = "hidden"
    input.name = "teaching_material[disease_ids][]"
    input.value = id

    this.inputsTarget.appendChild(input)
  }

  /**
   * hidden input を削除する
   */
  removeInput(id) {
    this.inputsTarget
      .querySelector(`input[value="${id}"]`)
      ?.remove()
  }

  /**
   * 選択状態に応じて placeholder の表示 / 非表示を切り替える
   */
  syncPlaceholder() {
    this.placeholderTarget.classList.toggle(
      "hidden",
      this.labelsTarget.children.length > 0
    )
  }
}
