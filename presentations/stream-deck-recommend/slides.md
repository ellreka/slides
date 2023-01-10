---
# try also 'default' to start simple
theme: eloc
title: 'Stream Deck のススメ'
class: 
fonts:
  sans: 'M PLUS 1p'
  serif: 'M PLUS 1p'
  mono: 'M PLUS 1p'
---

<style>
* {
  @apply font-sans !important;
}
h1 {
  @apply text-5xl !important;
}
h2 {
  @apply text-4xl !important;
}
p,ul {
  @apply text-3xl my-2 !important;
}
img {
  @apply rounded-2xl h-auto w-auto;
}
.slidev-code-wrapper, pre {
  @apply w-full !important;
}
</style>

# `Stream Deck のススメ`

<p class="absolute bottom-10 right-10">stanigome</p>

---

<div class="flex items-start gap-5">
<div class="flex flex-col gap-5">
  <h1><code>Stream Deck とは</code></h1>
  <p>様々な機能を割り当てることが出来るマルチボタンデバイス。いわゆる左手デバイスです。</p>
  <p>元々ライブ配信用に作成されたデバイスですが仕事に使う人も増えています。</p>
</div>
<img src="https://gyazo.com/48e5e16e15cdfbae316880cd3186ad67.jpg" class="w-1/2" />
</div>

---
class: items-start
---

# `出来ること`

* フォルダを開く
* シェルコマンドの実行
* ショートカットキーの実行
* 定型文の登録
* 様々なアプリと連携
* ライブ配信(音楽の切り替え、シーンの切り替え、効果音を入れるetc...)

---

# `設定画面`

<img src="https://gyazo.com/cc8c4b77e33ac00f700d8607d6f8e521.png" class="h-9/10" />

---
class: items-start
---

# `使用例`

## 出勤・退勤の自動化

* 自分で作成した自動打刻CLIツールを実行しています。
* 同時にSlackの退勤スタンプを設定しています。

## マイクのミュート

* マイクのミュートのオンオフを切り替えることが出来ます。
* MTG中いちいちブラウザ上でミュートするのは面倒くさいし見ただけで今の状態がわかるので便利です。

## Toggl Track

* Togglというタスク管理ツールの更新を行います。
* ブラウザで変更するのは面倒なのでよく忘れてしまいますが、これならすぐ切り替えられます。

---

<div class="flex items-start gap-5">
<div class="flex flex-col gap-5">
  <h1><code>自作プラグインの紹介</code></h1>
  <p>Slackのステータスを変更するプラグインです。</p>
  <p><a href="https://github.com/ellreka/streamdeck-slack-status">https://github.com/ellreka/streamdeck-slack-status</a></p>
</div>
<img src="https://gyazo.com/8b7dd16f9d9388b4572edb9e9a517c65.png" class="w-full" />
</div>

---

# `プラグインの作り方`

---
class: items-start
---

# `ディレクトリ構成`

```json
├── com.example.plugin-name.sdPlugin // ビルド済みファイル
│   ├── images
│   │   └── icon.png
│   │   └── icon@2x.png
│   ├── manifest.json
│   ├── code.html
│   └── code.js
│   └── pi.html
│   └── pi.js
│   └── sdpi.css
├── src
│   └── code.ts // プラグインのメイン処理を書くファイル
│   └── pi.ts // Property Inspector。プラグインの設定ページ
├── package.json
```

---
class: items-start
---

# `Property Inspector`

プラグインの設定ページ。

色々なUIが用意されていてそれらを組み合わせて作成します。

メイン処理とのやり取りはWebSocketで行います。

# `Main`

PIから受け取ったアクションを実行します。

ここでAPIを叩いたりします。

---
class: items-start
---

# `デバッグ方法`

defaultsコマンドでデバッグモードをオンにします。

```bash
defaults write com.elgato.StreamDeck html_remote_debugging_enabled -bool YES
```

その後 <http://localhost:23654/> にアクセスするとDevToolsやログを見ることが出来ます。



---
class: items-start
---

# `esbuildを使ってTypeScriptをコンパイルする`

`esbuild` では複数ファイルをそれぞれ別々にコンパイルすることが出来ないので `concurrently` を使って並列処理しています。

→ これ書いてて気づいたけど `esbuild src/{pi,main}.ts --outdir=net.ellreka.slack-status.sdPlugin --target=esnext` でいける気がする。

```json
"scripts": {
    "build:main": "esbuild ./src/main.ts --bundle --outfile=./net.ellreka.slack-status.sdPlugin/main.js --target=esnext",
    "build:pi": "esbuild ./src/pi.ts --bundle --outfile=./net.ellreka.slack-status.sdPlugin/pi.js --target=esnext",
    "dev": "yarn concurrently \"yarn build:main --watch\" \"yarn build:pi --watch\"",
    "build": "yarn build:main && yarn build:pi",
}
```

---
class: items-start
---

# `パッケージをビルドする`

専用のビルドツールを使ってパッケージをビルドします。

```bash
DistributionTool -b -i net.ellreka.slack-status.sdPlugin -o ~/Desktop/
```

成功すれば `net.ellreka.slack-status.streamDeckPlugin` というファイルが生成されます。

私はGithub Actionsで自動化しています。注意点としてMacOSかWindowsでしか動作しないのでOSを設定する必要があります。

```yml
jobs:
  build:
    runs-on: macos-latest
```

https://github.com/ellreka/streamdeck-slack-status/blob/main/.github/workflows/build.yml

---

<div class="flex items-start gap-5">
<div class="flex flex-col gap-5">
  <h1><code>プラグインを公開する</code></h1>
  <p>開発者ページなどが無いので、公開する場合はelgato社にメールで連絡する必要があります。</p>
  <p>必要事項を入力してメールして、OKをもらうと公開してくれます。</p>
  <p>私の場合「APIキーの取得方法を追加したほうが良いんじゃない」みたいなアドバイスをくれました。</p>
</div>
<img src="https://gyazo.com/74ae4e7f5fed1424cde7dad472272ccb.png" class="h-4/5" />
</div>

---

# `3つ目のデバイスという選択肢`

<div class="flex items-start gap-5">
<div class="flex flex-col gap-5">
  <h1><code>Loupedeck Live</code></h1>
  <img src="/loupedeck.png" class="w-8/10" />
</div>
<div class="flex flex-col gap-5">
  <h1><code>StreamDeck Pedal</code></h1>
  <img src="/stream-deck-pedal.jpg" class="" />
</div>
</div>
