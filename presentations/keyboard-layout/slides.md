---
theme: geist
title: キーボード沼 ~レイアウト編~
layout: center
fonts:
  sans: M PLUS 1p
  serif: M PLUS 1p
  mono: M PLUS 1p
---
<h1 class="">キーボード沼 ~レイアウト編~</h1>

<p class="absolute bottom-10 right-10 text-lg">s.tanigome</p>

---

## 趣旨

<p class="text-3xl font-bold mt-30">キーボードに興味を持ってほしい</p>

---
layout: center
---

## 💡普段どんなキーボードを使っていますか？

---

## QWERTY配列

<div class="relative">
<img src="https://gyazo.com/f77ca4344999cc4f675a361c77452342.png" />
<span v-click class="border-red-500 absolute top-13 left-20 border-5 w-380px h-18"></span>
</div>

---
layout: center
---

## 🤔なんでこんなデタラメな配置なんだろう...

---
layout: center
---

## 理由

<div class="mt-10">

- QWERTYはタイプライターの技術的な限界から打鍵速度を落としてアームの衝突を防ぐために考え出された配列だという説
- 最も続けて打つことが多い文字、TとHのタイプバー(アームとも呼ばれるTypebar)を遠くに離すことで、内部の機械の故障を起こしにくくしたという説
- 既存配列に特許が絡み、それを回避していく内に現在の配列になった説

<a href="https://ja.wikipedia.org/wiki/QWERTY">wikipediaより引用</a>
</div>

<p v-click class="text-2xl mt-10 font-bold">→使いやすさを考えて作られたものではなさそう...</p>

---
layout: center
---

## 使用率ほぼ100%

---
layout: center
---

## もっと良い配列、あります

---

## Dvorak配列

- 左手に母音が固まっている
- 左右交互に指を動かすので、速く打てて疲れにくい

<div class="relative">
<img src="https://gyazo.com/269a2fe0289279bd57d68f20fb39a5da.png" />
<span v-click class="border-red-500 absolute top-28 left-20 border-5 w-320px h-18"></span>
</div>

---

## デメリット

<div class="mt-10"></div>

- 英語に特化した配列なので日本語入力には向かない
- Ctrl+CやCtrl+Vなどのショートカットが使いにくい
  - → Ctrl,Alt,Cmdを押してる間だけQWERTY配列にすることで解決
- Vimでのカーソル移動(HJKL)が大変

<img src="https://gyazo.com/269a2fe0289279bd57d68f20fb39a5da.png" class="absolute bottom-5 right-5 h-200px w-auto" />

---

## Eucalyn配列

- 日本語入力に特化
- ショートカットキーがそのまま使える
- [計測結果](https://yushakobo.jp/blog/pluis9/2017/12/thinkkeylayout)の数値が良い

<img src="https://gyazo.com/7d9f66cd5826047f70b4ef94f5db8f36.png" class="w-650px h-auto m-auto absolute bottom-5 right-5 -z-10 opacity-90" />

---

## 配列の変更方法

### Macの場合

- システム環境設定 > キーボード > 入力ソース > + > Dvorak
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) を使う

### Winの場合

- [DvorakJ](https://blechmusik.xii.jp/dvorakj/) を使う

---
layout: center
---

## 実際変更すべきなの？

---

## おすすめしません！😫

<div class="mt-10"></div>

- 仕事しながらは無理
- QWERTY配列が使えなくなる
- 自分以外のPCを触れなくなる
- PCゲーム(WASD移動)が出来なくなる

など...デメリットがたくさん

<p class="text-2xl font-bold mt-20 text-red-300">→よっぽど興味がない限り変えないほうがいい</p>

---
layout: center
---

## とはいえどんなもんか試してみたい

---

## 気軽に色々な配列を試せるサイトを作った

### Let's Try Keyboard Layouts!

https://lets-try-keyboard-layouts.ellreka.net/

紹介記事

https://zenn.dev/ellreka/articles/lets-try-keyboard-layouts

<img src="https://gyazo.com/9db742dc7682848ef22a998a7a9af5b5.png" class="absolute bottom-5 right-5 w-[45%]" />

---

## 終わりに

<div class="mt-20 text-2xl">

プログラマにとってキーボードは体の一部です。

そんなキーボードに少しはこだわってみませんか？

</div>

---

## 次回

<p class="text-2xl">「キーボード沼 ~自作キーボード編~」・・・？</p>

<img src="https://gyazo.com/16196e4ad63fb93de5e986df20be9076.jpg" class="h-350px w-auto mx-auto" />
