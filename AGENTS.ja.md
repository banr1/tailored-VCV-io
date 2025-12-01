# リポジトリガイドライン

## プロジェクト構成とモジュール整理
- `VCVio/`: オラクルを用いた暗号証明のコアフレームワーク。サブフォルダには暗号の基礎、操作的意味論、評価ツールが同じ名前空間でまとまっています。
- `Examples/`: 使用例となるプロトコル（OTP、Regev、HHS 変種など）。新しい構成要素を追加する際は、ここでのパターンを踏襲してください。
- `ToMathlib/`: upstream 取り込み候補や共有ユーティリティ。依存は最小限にし、mathlib の命名規則に合わせてください。
- `LibSodium/`: FFI ラッパーとバックエンドの `c/libsodium.cpp`（例: `SHA2.lean`, `MyAddTest.lean`）。外部コードはここに置き、必要なら `lakefile.lean` で新しいオブジェクトを登録します。
- `scripts/`: ビルド／リント用のユーティリティ（`build-project.sh`、`lint-style.sh`、レビュー用スクリプト）。ルートの `*.lean` はモジュールを再エクスポートします。ファイルを追加したら `scripts/update-lib.sh` を実行して同期を保ってください。ツールチェーンは `lean-toolchain` と `lakefile.lean` で Lean `v4.24.0-rc1` と mathlib `v4.24.0-rc1` に固定されています。

## ビルド・テスト・開発コマンド
- `lake exe cache get && lake build` — mathlib のキャッシュを取得し、デフォルトターゲット（`VCVio`, `Examples`）をビルドします。
- `lake build Examples` — `scripts/build-project.sh` で使う高速リビルド。
- `lake exe test` — `Test` デモ（サイコロ乱数 + `LibSodium` FFI）を走らせ、実行ファイルを簡易チェックします。
- `scripts/lint-style.sh` — Lean のスタイルリント（ドキュメント文字列、ヘッダ、100 文字以内、記法など）。やむを得ない場合のみ `scripts/style-exceptions.txt` を調整してください。
- `scripts/` 配下の Python ヘルパーは必要なら `pip install -r scripts/requirements.txt` を使います。

## コーディングスタイルと命名規則
- mathlib の Lean スタイルに従う: インデント 2 スペース、定義／補題は `snake_case`、名前空間はフォルダパスに対応する PascalCase、モジュールのドキュメント文字列は先頭に置く。
- `autoImplicit` は無効。束縛変数の型を明示し、長いタクティックブロックより小さな名前付き補題を好む。リンタを通すため行長は 100 文字以内。
- プロトコルやプリミティブ固有の補題は対応する `VCVio/...` 下に置き、`Examples/` は実例用に留める。

## テストに関する指針
- コンパイルがすなわち検証です。プッシュ前に `lake build` を実行してください。`LibSodium` や `Test.lean` に触った場合は `lake exe test` を使い、FFI の経路が生きているか確認します。
- 新しい実行可能デモを追加する場合は `lakefile.lean` に `lean_exe` を登録し、エントリポイントをルートの `*.lean` に置きます。IO の乱数は `OracleComp` で包んでください。

## コミットおよびプルリクエストの指針
- メッセージは簡潔かつ現在形で。履歴では `chore: bump ...` や `add ...` のような短い接頭辞が使われています。明確にするため `feat:`、`fix:`、`chore:` などを用いてください。
- PR には範囲の簡潔な概要、関連 issue、導入した仮定／暗号プリミティブ、新たに実行したコマンド（`lake build`、`scripts/lint-style.sh`、必要なら `lake exe test`）を含めてください。
- FFI/C++ の変更やキャッシュ更新があれば必ず言及し、レビュアに外部オブジェクトのリビルドが必要なことを伝えてください。***
