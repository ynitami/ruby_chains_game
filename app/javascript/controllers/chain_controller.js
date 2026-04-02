import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "receiverSelect", "chainDisplay", "executeBtn",
    "resultArea", "wildModal", "meta"
  ]

  connect() {
    this.chain = []           // [{ id, name, wild?, procId?, procName? }]
    this.pendingWildId = null
    this.pendingWildName = null
  }

  get executeUrl() {
    return this.metaTarget.dataset.executeUrl
  }

  get csrfToken() {
    return this.metaTarget.dataset.csrf
  }

  get receiverId() {
    return this.receiverSelectTarget.value
  }

  get receiverLabel() {
    const opt = this.receiverSelectTarget.selectedOptions[0]
    return opt?.dataset?.label || ""
  }

  // === レシーバー変更 ===
  onReceiverChange() {
    this.chain = []
    this.renderChain()
    this.resultAreaTarget.classList.add("hidden")
    this.resultAreaTarget.innerHTML = ""
  }

  // === メソッド追加 ===
  addMethod(event) {
    const { cardId, cardName, wild } = event.currentTarget.dataset

    if (wild === "true") {
      this.pendingWildId = cardId
      this.pendingWildName = cardName
      this.wildModalTarget.classList.remove("hidden")
      return
    }

    this.chain.push({ id: cardId, name: cardName })
    this.renderChain()
  }

  // === 切り札: 単体 ===
  wildIdentity() {
    this.chain.push({
      id: this.pendingWildId,
      name: this.pendingWildName,
      wild: true
    })
    this.closeWildModal()
    this.renderChain()
  }

  // === 切り札: Proc引数 ===
  wildWithProc(event) {
    const { procId, procName } = event.currentTarget.dataset
    const procMethodName = procName.replace(/^\./, "")
    this.chain.push({
      id: this.pendingWildId,
      name: `${this.pendingWildName}(&:${procMethodName})`,
      wild: true,
      procId: procId
    })
    this.closeWildModal()
    this.renderChain()
  }

  closeWildModal() {
    this.wildModalTarget.classList.add("hidden")
    this.pendingWildId = null
    this.pendingWildName = null
  }

  // === チェインからメソッド削除 ===
  removeMethod(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    this.chain.splice(index, 1)
    this.renderChain()
  }

  // === チェイン表示の更新 ===
  renderChain() {
    const display = this.chainDisplayTarget
    const hasReceiver = this.receiverId !== ""

    this.executeBtnTarget.disabled = !hasReceiver || this.chain.length === 0

    if (!hasReceiver) {
      display.innerHTML = '<span class="text-gray-400">レシーバーを選択してください</span>'
      return
    }

    let html = `<span class="bg-blue-100 text-blue-800 px-2 py-0.5 rounded text-xs">${this.escapeHtml(this.receiverLabel)}</span>`

    this.chain.forEach((entry, i) => {
      html += `<button data-action="click->chain#removeMethod" data-index="${i}"
                       class="bg-gray-100 text-gray-700 px-2 py-0.5 rounded text-xs hover:bg-red-100 hover:text-red-700 transition-colors"
                       title="クリックで削除">${this.escapeHtml(entry.name)}</button>`
    })

    if (this.chain.length === 0) {
      html += '<span class="text-gray-400 text-xs ml-2">メソッドを選択してください</span>'
    }

    display.innerHTML = html
  }

  // === 実行 ===
  async execute() {
    if (!this.receiverId || this.chain.length === 0) return

    this.executeBtnTarget.disabled = true
    this.executeBtnTarget.textContent = "実行中..."

    const methodEntries = this.chain.map(entry => {
      if (entry.wild && entry.procId) {
        return { wild: entry.id, proc: entry.procId }
      }
      return entry.id
    })

    try {
      const response = await fetch(this.executeUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({
          receiver_id: this.receiverId,
          method_entries: methodEntries
        })
      })

      const result = await response.json()
      this.renderResult(result)
    } catch (e) {
      this.renderResult({ success: false, error_message: `通信エラー: ${e.message}`, steps: [] })
    } finally {
      this.executeBtnTarget.disabled = false
      this.executeBtnTarget.textContent = "実行"
    }
  }

  // === 結果描画 ===
  renderResult(result) {
    const area = this.resultAreaTarget
    area.classList.remove("hidden")

    if (result.success) {
      const final = result.final_result
      area.innerHTML = `
        <div class="bg-green-50 border border-green-200 rounded-lg p-4">
          <div class="text-xs text-green-600 font-medium mb-1">結果</div>
          <div class="font-mono text-sm text-green-900 break-all">${this.escapeHtml(final.value)}</div>
          <div class="text-xs text-green-600 mt-1">(${this.escapeHtml(final.class_name)})</div>
          ${this.renderSteps(result.steps, true)}
        </div>`
    } else {
      const errorStep = result.error_at_step
      area.innerHTML = `
        <div class="bg-red-50 border border-red-200 rounded-lg p-4">
          <div class="text-xs text-red-600 font-medium mb-1">エラー (ステップ${errorStep})</div>
          <div class="font-mono text-xs text-red-800 break-all">${this.escapeHtml(result.error_message)}</div>
          ${this.renderSteps(result.steps, false)}
        </div>`
    }
  }

  renderSteps(steps, success) {
    if (!steps || steps.length === 0) return ""

    let html = `<details class="mt-3"><summary class="text-xs text-gray-500 cursor-pointer">中間結果を表示</summary><ol class="mt-2 space-y-1 text-xs font-mono">`
    steps.forEach((step, i) => {
      html += `<li class="flex items-start gap-2">
        <span class="text-gray-400">${i + 1}.</span>
        <span class="text-gray-600">${this.escapeHtml(step.method)}</span>
        <span class="text-gray-400">&rarr;</span>
        <span class="text-gray-800 break-all">${this.escapeHtml(step.value)}</span>
        <span class="text-gray-400">(${this.escapeHtml(step.class_name)})</span>
      </li>`
    })
    html += `</ol></details>`
    return html
  }

  escapeHtml(str) {
    if (!str) return ""
    const div = document.createElement("div")
    div.textContent = str
    return div.innerHTML
  }
}
