---
title: Ceepub説明書
author: @takahashim
---

# Cheepubとは

Cheepubは、Markdownで書かれた文書を一発でEPUB3に変換するためのツールです。
基本的にはコマンドラインツール(CLI)ですが、ライブラリとしても使える……といいですね……。

## インストール

CheepubはRubyのgemとして実装されているので、gemコマンドでインストールします。対応しているRubyのバージョンは2.5.xですが、2.3くらいでも動きそうな気がします。

```console
gem install cheepub
```

[kramdown](https://kramdown.gettalong.org/)や[gepub](https://github.com/skoji/gepub)などのライブラリを使用していますが、どっちもpure Rubyのはずなのでそれほど環境依存などはないはず。
refinementsを使ってみたのでRuby 1.9とかでは動きません。もう2018年ですし、もう少し新し目のRubyをインストールして欲しいところです（2018年5月現在、2.1系以前のRubyは公式メンテナンスが終了しています。2.2系もそろそろ終わることになりそうです）。

## 使い方

Cheepubはコマンドラインで使うことを想定しています。

1. Markdownで文書をもりもり書く、あるいはMarkdownで書かれた文書を持ってくる
2. 必要に応じてメタデータと章分割の記述を追加する
3. 以下のようにcheepubコマンドを叩くと、EPUBファイルが生成される

```console
$ cheepub sample.md
```

## CheepubのMarkdownについて

基本方針は3つです。

* 「[でんでんマークダウン](https://conv.denshochan.com/markdown)みたいなやつ」が目標
* あまり頑張らない
    * 「でんでんマークダウン完全互換」とかは大変そうなので、簡単に実装できる範囲でやる
    * kramdownをベースにするので、でんでんマークダウンになくてもkramdownにある記法等は動くことはあるかも
* CLIでの使いやすさを重視
    * ブラウザでぽちぽち指定するのはめんどくさい（ユーザとしても実装者としても）
    * なので、Jekyllのfrontmatter的なものを導入しました。1ファイルで設定コミで完結しているのがポイントです

作者としてはろすさんリスペクトなので、でんでんマークダウンがそのまま使いたい！　という人は素直にでんでんコンバーターを使うことを強くおすすめします。
でんでんマークダウンとの互換性を高めるPull Requestをいただいても「ここまで頑張るのはちょっと…」という場合にはrejectさせていただくかもしれません。ご了承下さい。

### 改ページ（ファイル分割）

[でんでんマークダウン由来](https://conv.denshochan.com/markdown#docbreak)です。「半角のイコール記号「=」が3つ以上で構成される行があると、その前後でHTMLファイルを分割します。」というやつです。前後の空行を忘れないようにしてください。


### 縦中横

これも[でんでんマークダウン由来](https://conv.denshochan.com/markdown#tcy)です。`平成^30^年`みたいに書くと、縦書きでも「30」が横に並びます。
ただし、縦中横が使える文字はいわゆるASCIIの文字（のうち`^`以外）に限定しています。この限定はなくてもよかったかもしれません。

### 脚注

これはでんでんマークダウンというよりは[kramdownの機能](https://kramdown.gettalong.org/syntax.html#footnotes)をそのまま使っています。

### ルビ

これは[でんでんマークダウンのルビ](https://conv.denshochan.com/markdown#tcy)の縮小版です。グループルビだけ対応しています。

