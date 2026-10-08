# データモデル設計

Supabase（PostgreSQL）を想定したテーブル設計。[requirements.md](./requirements.md) の記録項目を元に作成。

## ER 概要

```
users (Supabase Auth)
  └─< shoes（1人のユーザーが複数のシューズを持つ）
        ├─< shoe_photos（1足に複数の写真）
        └─< usage_records（1足に複数の使用記録）
```

## テーブル定義

### shoes（シューズ）

| カラム名 | 型 | 制約 | 説明 |
|---|---|---|---|
| id | uuid | PK, default gen_random_uuid() | シューズID |
| user_id | uuid | FK → auth.users.id, not null | 所有者（Supabase Auth のユーザー） |
| name | text | not null | シューズの名前（自分でつける呼び名） |
| brand | text | nullable | ブランド名（Nike, adidas, ASICS 等） |
| model | text | nullable | モデル名 |
| purchased_at | date | nullable | 購入日 |
| started_at | date | nullable | 使用開始日 |
| retirement_distance_km | numeric | not null, default 500 | 買い替え目安距離（km） |
| status | text | not null, default 'active', check (status in ('active', 'retired')) | ステータス（使用中／引退済み） |
| memo | text | nullable | メモ |
| created_at | timestamptz | not null, default now() | 作成日時 |
| updated_at | timestamptz | not null, default now() | 更新日時 |

- 累計走行距離はこのテーブルには持たせず、`usage_records` から都度算出する（最新レコードの `total_distance_km` を参照）
  - 参照頻度が高い場合はキャッシュ用カラム（例: `current_distance_km`）の追加を後日検討

### shoe_photos（シューズ写真）

| カラム名 | 型 | 制約 | 説明 |
|---|---|---|---|
| id | uuid | PK, default gen_random_uuid() | 写真ID |
| shoe_id | uuid | FK → shoes.id, not null, on delete cascade | 対象シューズ |
| storage_path | text | not null | Supabase Storage 上のパス |
| sort_order | integer | not null, default 0 | 表示順・アニメーション用の並び順 |
| is_primary | boolean | not null, default false | 一覧表示に使うメイン写真かどうか |
| created_at | timestamptz | not null, default now() | 作成日時 |

- アニメーション表示（例: 複数写真を使ったコマ送り・モーフィング等）を見据え、1足に複数枚の写真を持てる構成とし `sort_order` で並び順を管理する
- 具体的なアニメーション実現方式（Framer Motion / GSAP / Three.js 等）によって必要なカラムが増える可能性あり（技術選定後に見直す）

### usage_records（使用記録）

| カラム名 | 型 | 制約 | 説明 |
|---|---|---|---|
| id | uuid | PK, default gen_random_uuid() | 記録ID |
| shoe_id | uuid | FK → shoes.id, not null, on delete cascade | 対象シューズ |
| recorded_at | date | not null | 記録日（いつ時点の情報か） |
| total_distance_km | numeric | not null | その時点での累計走行距離（km） |
| memo | text | nullable | メモ（任意） |
| source | text | not null, default 'manual', check (source in ('manual', 'api')) | 入力方法（手入力／将来の API 連携用） |
| created_at | timestamptz | not null, default now() | 作成日時 |

- 「ランごとの記録」ではなく「距離を更新した時点のスナップショット」を1行として保存する
- `source` カラムは将来 Strava 等の API 連携を追加した際に、手入力データと区別するために用意しておく（今回の実装スコープでは常に `manual`）
- シューズの現在の累計走行距離は「`shoe_id` ごとに `recorded_at` が最新のレコードの `total_distance_km`」として取得する

## RLS（Row Level Security）方針

- 全テーブル共通で `user_id`（`shoe_photos`, `usage_records` は `shoes` 経由）が自分自身のものである場合のみ SELECT / INSERT / UPDATE / DELETE を許可する
- 本アプリはユーザーごとに閉じたデータのため、他ユーザーのデータが見える・書き換えられることがないようにする

## 今後の検討事項

- 買い替え目安距離（`retirement_distance_km`）に達した際の通知方法（UI上のバッジ表示のみで十分か、メール通知等まで必要か）
- 写真アニメーションの実現方式が決まり次第、`shoe_photos` テーブルの項目を見直す
- 累計距離の参照頻度次第で `shoes` テーブルにキャッシュ用カラムを追加するか判断
