import { Controller } from '@hotwired/stimulus';

// フラッシュメッセージを制御するコントローラー
export default class extends Controller {
  connect() {
    // 5秒後に自動的にメッセージを非表示にする
    setTimeout(() => {
      this.element.classList.add('opacity-0');
      setTimeout(() => {
        this.element.remove();
      }, 500);
    }, 5000);
  }

  // 手動で閉じるボタンの処理
  close() {
    this.element.classList.add('opacity-0');
    setTimeout(() => {
      this.element.remove();
    }, 500);
  }
}
