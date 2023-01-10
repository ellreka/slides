---
theme: geist
title: 次世代のSlack App開発 「new Slack platform」について
class: unocss
fonts:
  sans: M PLUS 1p
  serif: M PLUS 1p
  mono: M PLUS 1p
---

<style>
  .cover h1 {
    font-size: 3rem;
  }
  ul {
    list-style: circle !important;
  }

  ol {
    list-style: decimal !important;
    margin-left: 1.5em !important;
  }

  ul ul {
    margin-left: 1em !important;
    list-style: disc !important;
  }
  .slidev-vclick-hidden {
    display: none !important;
  }
</style>

<h1 class="text-lg">次世代のSlack App開発<br /> 「new Slack platform」について</h1>

<p class="absolute bottom-10 right-10">@stanigome</p>

---

# new Slack platformとは

- Slack App を開発するための新しいプラットフォーム
- Denoで開発出来る
  - 型がしっかりサポートされている
  - 導入が簡単
- SlackのCloud上で動くので自分でサーバーを立てる必要が無い
- 専用のCLIも使うことでセットアップからデプロイまでが簡単

<div v-click="2" class="text-4xl font-bold mt-20 ml-20">
Easy x Fast x Secure
</div>

<div v-click="1" class="absolute right-10 bottom-10 w-80">

### Denoとは？

- TypeScriptを標準サポート
- node_modulesが無くnpm installがいらない
- Node.jsの作者が開発

<img class="bg-white/70 mt-3" src="https://raw.githubusercontent.com/denolib/high-res-deno-logo/master/deno_hr_circle.svg" />

</div>

<!--
new slack platformとは、先月くらいにパブリックβ版として発表された、Slack アプリを開発するための新しいプラットフォームです。

まず一番の特徴として、Denoで開発することが出来るという点です。

Denoとは何か簡単に説明すると、TypeScriptが標準サポートされたランタイムです。

node_modulesが無くて、npm installが必要ありません。

ここ数年とても注目されていて、Node.jsに取って代わるのではとも言われています。

そのため型がかなりサポートされているのでストレス無く開発することが出来ます。

更にサーバーがSlackのCloud上で動くので、自分でサーバーを建てる必要がありません。

今までは自分でAWSやGoogle App Scriptsを使って作っていたのですが、それらを用意する必要がなくなりました。

更に専用のCLIが提供されていて、それを使うことでセットアップからデプロイまでとても簡単に行うことが出来ます。

公式ページでは、Easy x Fast x Secureという3つのメリットを謳っています。
-->

---

# セットアップ

<div class="flex justify-between gap-5">

<div class="w-full self-center">

## CLIを使う

```js
// 雛形の作成
slack create my-app

// Triggerを設定
slack trigger create --trigger-def "triggers/greeting_trigger.ts"

// ローカル起動
slack run

// デプロイ
slack deploy
```

</div>

<img src="https://gyazo.com/389695d3fe9950e617957f3ccae29836.png" />

</div>

<!--
実際にセットアップする手順です。

先程上げたCLIを使います。

インストールや認証する手順の説明は省略しますが、まずslack create コマンドで右にあるような雛形が作成されます。

次にTriggerを設定しますが、これは後ほど説明します。

そしてslack runコマンドを実行すれば、実際にローカルにサーバーが立ち、開発に入ることが出来ます。

オートリロードなどもサポートされているので、これだけでなんの不便もなく開発できます。

で、開発が終わったらslack deployコマンドでワークスペースにアプリがインストールされ、Cloud上で動くようになります。
-->

---
layout: split
---

<div>

# 構成

- Functions

- Workflows

- Triggers

- Datastore

- Manifest

これらのパーツを組み合わせてアプリを作っていきます。

</div>

<img class="self-center" src="https://gyazo.com/095624c48277212591400ba48153097c.png" />

<!--
次にどのようにアプリが構成されているのかを説明します。

主に5つパーツがあり、これらのパーツを組み合わせることでアプリを作っていきます。
-->

---
layout: split
---

<div>

# Functions

様々なアクションをFunctionとして切り出します。

例: メッセージを送信する、ユーザーを取得する、など

</div>

<div class="">

*メッセージを送信する*

```ts {all|5-12|17-24}
export const FunctionDefinition = DefineFunction({
  callback_id: "function",
  title: "Post message function",
  source_file: "src/functions/function.ts",
  input_parameters: {
    properties: {
      userId: {
        type: Schema.slack.types.user_id,
      }
    },
    required: ["userId"],
  },
});
export default SlackFunction(
  FunctionDefinition,
  async ({ inputs, token }) => {
    const client = SlackAPI(token);
    client.chat.postMessage({
      channel: inputs.userId,
      text: "Hello!",
    });
    return {};
  }
);
```

</div>

