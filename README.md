Versatile TRNG IP Core for Evaluation on PYNQ Platform
======================================================

For English description, please refer to <a href="README.en.md">README.en.md</a>.

概要
----

このリポジトリには，各種の真性乱数生成回路の評価を PYNQ プラットフォーム
上で行うための，汎用 IP コアが含まれています．

リポジトリは以下のディレクトリから構成されます．

- `core`: TRNG IP コアのフォルダ（`xgui` フォルダと `component.xml` は Vivado によって生成される）
  - `src`: Verilog HDL/SystemVerilog で記述されたコントローラの回路記述
    - `user`: ユーザ定義の TRNG のプロトタイプ
- `python`: データ収集のための Python スクリプトの例
- `samples`: ユーザ定義の TRNG のサンプル
  - `TC-TERO`: <a href="https://github.com/nfproc/TC-TERO">遷移効果リングオシレータ</a>に基づく TRNG
  - `latch`: <a href="https://doi.org/10.1587/elex.15.20180386">ラッチのメタスタビリティ</a>に基づく TRNG
  - `C_COSO`: <a href="https://doi.org/10.1109/FPL.2019.00041">再構成可能リングオシレータを用いたコヒーレントサンプリング</a>に基づく TRNG
    - リポジトリ作者による再実装であり，論文中で述べられている自動較正のためのコントローラを含まない
    - オリジナルのソースコードは <a href="https://github.com/KULeuven-COSIC/COSO-TRNG">KULeuven-COSIC/COSO-TRNG</a>
- `docs`: コアの仕様とユースケース

IP コアは PYNQ プラットフォーム (v2.7) 上での乱数ストリーム収集に適するように
設計されています．Vivado 2020.2 および PYNQ-Z1 ボードで動作確認しています．

PYNQ で利用するためのオーバーレイを作成する方法，データ収集方法について，
詳しくは <a href="https://www.acri.c.titech.ac.jp/wordpress/archives/11585">2021/5/10 掲載の ACRi ブログの記事</a>で紹介しています．

著作権
------

本リポジトリの Verilog HDL, SystemVerilog, Python の全てのファイルは，
<a href="https://aitech.ac.jp/~dslab/nf/">藤枝 直輝</a>により開発されました．
ライセンスは New BSD です．詳しくは，COPYING ファイルを参照してください．

Copyright (C) 2018-2022 Naoki FUJIEDA. All rights reserved.