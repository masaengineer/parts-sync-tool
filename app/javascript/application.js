// Entry point for the build script in your package.json
import '@hotwired/turbo-rails';
import './controllers';
import './nexus';
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
