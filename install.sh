#!/usr/bin/env bash
# install.sh — symlink this harness's skills, hooks, MCP configs, and settings
# fragments into Claude Code and Codex. Idempotent; safe to re-run.
#
# Usage:
#   ./install.sh                  # symlink everything
#   ./install.sh --dry-run        # preview only

set -euo pipefail

DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    *) echo "Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
info()    { echo -e "${GREEN}[install]${NC} $1"; }
warning() { echo -e "${YELLOW}[warning]${NC} $1"; }

link() {
  local src="$1" dst="$2"
  if $DRY_RUN; then
    echo "  [dry-run] symlink $src -> $dst"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warning "Backing up existing $dst -> ${dst}.before-harness"
    mv "$dst" "${dst}.before-harness"
  fi
  ln -sfn "$src" "$dst"
  info "Linked: $dst -> $src"
}

echo ""
echo "Installing AI harness from: $HARNESS_DIR"
[[ $DRY_RUN == true ]] && echo "(dry run — no changes will be made)"
echo ""

# ── Skills: Claude Code + Codex ────────────────────────────────────────────
for skill_dir in "$HARNESS_DIR/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  link "$skill_dir" "$HOME/.claude/skills/$skill_name"
  link "$skill_dir" "$HOME/.codex/skills/$skill_name"
done

# ── Hooks (Claude Code only — Codex has no hook system yet) ────────────────
if [[ -d "$HARNESS_DIR/hooks" ]]; then
  for hook in "$HARNESS_DIR/hooks"/*.sh; do
    [[ -e "$hook" ]] || continue
    hook_name=$(basename "$hook")
    link "$hook" "$HOME/.claude/hooks/$hook_name"
    [[ $DRY_RUN == false ]] && chmod +x "$HOME/.claude/hooks/$hook_name"
  done
fi

echo ""
echo "════════════════════════════════════════"
echo "  Harness installed."
echo "  Skills:"
for skill_dir in "$HARNESS_DIR/skills"/*/; do
  echo "    - $(basename "$skill_dir")"
done
echo "════════════════════════════════════════"
echo ""
