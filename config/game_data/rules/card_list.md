## メソッドカード

### A. 主力
*デッキに各種3枚まで*

| メソッド名 | 主な入力 → 主な出力 |
| :--- | :--- |
| `.chars` | String → Array |
| `.digits` | Integer → Array |
| `.flatten` | Array → Array |
| `.join` | Array → String |
| `.keys` | Hash → Array |
| `.last` | Array → Object/NilClass |
| `.sample` | Array → Object/NilClass |
| `.split` | String → Array |
| `.upcase` | String → String |

### B. ユーティリティ
*デッキに各種2枚まで*

| メソッド名 | 主な入力 → 主な出力 |
| :--- | :--- |
| `.compact` | Array/Enumerable/Hash → Array |
| `.count` | Array/Enumerable/Hash → Integer |
| `.first` | Array/Enumerable → Object/NilClass |
| `.inspect` | 色々 → String |
| `.reverse` | Array/String → Array/String |
| `.size` | Array/Hash/String → Integer |
| `.sort` | Array/Enumerable → Array |
| `.sum` | Array/Enumerable/String → Integer |
| `.tally` | Enumerable → Hash |
| `.to_i` | Float/NilClass/String → Integer |
| `.to_s` | 色々 → String |
| `.uniq` | Array/Enumerable → Array |

### C. ジェネレーター
*デッキに各種1枚まで*

| メソッド名 | 主な入力 → 主な出力 |
| :--- | :--- |
| `.concat(".rb")` | String → String |
| `.concat([99, 98, 97])` | Array → Array |
| `.push([10, 20])` | Array → Array |
| `.scan(/../)` | String → Array |

### D. 切り札
*デッキに各種2枚まで*

| メソッド名 | 主な入力 → 主な出力 |
| :--- | :--- |
| `.group_by` | Array → Hash |
| `.map` | Array/Enumerable → Array |

## レシーバーカード

1.  `" Hello World "` (String)
2.  `"1,2,3,4,5"` (String)
3.  `"Ruby_Chains"` (String)
4.  `"no Ruby, no life"` (String)
5.  `[10, nil, "bug", 20]` (Array)
6.  `["Method", "Class", "Object", "Method"]` (Array)
7.  `[1, [2, 3], 4]` (Array)
8.  `{year: 2025, month: 12, date: 25, version: "3.5.0"}` (Hash)
9.  `{1 => "Integer", 1.0 => "Float", "key" => "String"}` (Hash)
10. `{ false => "Game Over", :score => [10, 5, -2], 100 => :bonus }` (Hash)

## 要求カード

1. 全て大文字の`String`にせよ。 / 全ての要素が Integer である`Array`にせよ。
2. 10 以上の`Integer`にせよ。 / キー (key) に String を含む `Hash`にせよ。
3. 10 文字以上の`String`にせよ。 / 要素数が 5 個以上の`Array`にせよ。
4. 0 (ゼロ)の`Integer`にせよ。 / キー (key) が Integer である`Hash`にせよ。
5. 重複する要素を含む `Array`にせよ。 / 数字 (0-9)を含む`String`にせよ。
6. 値 (value) に Integer を含む`Hash`にせよ。 / 3 桁以上 (100 以上) の`Integer`にせよ。
7. 空 (Empty)の`Array`にせよ。 / 空 (Empty)の`String`にせよ。
8. 要素数が 3 以下の`Array`にせよ。 / 値 (value) が Array である`Hash`にせよ。
9. `Hash`にせよ。 / 1 文字の`String`にせよ。
10. 全ての要素が同じ`Array`にせよ。 / キーと値が同じ`Hash`にせよ。
