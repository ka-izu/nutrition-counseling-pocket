import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  static values = {
    timeout: Number
  };

  connect() {
    requestAnimationFrame(() => {
      this.element.classList.remove("opacity-0", "-translate-y-2");
      this.element.classList.add("opacity-100", "translate-y-0");
    });

    if (this.timeoutValue > 0) {
      this.timer = setTimeout(() => {
        this.close();
      }, this.timeoutValue);
    }
  }

  close() {
    this.element.classList.add("opacity-0", "-translate-y-2");

    setTimeout(() => {
      this.element.remove();
    }, 300);
  }

  disconnect() {
    if (this.timer) clearTimeout(this.timer);
  }
}
