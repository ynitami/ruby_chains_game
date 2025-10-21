### サンプルデッキ C：「ハッシュ・プロセッサー」

| カテゴリ | メソッド名 (レシーバー→戻り値) | 採用枚数 |
| :------- | :----------------------------- | :------- |
| **A. 主力 (Main Force)** |                                |          |
| String → Integer     | `.to_i`                        | 1枚      |
| Array → Integer      | `.sum`                         | 1枚      |
| Numeric → String     | `.to_s` (Numericレシーバー用)    | 3枚      |
| Array → String       | `.to_s` (Arrayレシーバー用)      | 2枚      |
| Array → Hash         | `.tally`                       | 3枚      |
| **B. ユーティリティ (Utility)** |                                |          |
| Hash → Hash          | `.invert`                      | 1枚      |
| String/Array/Hash → Integer | `.size`                     | 1枚      |
| Any → String         | `.inspect`                     | 1枚      |
| Integer → Array      | `.times`                       | 1枚      |
| **C. 切り札 (Trump Cards)** |                                |          |
| Array → Hash         | `.group_by` (Power Play)       | 1枚      |
| Hash → Hash          | `.transform_values` (Power Play) | 2枚      |
| Array → Array        | `.map` (Power Play)            | 1枚      |
| **合計** |                                | **30枚** |

*(戦略: `.tally` や `.group_by` で積極的に Hash を生成。Hash 操作カード (`.keys`, `.values`, `.invert`, `.transform_values`) を駆使し、トリッキーなお題達成や型変換を狙う。`.map` などで Array 操作にも対応)*
