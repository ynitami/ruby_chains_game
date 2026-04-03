import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  switchTab(event) {
    const index = parseInt(event.currentTarget.dataset.index)

    this.tabTargets.forEach((tab, i) => {
      if (i === index) {
        tab.classList.add("text-red-700", "border-b-2", "border-red-700")
        tab.classList.remove("text-gray-500")
      } else {
        tab.classList.remove("text-red-700", "border-b-2", "border-red-700")
        tab.classList.add("text-gray-500")
      }
    })

    this.panelTargets.forEach((panel, i) => {
      panel.classList.toggle("hidden", i !== index)
    })
  }
}
