# logo
工学研究部のロゴ

![logo](assets/logo.svg)
![logo all](assets/logo.svg#$)

以下の識別子が画像に対応
|      |       |     |
|:----:|:-----:|:---:|
|  ` ` |  `!`  | `_` |
|  `-` |  `-!` |     |
| `-_` | `-!_` |     |

`wrangler dev`

`localhost:8787/logo.svg#<識別子>`

`localhost:8787/logo.png?<識別子>`

## langs
- [SVG](./assets/logo.svg)
  - PNG: use wrangler or [`svg2png.mjs`](./tools/svg2png.mjs) to get
- [SVG (thin for OpenSCAD)](./assets/logo_scad.svg)
  - [OpenSCAD](./assets/logo.scad)
    - [STL](./assets/logo.stl)
- [GLSL (3D SDF)](./assets/logo.glsl)
- [PNG (16x16)](./assets/logo_16.png)


## design
- red: `#f12`
- light: `#fff`
- dark: `#222`

```
キャンバス: 20x20
パス定義域: 24x24
線幅: 1
[
  直線[傾斜=1/4]
  円[半径=6]
  円[半径=10]
]
```
![logo design](assets/logo.svg#d)

## ガイドラインFAQ
### 切り抜くときは?
丸く切り抜くことを想定してあるので、`四角~丸`の間の図形であればそのまま切り抜ける。

### 色の指定は?
工研そのものにかかわるものにはなるべく赤色`#f21`を使う。

形だけ保てば工研であることは伝わるはずなので、そこまでとらわれなくても良いと思う。

### <ここに無い疑問>?
issueでもPRでも遠慮なく立ててね

## 使用場面の例
- 白ロゴ: ` `
  - 団体としての工研
- 黒ロゴ: `!`
  - 工研の共用アカウント
- モノクロ系ロゴ: `-` `-!`
  - 工研の派生物

## tools
- circle.mjs
  calculate arcs of `研`
- svg2png.mjs
  png renderer with `re-svg`
