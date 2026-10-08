# 実装フェーズ

ランニングシューズ管理アプリの実装コードを格納するフォルダです。

## 構成

- `app/` — React + Vite + TypeScript のアプリ本体

## セットアップ

```bash
cd app
npm install
cp .env.example .env   # Supabase の URL / Anon Key を設定
npm run dev
```

## 技術スタック

[../02_technical/technical.md](../02_technical/technical.md) を参照。

- フロントエンド: React + Vite（TypeScript）
- デプロイ先: Cloudflare Pages（予定）
- DB / 認証 / ストレージ: Supabase（`@supabase/supabase-js`）
- アニメーション: framer-motion（導入済み、必要に応じて Three.js を部分導入）
