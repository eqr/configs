#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'

# --- Helpers ---
backup() {
  local dst=$1
  [[ -e $dst && ! -L $dst ]] &&
    mv "$dst" "${dst}.bak_$(date +%Y%m%d%H%M%S)"
}

ensure_dir() {
  mkdir -p "$(dirname "$1")"
}

attempt() {
  local desc=$1
  shift
  if ! "$@"; then
    echo "Warning: failed to $desc" >&2
  fi
}

# --- List of src|dst pairs (unquoted here-doc so vars expand) ---
read -r -d '' LINKS <<EOF
$HOME/code/configs/karabiner|$HOME/.config/karabiner
$HOME/code/configs/zshrc|$HOME/.zshrc
$HOME/code/configs/vimrc|$HOME/.vimrc
$HOME/code/configs/ideavimrc|$HOME/.ideavimrc
$HOME/code/configs/config.fish|$HOME/.config/fish/config.fish
$HOME/code/configs/aerospace/aerospace.toml|$HOME/.config/aerospace/aerospace.toml
$HOME/code/configs/claude/CLAUDE.md|$HOME/.claude/CLAUDE.md
$HOME/code/configs/claude/commands|$HOME/.claude/commands
EOF

# --- Create symlinks ---
while IFS='|' read -r src dst; do
  {
    ensure_dir "$dst"
    backup "$dst"
    ln -sfn "$src" "$dst"
    echo "Linked: $dst → $src"
  } || echo "Warning: linking $dst" >&2
done <<<"$LINKS"

# --- Special case: copy only if example exists ---
EX="$HOME/.config/nvim/lua/user_example"
DESTDIR="$HOME/.config/nvim/lua"
if [[ -e $EX ]]; then
  attempt "copy nvim example" cp -n "$EX" "$DESTDIR/user"
else
  echo "Skipping nvim example: $EX not found" >&2
fi

# --- Per-file nvim symlinks ---
for f in plugins/neo-tree.lua init.lua; do
  src="$HOME/code/configs/nvim/lua/user/$f"
  dst="$HOME/.config/nvim/lua/user/$f"
  {
    ensure_dir "$dst"
    backup "$dst"
    ln -sfn "$src" "$dst"
    echo "Linked: $dst → $src"
  } || echo "Warning: linking $dst" >&2
done

# --- Fish functions symlinks ---
FISH_FUNCTIONS_SRC="$HOME/code/configs/fish/functions"
FISH_FUNCTIONS_DST="$HOME/.config/fish/functions"
if [[ -d "$FISH_FUNCTIONS_SRC" ]]; then
  ensure_dir "$FISH_FUNCTIONS_DST"
  for f in "$FISH_FUNCTIONS_SRC"/*.fish; do
    [[ -f "$f" ]] || continue
    fname=$(basename "$f")
    src="$f"
    dst="$FISH_FUNCTIONS_DST/$fname"
    backup "$dst"
    ln -sfn "$src" "$dst"
    echo "Linked: $dst → $src"
  done
fi
