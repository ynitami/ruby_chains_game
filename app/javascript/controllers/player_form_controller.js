import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["countInput", "countBtn", "nameFields"]

  setCount(event) {
    const count = parseInt(event.currentTarget.dataset.count)
    this.countInputTarget.value = count

    // ボタンのスタイル更新
    this.countBtnTargets.forEach(btn => {
      const btnCount = parseInt(btn.dataset.count)
      if (btnCount === count) {
        btn.classList.add("bg-red-700", "text-white", "border-red-700")
        btn.classList.remove("bg-white", "text-gray-700")
      } else {
        btn.classList.remove("bg-red-700", "text-white", "border-red-700")
        btn.classList.add("bg-white", "text-gray-700")
      }
    })

    // 名前フィールドの表示/非表示
    this.nameFieldsTarget.querySelectorAll(".player-name-field").forEach(field => {
      const idx = parseInt(field.dataset.index)
      field.style.display = idx < count ? "" : "none"
    })
  }

  connect() {
    // 初期状態: 2人を選択
    const btn = this.countBtnTargets.find(b => b.dataset.count === "2")
    if (btn) btn.click()
  }
}
