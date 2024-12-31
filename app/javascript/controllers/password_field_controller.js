import { Controller } from '@hotwired/stimulus';

// パスワードフィールドの表示/非表示を制御するコントローラー
export default class extends Controller {
  static targets = ['field', 'toggle'];

  connect() {
    // 初期状態は非表示
    this.fieldTarget.type = 'password';
    this.toggleTarget.dataset.slotValue = 'hide';
  }

  // パスワードの表示/非表示を切り替える
  toggle() {
    const isVisible = this.fieldTarget.type === 'text';
    this.fieldTarget.type = isVisible ? 'password' : 'text';
    this.toggleTarget.dataset.slotValue = isVisible ? 'hide' : 'show';
  }
}
