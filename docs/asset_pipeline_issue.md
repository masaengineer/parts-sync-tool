# Rails7 アセットパイプライン ビルド問題の分析

## プロジェクト構成

### 環境

- Rails 7
- esbuild
- Docker 環境
- Node.js v20.18.1
- yarn 1.22.22

### 主要な依存関係

```json
{
  "devDependencies": {
    "esbuild": "^0.24.0"
  },
  "dependencies": {
    "@hotwired/stimulus": "^3.2.2",
    "@hotwired/turbo-rails": "^8.0.12",
    "@iconify/icons-lucide": "^1.2.135",
    "lucide-static": "^0.469.0",
    "simplebar": "^6.2.7"
  }
}
```

## 現在の問題

### エラー内容

```
✘ [ERROR] No matching export in "node_modules/lucide-static/dist/esm/lucide-static.js" for import "icons"

    app/javascript/application.js:9:9:
      9 │ import { icons } from 'lucide-static';
        ╵          ~~~~~
```

### 関連するコード

```javascript
// app/javascript/application.js
import '@hotwired/turbo-rails';
import './controllers';
import './nexus';
import 'simplebar/dist/simplebar.css';
import SimpleBar from 'simplebar';

// Lucideアイコンセットの読み込み（静的インポート）
import { icons } from 'lucide-static';

document.addEventListener('DOMContentLoaded', () => {
  // SimpleBarの初期化
  document.querySelectorAll('[data-simplebar]').forEach((el) => {
    new SimpleBar(el);
  });

  // Lucideアイコンの初期化
  Object.entries(icons).forEach(([name, icon]) => {
    const elements = document.querySelectorAll(`[data-lucide="${name}"]`);
    elements.forEach((element) => {
      element.innerHTML = icon;
    });
  });
});
```

## 試行済みの対応

1. `@iconify/icons-lucide`と`@iconify/iconify`パッケージのインストール
2. `lucide-static`パッケージへの切り替え
3. 各パッケージの削除と再インストール

## 分析のポイント

1. esbuild のモジュール解決の問題
2. パッケージの ESM エクスポート形式の互換性
3. Docker コンテナ内での Node.js モジュールの解決方法
4. アセットパイプラインの設定

## 解決のための質問

1. `lucide-static`パッケージの正しいインポート方法は何か？
2. esbuild の設定で追加が必要なオプションはあるか？
3. Docker コンテナ内でのパッケージ解決に問題はないか？
4. 代替となるアイコンパッケージの選択肢はあるか？

## 期待される解決策の方向性

1. パッケージのインポート方法の修正
2. esbuild の設定調整
3. 代替パッケージの検討
4. アセットパイプラインの設定見直し
