## Google 認証実装のデバッグ記録

### 1. データベースの問題

#### 症状

- エラーメッセージ: `PG::UndefinedColumn: ERROR: column users.provider does not exist`
- Google 認証時にデータベースエラーが発生

#### 原因

- `users`テーブルに必要なカラム（`provider`と`uid`）が存在しなかった

#### 解決策

1. マイグレーションファイルの作成

```bash
docker compose run --rm web rails generate migration AddOmniauthToUsers provider:string uid:string
```

2. マイグレーションの実行

```bash
docker compose run --rm web rails db:migrate
```

### 2. 環境変数の問題

#### 症状

- エラーメッセージ: "Missing required parameter: client_id"
- Google 認証時にクライアント ID が見つからないエラーが発生

#### 原因

- 環境変数（`GOOGLE_CLIENT_ID`と`GOOGLE_CLIENT_SECRET`）がアプリケーションに正しく渡されていなかった

#### 解決策

1. `docker-compose.yml`の修正

```yaml
environment:
  GOOGLE_CLIENT_ID: ${GOOGLE_CLIENT_ID}
  GOOGLE_CLIENT_SECRET: ${GOOGLE_CLIENT_SECRET}
```

2. 環境変数の確認

```bash
docker compose run --rm web rails runner "puts ENV['GOOGLE_CLIENT_ID']; puts ENV['GOOGLE_CLIENT_SECRET']"
```

### 3. 日本語翻訳の問題

#### 症状

- エラーメッセージ: "Translation missing: ja.devise.omniauth_callbacks.success"
- ログイン成功時の日本語メッセージが表示されない

#### 原因

- Devise の日本語翻訳ファイルに必要な翻訳が不足していた

#### 解決策

1. `config/locales/devise.ja.yml`に翻訳を追加

```yaml
omniauth_callbacks:
  success: '%{kind}アカウントによる認証に成功しました。'
  failure: '%{kind}アカウントによる認証に失敗しました（%{reason}）。'
```

### 4. プロフィール画像の表示

#### 症状

- Google 認証後のプロフィール画像が表示されない
- デフォルトアイコンが常に表示される

#### 原因

- ヘッダーコンポーネントでプロフィール画像の表示ロジックが未実装

#### 解決策

1. `app/views/components/navigation/_header.html.erb`の修正

```erb
<% if user_signed_in? && current_user.profile_picture_url.present? %>
  <%= image_tag current_user.profile_picture_url, alt: current_user.full_name %>
<% else %>
  <div class="w-full h-full bg-base-300 flex items-center justify-center">
    <iconify-icon icon="lucide:user" width="16" height="16" class="text-base-content/50"></iconify-icon>
  </div>
<% end %>
```

### 学んだこと

1. 環境変数の設定は、開発環境でも Docker 環境でも正しく反映される必要がある
2. データベースのマイグレーションは、既存のカラムとの重複に注意する
3. 多言語対応は、ユーザー体験に重要な影響を与える
4. UI コンポーネントは、認証システムと密接に連携する必要がある
