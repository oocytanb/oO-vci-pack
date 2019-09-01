# cytanb-anim-cam

- アニメーションでカメラを動かすための、VCI のテンプレートです。
- PV 撮影など、カメラワークを事前に作っておく場合に使えるかもしれません。
- Unity 上でカメラ追従用のオブジェクトに対して、アニメーションを作成して利用します。
- 試作段階につき、予告なく機能更新されることがあります。
- 間違いや使いづらい点などがございましたら、適宜修正してお使いください。

## オブジェクトの階層構造

### 階層
![Unity-hierarchy](docs/unity-hierarchy.png)

### `cytanb-anim-cam`: ルートオブジェクト
![cytanb-anim-cam](docs/unity-inspector-cytanb-anim-cam.png)

- [anim-cam-main.lua](scripts/anim-cam-main.lua) ファイルを、`VCI Object` コンポーネントのスクリプトとして指定します。

- `conf` 変数を編集することで、カメラ、アニメーション、オブジェクトの構成に合わせてカスタマイズすることが出来ます。VCI を設置すると同時に、再生開始するように設定することも出来ます。詳細はスクリプトファイルをご覧ください。

### `anim-cam-container`: カメラマーカーのコンテナーオブジェクト
![anim-cam-container](docs/unity-inspector-anim-cam-container.png)

- アニメーションを行うためのコンポーネントを追加しています。VCAS 1.7.2a で導入された仕組みを利用します。

### `anim-cam-marker`: カメラマーカーオブジェクト
![anim-cam-marker](docs/unity-inspector-anim-cam-marker.png)

- カメラを追従させるためのマーカーオブジェクトです。

- このオブジェクトをアニメーションで、位置と回転させると、スクリプトがカメラの位置と回転を合わせるようになっています。

- ユーザーごとにローカルで処理するため、`VCI Sub Item` コンポーネントは付けません。

### `anim-cam-switch`: カメラアニメーションの再生・停止の切り替えスイッチ
![anim-cam-switch](docs/unity-inspector-anim-cam-switch.png)

- グリップすることで、カメラアニメーションの再生・停止の切り替えを行います。

- `VCI Sub Item`, `Collider`, `Rigidbody` コンポーネントが必要です。

- 装着できるようにする場合は、`VCI Attachable` コンポーネントを追加することが出来ます。

## Download

Git の扱いに慣れていない方は、[Unity package](https://www.dropbox.com/s/grgq7396uxmwn9n/cytanb-anim-cam-0.0.2.vci.unitypackage?dl=0) を利用することが出来ます。
