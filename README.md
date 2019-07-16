# SeaSolver - ウミガメのスープを解くサイト -

URL: https://www.seasolver.club
Vue側のGithub(https://github.com/fujiten/seasolver_front)

## 概要

「ウミガメのスープ」形式のクイズを出題・回答できるサイトです。ウミガメのスープとは、出題者から与えられた奇妙な状況に対し、「いかに少ない質問で、その状況の背景に隠された真実を解くことができるか」という視点で解くクイズです。

## 

## 開発環境

### クライアント層

- VueCLI(3.7.0)
  - Vue.js(2.6.10)
  - TailWindCSS(0.7.4)

### バックエンド層

- Docker (DockerCompose 3.3)
  - Ruby(2.6.2-alpine)
  - RailsAPI(6.0.0.rc1)
  - redis(3.2.12-alpine)
  - postgres(11.2)

### インフラ層

- Circle CI (CI/CDパイプライン)
- Heroku (本番環境)
  - PointDNS(クライアント層とバックエンド層のドメイン共通化)
- AWS S3 (画像アップロードストア)
- Redis(トークンストア)
- PostgreSQL(メインDB)

## 使用ライブラリ

### クライアント層

#### コア機能

- axios(0.18.0)
RailsAPIへの非同期通信のために使用しました。

- Vuex(3.1.1)
ユーザー情報をクライアント層で保持するために使用しました。

- vue-router(3.0.6)
ルーティングのために使用しました。

#### 周辺機能

- v-tooltip（カーソルを合わせたとき、詳細表示)
- v-modal（モーダル機能）
- vue-lazy-load（画像の遅延読み込み）
- vue-fontawesome（アイコン）

### バックエンド層(Gem)

- JWTSession(2.4.0)
SPAでのログイン認証、CSRF対策に使用しました。

- RSpec(3.8.0)
単体テスト、統合テストのために使用しました。

- Shrine(2.18.1)
画像アップロード機能のために使用しました。

- mini_magick(4.9.4)
画像編集機能のために使用しました。

### 機能

- クイズ投稿に関するCRUD

- 画像アップロード・プレビュー機能
実装手順：https://fujiten3.hatenablog.com/entry/2019/07/10/133132

- ログイン機能(セッション管理)
実装手順：https://fujiten3.hatenablog.com/entry/2019/07/13/130459


