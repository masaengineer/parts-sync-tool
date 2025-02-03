// Entry point for the build script in your package.json
import '@hotwired/turbo-rails';
import './controllers';
import 'simplebar/dist/simplebar.css';
import SimpleBar from 'simplebar';

// Lucideアイコンセットの読み込み
import 'iconify-icon';
import { addIcon } from 'iconify-icon';
import * as lucideIcons from '@iconify/icons-lucide';

// アイコンの登録
Object.entries(lucideIcons).forEach(([name, data]) => {
  addIcon(`lucide:${name}`, data);
});

document.addEventListener('DOMContentLoaded', () => {
  // SimpleBarの初期化
  document.querySelectorAll('[data-simplebar]').forEach((el) => {
    new SimpleBar(el);
  });
});

// パスワードフィールドの表示/非表示切り替え
document.addEventListener('turbo:load', () => {
  const passwordFields = document.querySelectorAll(
    '[data-component="password-field"]'
  );

  passwordFields.forEach((field) => {
    const input = field.querySelector('input');
    const toggle = field.querySelector('[data-slot="visibility-toggle"]');

    if (toggle && input) {
      toggle.addEventListener('click', () => {
        const currentType = input.type;
        const newType = currentType === 'password' ? 'text' : 'password';
        input.type = newType;
        toggle.dataset.slotValue = newType === 'password' ? 'hide' : 'show';
      });
    }
  });
});
