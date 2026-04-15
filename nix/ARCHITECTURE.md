# Nix setup architecture

## ファイル構成

```
nix/
├── flake.nix          # エントリ: 外部依存を取り込み、設定を2つexport
├── user.nix           # 個人情報 (gitignored)
├── user.example.nix   # user.nix のテンプレ (committed)
├── darwin.nix         # macOS システム層
└── home.nix           # ユーザー層 (macOS / Linux 共通)
```

## データフロー

```
user.nix (username / email / hostname / system)
    ↓
flake.nix が読み込み → specialArgs で渡す
    ↓
    ├─→ darwin.nix (macOS のみ)   … system 設定 + casks
    └─→ home.nix  (両OS)           … user 設定 + CLI ツール
```

## flake.nix が出力するもの

- `darwinConfigurations.mac` — macOS 用。`darwin.nix` + `home.nix` +
  `nix-homebrew` を合成
- `homeConfigurations."ho0897@linux"` — Linux 用。`home.nix` 単体

`install-nix.sh` が `uname -s` で振り分ける。

## 各モジュールの責務

### darwin.nix (macOS のみ)

- `homebrew.casks = [ ghostty vivaldi docker-desktop ... ]` — GUI アプリ
  (Nix で扱えない macOS 特有のもの)
- `system.defaults.NSGlobalDomain.KeyRepeat = 2` などの macOS 設定
- Touch ID sudo
- `nix.enable = false` — Determinate installer との共存
- `homebrew.onActivation.cleanup = "none"` — 手動 brew 管理物を壊さない

### home.nix (ユーザー層・両OS共通)

- `home.packages` — CLI ツール群 (git / gh / tmux / fzf / ripgrep / bat /
  eza / neovim / delta / lazygit / yazi + deps / mise / gum 等)
- `xdg.configFile."git/nix.inc"` — gitconfig の portable 部分だけ
  (personal は `~/.gitconfig.local` 経由)
- `xdg.configFile."mise/conf.d/nix.toml"` — mise baseline runtimes
  (node / python / go 等)
- `home.activation.miseInstall` — rebuild 時に `mise install` 実行
- `home.activation.cloneNvim` / `cloneTpm` — nvim config / tpm を git clone
  (宣言の手が届かない複雑設定は外出し)
- `programs.git` / `programs.gh` — **無効化**
  (perpet / 手動管理と衝突するため)

## 基本方針

- **パッケージ**: Nix に寄せる (`home.packages`)
- **dotfiles 本体** (.zshrc / .tmux.conf / .gitconfig 等): perpet が担当
- **衝突点** (.gitconfig / gh config): Nix はファイルを出さず、include 先
  (`nix.inc`) や baseline (`mise conf.d`) だけ出す
- **非Nix的ツール** (nvim / tmux plugins): git clone のままにして、Nix は
  トリガだけ担当
- **実ランタイム版** (node / python / ...): mise が管理、Nix は「最低
  これは入れて」リストを渡すだけ

## レイヤ図

```
┌─ macOS system ────────────────────────────┐
│  nix-darwin (defaults + casks)            │  ← darwin.nix
├─ user profile ────────────────────────────┤
│  home-manager (CLI tools + config files)  │  ← home.nix
├─ runtime manager ─────────────────────────┤
│  mise (node / python / ...)               │  ← conf.d/nix.toml +
│                                           │    `mise install`
├─ dotfiles ────────────────────────────────┤
│  perpet (.zshrc, .gitconfig, etc.)        │  ← home/*
├─ plugins ─────────────────────────────────┤
│  Lazy.nvim / tpm (git cloned)             │  ← home.activation hooks
└───────────────────────────────────────────┘
```
