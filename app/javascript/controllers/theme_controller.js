import { Controller } from '@hotwired/stimulus';

// テーマ切り替えを管理するコントローラー
export default class extends Controller {
  connect() {
    // 初期テーマの設定
    this.setTheme(localStorage.getItem('theme') || 'light');
  }

  // テーマ切り替えアクション
  toggle() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';
    this.setTheme(newTheme);
  }

  // テーマを設定する関数
  setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
  }
}
