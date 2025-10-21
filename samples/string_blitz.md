### サンプルデッキ A：「ストリング・ブリッツ」

* **コンセプト:** 文字列の生成、変換、加工に特化した高速デッキ。String関連のお題を迅速に達成し、相手の場をStringに変換して妨害する戦略を得意とします。
* **得意分野:** String型全般、StringとArray間の変換。

| カテゴリ | メソッド名 (レシーバー→戻り値) | 採用枚数 |
| :------- | :----------------------------- | :------- |
| **A. 主力 (Main Force)** |                                |          |
| String → Array       | `.split`                       | 3枚      |
|                      | `.chars`                       | 1枚      |
| Array → String       | `.join`                        | 3枚      |
|                      | `.to_s` (Arrayレシーバー用)      | 2枚      |
| String → String      | `.upcase`                      | 3枚      |
|                      | `.downcase`                    | 1枚      |
|                      | `.reverse` (Stringレシーバー用)  | 1枚      |
|                      | `.strip`                       | 1枚      |
|                      | `.capitalize`                  | 1枚      |
| Numeric → String     | `.to_s` (Numericレシーバー用)    | 3枚      |
| String → Integer     | `.to_i`                        | 2枚      |
| Array → Integer      | `.sum`                         | 1枚      |
| **B. ユーティリティ (Utility)** |                                |          |
| String/Array/Hash → Integer | `.size`                     | 1枚      |
| Any → String         | `.inspect`                     | 1枚      |
| String → String      | `.swapcase`                    | 1枚      |
| Array → Any          | `.first`                       | 1枚      |
| Array → Hash         | `.tally`                       | 1枚      |
| **C. 切り札 (Trump Cards)** |                                |          |
| Array → Array        | `.map` (Power Play)            | 1枚      |
| **合計** |                                | **30枚** |
