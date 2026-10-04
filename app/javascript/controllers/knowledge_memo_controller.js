import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="knowledge-memo"
export default class extends Controller {
  static targets = ["card"]

  select(event) {
    this.cardTargets.forEach((card) => {
      card.classList.remove("ring-2", "ring-primary")
    })

    const card = event.currentTarget.querySelector(
      "[data-knowledge-memo-target='card']"
    )

    card.classList.add("ring-2", "ring-primary")
  }
}
