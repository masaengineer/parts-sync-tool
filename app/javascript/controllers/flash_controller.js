import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dismissButton"]

  // フラッシュメッセージを閉じる
  dismiss(event) {
    const flashMessage = event.target.closest(".alert")
    flashMessage.remove()
  }

  // 自動的に消えるタイマーを設定
  connect() {
    setTimeout(() => {
      this.element.remove()
    }, 5000)  // 5秒後に自動的に消える
  }
}
