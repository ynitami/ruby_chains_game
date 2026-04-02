import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  async updateCounter(url, field, delta) {
    const csrfToken = document.querySelector("meta[name='csrf-token']")?.content
    const response = await fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-Token": csrfToken,
        "Accept": "text/html"
      },
      body: `field=${field}&delta=${delta}`
    })

    if (response.ok) {
      const html = await response.text()
      const container = this.element.closest("[id^='player_counter_']")
      if (container) container.innerHTML = html
    }
  }

  increment(event) {
    const { url, field } = event.currentTarget.dataset
    this.updateCounter(url, field, 1)
  }

  decrement(event) {
    const { url, field } = event.currentTarget.dataset
    this.updateCounter(url, field, -1)
  }
}
