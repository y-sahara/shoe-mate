# 競合アプリ調査

## 主要ランニングアプリ（Nike / adidas / ASICS / Strava）

| アプリ名 | シューズ管理機能 |
|---|---|
| Nike Run Club (NRC) | 「シューズタギング」機能でシューズごとの走行距離（マイレージ）を追跡可能。ランニング記録そのものが主機能で、シューズ管理は付随機能 |
| adidas Running（旧 Runtastic） | 「Shoe Tracking」機能を搭載。シューズごとの距離を記録・監視。Garmin / Polar / Amazfit 等の外部デバイスとも連携可能 |
| ASICS Runkeeper | 複数シューズを登録し、アクティビティごとに使用シューズを選択可能。目標距離を設定すると到達時に通知。「Me」タブでシューズごとの距離を確認。ASICS公式サイトへの買い替え導線あり |
| Strava | プロフィール設定内の「Gear」でシューズを登録し、距離を自動集計。摩耗時に警告通知。ただし**アクティビティごとに使用シューズを手動選択する必要があり**、設定を忘れると精度が落ちる。この弱点を補う形で TreadLeft や SubRunGear といったサードパーティ連携アプリも存在 |

## その他の調査対象アプリ

| アプリ名 | 特徴 |
|---|---|
| SHOOZ | シューズ専用トラッカー。写真付きコレクション管理、距離目標設定、新規アクティビティの自動検出通知。Strava/Runna/Garmin/Runkeeper/Apple Watch と連携 |
| Sole Signal: Shoe Tracker | Apple Health 連携で自動的に走行距離を集計。買い替えアラートあり。無料版は1足まで |
| Shoe Tracker | Apple Health 連携（ランニング・ウォーキング・ハイキング・ジム・自転車に対応）。アクティビティ種別に応じてシューズを自動割り当て |
| Sole Insights | シンプルな UI。手入力した距離を自動集計 |
| ShoeMile: Shoe Mileage | Apple Health 連携で自動記録、または手動でも距離をタップ入力可能 |
| ShoeStack: Track Shoe Distance | 走行距離の追跡に特化した専用アプリ |

## 共通して見られる機能

- シューズごとの累計走行距離の記録・可視化
- 外部サービス（Apple Health、Strava、Garmin、Runkeeper 等）との連携による自動記録
- 複数のシューズを登録し、コレクションとして管理（写真付き）
- 走行距離の上限目安（一般的に **500km 前後**）に基づく買い替え時期の通知・アラート
- 手動での距離入力にも対応（連携なしでも使える）
- アクティビティごとに使用シューズを選択する運用（Strava, Runkeeper）→ 選び忘れると記録精度が落ちるという弱点がある
- Nike / adidas はランニング記録アプリが主体で、シューズ管理は数ある機能の一つという位置づけ（シューズ管理特化ではない）

## 本アプリとの差別化ポイント（案）

- 他アプリは「距離の自動集計・通知」が中心で、写真の見せ方は静止画のコレクション表示が主流
  → **写真からのアニメーション表示** は差別化要素になり得る
- Nike / adidas / Strava / Runkeeper はランニング記録アプリの付随機能としてシューズ管理を提供しており、シューズそのものを主役にした体験ではない
  → **シューズ管理・愛着を持たせることに特化したアプリ** という立ち位置が差別化になる
- 外部サービス連携は後回しにし、まずは手動記録（写真・距離）とアニメーション表示に集中する方針でよさそう

## 参考リンク

- [Nike Run Club (App Store)](https://apps.apple.com/JP/app/id387771637)
- [adidas Running: Run tracker (App Store)](https://apps.apple.com/app/id336599882)
- [ASICS Runkeeper - Shoe Tracking (ヘルプ)](https://help.runkeeper.com/en/hc/shoe-tracking)
- [Runkeeper 新シューズトラッカー体験](https://runkeeper.com/ja/app/new-shoe-tracker-experience/)
- [Strava Shoe Tracking の活用方法](https://myshoesreview.com/?p=2923)
- [9000万人が利用するランニングアプリ「Runtastic」にシューズ・トラッキング機能が追加](https://www.atpress.ne.jp/news/108568)
- [SHOOZ (App Store)](https://apps.apple.com/ru/app/id6476882229)
- [Sole Signal: Shoe Tracker (App Store)](https://apps.apple.com/app/id6759836431)
- [Sole Insights (App Store)](https://apps.apple.com/us/app/-/id1671377783)
- [ShoeMile: Shoe Mileage (App Goblin)](https://appgoblin.info/apps/6793815636)
- [ShoeStack: Track Shoe Distance (App Store)](https://apps.apple.com/app/id6739989272)

## 今後の検討事項（更新）

- 記録項目の詳細（距離・日付・メモ・シューズの状態など）を、上記の共通機能を参考に決定
- 走行距離の目安（500km等）を基にした買い替えアラート機能を検討するか判断
- 写真アニメーションの実現方式（CSS アニメーション／Lottie／その他）
- 上記を踏まえて画面設計・データモデル設計を進める