<!--
Functionsとは、様々なアクションを切り出したものです。

例えば、メッセージを送信する、ユーザーを取得するなどです。

右のコードは、ユーザーに対してメッセージを送信するFunctionの例です。

まずDefineFunctionでFunctionを定義します。

そしてinput_parametersにこのFunctionが受け取りたい値を設定します。

次に受け取った値を元にpost message apiを叩いています。

APIを叩く際は、専用のライブラリが提供されていて、SlackAPIという関数にtokenを渡すだけで簡単に叩くことが出来ます。
-->

---
layout: split
---

<div>

# Workflows

Functionsを組み合わせ、実行する順番だったりを定義します。

Functionからのoutputを次のFunctionのinputとして渡すことができます。

build-in Functionsもあります。

https://api.slack.com/future/functions

</div>

<div>

*ユーザーからメンションを受け取り、そのメッセージをパースして返信する*

```ts {all|11-15|15-21}
const Workflow = DefineWorkflow({
  callback_id: "workflow",
  title: "workflow",
  input_parameters: {
    properties: {
       ...
      }
    },
    required: ["userId", "message"],
});
// メッセージを受け取ってパースする
const parsed = Workflow.addStep(ParseFunctionDefinition, {
  message: Workflow.inputs.message
});
// パースしたメッセージを送信する
Workflow.addStep(Schema.slack.functions.SendDm, {
  user_id: Workflow.inputs.userId,
  message: parsed.outputs.text,
});
```

</div>

<!--
次にWorkflowsです。

これは先程作成したFunctionsを組み合わせて、実行する順番だったりを定義します。

右のコードはユーザーからメンションを受け取り、そのメッセージをパースして返信するというような一連の処理が書かれたものです。

まずここでユーザから受け取ったメッセージをParseFunctionに渡し、メッセージをパースします。

次にパースされたメッセージをSendDmというFunctionに渡し、メッセージを送信します。

このSendDmというのは最初から用意されているFunctionでこのようなbuild-in Functionsも使うことが出来ます。
-->

---
layout: split
---

<div>

# Triggers

Workflowsが実行される条件を定義します。

**Link Triggers**

<span class="text-sm">発行されたURLをクリックするとWorkflowが実行されます。</span>

**Scheduled Triggers**

<span class="text-sm">毎日、毎週、毎月などの周期で定期実行されます。</span>

**Event Triggers**

<span class="text-sm">メンション、リアクションなどのイベントが発生したときに実行されます。</span>

**Webhook Triggers**

<span class="text-sm">発行されたURLに対してPOSTするとWorkflowが実行されます。</span>

</div>

<div>

*Link Trigger*

```ts
const LinkTrigger: Trigger<typeof Workflow.definition> = {
  name: "Sample App",
  type: "shortcut",
  workflow: "#/workflows/workflow",
  inputs: {
    userId: {
      value: "{{data.user_id}}",
    },
  },
};
```

*Event Trigger*

```ts
const EventTrigger: Trigger<typeof Workflow.definition> = {
  name: "Sample App",
  type: "event",
  workflow: "#/workflows/workflow",
  event: {
    event_type: "slack#/events/app_mentioned",
  }
};

```

</div>

<!--
次にTriggersです。

これは先程作ったWorkflowsがいつどのように実行されるかという条件を定義します。

Triggersは4種類あり、

まずLink Triggersは
-->

---
layout: split
---

<div>

# Datastore

Cloud上にDatastoreが用意されています。

`put`, `get`, `query` の3つの操作ができます。

DynamoDB syntaxが使えるので複雑な条件での検索も可能です。

</div>

<div>

*Datastoreの定義*

```ts
export const Datastore = DefineDatastore({
  name: 'datastore',
  primary_key: "id",
  attributes: {
    id: {
      type: Schema.slack.types.user_id,
    },
    foo: {
      type: Schema.types.string,
    },
  },
});
```

*データの取得*
```ts
const getDatastore = await client.apps.datastore.get<
  typeof Datastore.definition
>({
  datastore: 'datastore',
  id: inputs.userId,
});
```

</div>

<!--
次にDatastoreです。

今まではDBも自分で用意する必要があったのですが、Cloud上に用意されてるのでその必要が無くなりました。

まず右上のコードでDBのテーブル定義などを行い、それを参照してput,get,queryの3つの操作をすることが出来ます。
-->

---
layout: split
---

<div>

# Manifest

アプリの設定を定義します。

今までWeb上で行っていたものがコードで設定できるのでとても便利です。

</div>

<div class="self-center">

```ts
const definition: SlackManifestType = {
  runOnSlack: true,
  name: "sample bot",
  description: "",
  icon: "assets/icon.png",
  workflows: [Workflow, TokenWorkflow],
  types: [MessagesType],
  datastores: [MessageDatastore],
  botScopes: [
    "commands",
    "chat:write",
    "chat:write.public"
  ]
};
export default Manifest(definition);
```

