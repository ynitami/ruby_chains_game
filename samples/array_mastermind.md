### サンプルデッキ B：「アレイ・マスターマインド」

* **コンセプト:** 配列の加工、整理、集計に特化した制御型デッキ。Array関連のお題を確実に達成し、強力なフィルタリングや集計で優位に立ちます。`Hash`への変換も可能です。
* **得意分野:** Array型全般、ArrayからHash、ArrayからInteger。

| カテゴリ | メソッド名 (レシーバー→戻り値) | 採用枚数 |
| :------- | :----------------------------- | :------- |
| **A. 主力 (Main Force)** |                                |          |
| String → Array       | `.split`                       | 2枚      |
|                      | `.chars`                       | 1枚      |
| Array → String       | `.join`                        | 2枚      |
|                      | `.to_s` (Arrayレシーバー用)      | 1枚      |
| Array → Array        | `.sort`                        | 3枚      |
|                      | `.uniq`                        | 3枚      |
|                      | `.flatten`                     | 1枚      |
|                      | `.compact`                     | 2枚      |
|                      | `.reverse` (Arrayレシーバー用)   | 1枚      |
| Hash → Array         | `.keys`                        | 1枚      |
|                      | `.values`                      | 1枚      |
| Array → Integer      | `.sum`                         | 3枚      |
| Array → Hash         | `.tally`                       | 1枚      |
| **B. ユーティリティ (Utility)** |                                |          |
| Array → Any          | `.first`                       | 1枚      |
| String/Array/Hash → Integer | `.size`                     | 1枚      |
| Integer → Array      | `.times`                       | 1枚      |
| Any → String         | `.inspect`                     | 1枚      |
| **C. 切り札 (Trump Cards)** |                                |          |
| Array → Array        | `.map` (Power Play)            | 2枚      |
| Array → Hash         | `.group_by` (Power Play)       | 1枚      |
| **合計** |                                | **30枚** |
