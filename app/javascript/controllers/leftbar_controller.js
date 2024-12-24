import { Controller } from '@hotwired/stimulus';

// 左サイドバーの開閉を管理するコントローラー
export default class extends Controller {
  static targets = ['sidebar'];

  // サイドバーの開閉を切り替え
  toggle() {
    this.sidebarTarget.classList.toggle('hidden');
    this.sidebarTarget.classList.toggle('lg:flex');
  }
}