</div>

<!--
最後にManifestです。

botScopeやiconなどアプリの設定を定義します。
-->

---

# 組み合わせる

<img class="w-2/3 mx-auto" src="https://gyazo.com/095624c48277212591400ba48153097c.png" />

<!--
でそれらを組み合わせることでアプリを作っていきます。

TriggerによってWorkflowが実行され、それに紐付いてFunctionが実行されるという流れです。
-->

---
layout: split
---

<div>

# 実際の例

「匿名で意見を投稿出来るアプリ」を作ってみます。

### 流れ

1. リンクをクリックしてフォームを開く
2. フォームを入力する
3. Botがチャンネルにその内容を投稿する

</div>

<div class="self-end">
<div v-click-hide="1"><img src="https://gyazo.com/d22b71efdf3f95e6d65026ff8f354f40.png" /></div>
<div v-click="1" class="w-2/3"><img class="" src="https://gyazo.com/5493e889cc0236dac686bd576f8d1ff1.png" /></div>
</div>

<!--
実際の例を示して説明します。

試しに「匿名で意見を投稿出来るアプリ」を作ってみます。

流れとしては

ユーザーがリンクをクリックしたら右のようなフォームが開き、

フォームを入力したらSubmitします。

その内容を元にBotがチャンネルにメッセージを投稿します。


図に表すとこんな感じです。

Link Triggerが呼ばれたらWorkflowが実行されて、フォームが開き、Submitしたらメッセージが生成されてそれを送信します。

このように、一連の動作をFunction単位で切り分けて箇条書することで、後はそれらを組み立てるだけで作ることが出来ます。
-->

---

# 失敗談

リアクションや返信をしていないメッセージ(見逃したメッセージ)を再通知するbotを作ったが・・・

<img class="mx-auto" src="https://gyazo.com/6936db7e6ee2f2aee58df1c467a32b1e.png" />

<!--
最後に失敗談を話して終わろうと思います。

このプラットフォームが発表されてすぐに、「リアクションや返信していないメッセージ、要するに見逃したメッセージを再通知するBot」を作りました。
-->

---

# 構成

<img src="https://gyazo.com/b3178a863af0bbbaf8f200aee698b301.png" />

<!--
構成はこんな感じで、

LinkをトリガーとしてSearch APIでメンションされたメッセージを検索し、そのメッセージに対してリアクションや返信したかを判定してしていなければ返すみたい処理をしています。

ですがSearch APIを使うために、user_tokenが必要で、そのためにAuth Serverを立てて認証が成功したらWebhook TriggerでDBに保存するみたいなことをしました。
-->

---

# new Slack platform では`まだ`出来ないこと

<div class="flex gap-10">

<div>

- OAuth2認証をしてuser_tokenを取得する処理をCloud内だけでは完結出来ない(認証サーバーを別途立てる必要がある)
- manifestにredirectUrlsを設定するとデプロイ出来ない(ローカルでは開発出来る)
- CLIからデプロイしたアプリは手動で設定することが出来ない
  - Client Idを取得できないのでそもそもOAuth2認証が出来ない
  - redirectUrlsを手動で設定することも出来ない

<span v-click class="text-red-400 text-lg">→user_tokenを使用したアプリは現状作ることが出来ない😥</span>

</div>

<div class="inline-flex flex-col gap-5 items-start">
<img src="https://gyazo.com/f92bb032f02b665fe3ad618cd7e10c79.png" />
<img class="" src="https://gyazo.com/d202c25839d4af8137bf146d38fcd2d2.png" />
</div>

</div>

<!--
ですが結論から言うとデプロイ出来ませんでした。

まず、OAuth2認証をしてuser_tokenを取得する処理をCloud無いだけで完結することが出来ません。
別途認証サーバーを建てる必要があります。

そして認証するためにはredirectURLが必要なのですがそれをmanifestに記載してデプロイするとエラーが出てデプロイすることが出来ません。

ローカルでは動いたのでデプロイするまで気づきませんでした。

更にデプロイ出来ないなら後から手動で設定すればいいじゃんと思ったのですが、右上の画像のように、CLIからデプロイしたアプリはWeb上で編集することが出来ませんでした。

なので、clientidを取得することも出来ないしredirectURLを設定することも出来ないので、

実質user_tokenを使用したアプリを作ることは現状できません。

このアプリはおとなしく別途サーバー立てて作り直そうと思います。
-->

---

# まとめ

<div class="mt-10">

まだβ版なので出来ないこともありますが、今後も開発が進んでいくと思います。

とても簡単にSlackアプリを作ることが出来るので、

アイデアがある人やDenoを触ってみたい人はぜひ作ってみてください！

</div>
