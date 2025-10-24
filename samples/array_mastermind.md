#### スターター B：「アレイ・マスターマインド」 (42枚セット)

`Array` の多彩な操作と、`Integer` を `Array` リソースに変換する戦術を学べるセット。組み替えることで「最終系デッキB」を構築できます。

##### ▼ スターターB レシピ (30枚)
| カテゴリ | 枚数 | カード名 | 主な入力 $\rightarrow$ 主な出力 |
| :--- | :--- | :--- | :--- |
| **A. 主力** | 3枚 | `.digits` | Integer $\rightarrow$ Array |
| | 3枚 | `.uniq` | Array $\rightarrow$ Array |
| | 2枚 | `.flatten` | Array $\rightarrow$ Array |
| | 2枚 | `.compact` | Array $\rightarrow$ Array |
| | 1枚 | `.tally` | Array $\rightarrow$ Hash |
| | 1枚 | `.chars` | String $\rightarrow$ Array |
| **B. Utility** | 2枚 | `.to_s` | Any $\rightarrow$ String |
| | 2枚 | `.size` | Any $\rightarrow$ Integer |
| | 2枚 | `.sort` | Array/Hash $\rightarrow$ Array |
| | 1枚 | `.to_i` | Any $\rightarrow$ Integer |
| | 1枚 | `.sum` | String/Array $\rightarrow$ Integer |
| | 1枚 | `.last` | Array/Hash $\rightarrow$ Any |
| | 1枚 | `.sample` | Array/Hash $\rightarrow$ Any |
| | 1枚 | `.count` | Array/Hash $\rightarrow$ Integer |
| **C. 切り札** | 2枚 | `.map` | Array $\rightarrow$ Array |
| | 1枚 | `.group_by` | Array $\rightarrow$ Hash |
| **D. Generator** | 1枚 | `.push([10, 20])` | Array $\rightarrow$ Array |
| | 1枚 | `.concat([99, 98, 97])` | Array $\rightarrow$ Array |
| **合計** | **30枚** | | |

##### ▼ スターターB 追加カード (12枚)
| カテゴリ | 枚数 | カード名 | 主な入力 $\rightarrow$ 主な出力 |
| :--- | :--- | :--- | :--- |
| **A. 主力** | 1枚 | `.tally` | Array $\rightarrow$ Hash |
| | 1枚 | `.shuffle` | Array $\rightarrow$ Array |
| | 1枚 | `.keys` | Hash $\rightarrow$ Array |
| | 1枚 | `.values` | Hash $\rightarrow$ Array |
| | 1枚 | `.join` | Array $\rightarrow$ String |
| **B. Utility** | 1枚 | `.reverse` | String/Array $\rightarrow$ String/Array |
| | 1枚 | `.first` | Array/Hash $\rightarrow$ Any |
| | 1枚 | `.next` | Integer/String $\rightarrow$ String/Integer |
| **C. 切り札** | 1枚 | `.group_by` | Array $\rightarrow$ Hash |
| **D. Generator** | 1枚 | `.*(5)` | String/Array $\rightarrow$ String/Array |
| | 1枚 | `.merge({ "sym": :val })` | Hash $\rightarrow$ Hash |
| | 1枚 | `.scan(/../)` | String $\rightarrow$ Array |

