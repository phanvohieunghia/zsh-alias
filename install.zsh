#!/usr/bin/env zsh
# ============================================================
# install.zsh — Remote installer for zsh-aliases
#
# Usage (remote, recommended):
#   curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh
#   curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- git npm
#   curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --all
#   curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --list
#   curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --update
#   curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --remove git
#   curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --uninstall
#
# Usage (local clone, same flags):
#   zsh install.zsh [ids...] | --all | --list | --update | --remove <id> | --uninstall
# ============================================================

set -e

# ── remote config ────────────────────────────────────────────
REPO_OWNER="phanvohieunghia"
REPO_NAME="zsh-alias"
REPO_BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${REPO_BRANCH}"

# ── paths ────────────────────────────────────────────────────
ZSHRC="$HOME/.zshrc"
ALIAS_DIR="$HOME/.config/zsh-alias"
MARKER_PREFIX="# >>> zsh-alias:"
MARKER_SUFFIX=" <<<"
BLOCK_MARKER_START="# >>> zsh-alias:loader >>>"
BLOCK_MARKER_END="# <<< zsh-alias:loader <<<"

# ── colors ───────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BLUE='\033[0;34m'; MAGENTA='\033[0;35m'
BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'

print_ok()   { echo "${GREEN}  ✅${NC} $1"; }
print_err()  { echo "${RED}  ❌${NC} $1"; }
print_warn() { echo "${YELLOW}  ⚠️ ${NC} $1"; }
print_info() { echo "${CYAN}  →${NC} $1"; }

# ── bundle list ──────────────────────────────────────────────
# format: "id|label|category|remote_path"
BUNDLES=(
  "git|Git shortcuts & PR opener|🔧 Tools|zsh-alias/tools/git/aliases.zsh"
  "npm|npm / yarn / pnpm|🔧 Tools|zsh-alias/tools/npm/aliases.zsh"
  "macos|macOS system utilities|🔧 Tools|zsh-alias/tools/macos/aliases.zsh"
  "ssh-tmux|SSH & tmux|🔧 Tools|zsh-alias/tools/ssh-tmux/aliases.zsh"
  "frontend|Frontend — React, Vite, build|👤 Roles|zsh-alias/roles/frontend/aliases.zsh"
  "backend|Backend — Node, Python, DB|👤 Roles|zsh-alias/roles/backend/aliases.zsh"
  "devops|DevOps — Docker, Terraform, AWS|👤 Roles|zsh-alias/roles/devops/aliases.zsh"
)

# ── helpers ──────────────────────────────────────────────────
bundle_id()    { echo "$1" | cut -d'|' -f1; }
bundle_label() { echo "$1" | cut -d'|' -f2; }
bundle_cat()   { echo "$1" | cut -d'|' -f3; }
bundle_path()  { echo "$1" | cut -d'|' -f4; }

find_bundle_by_id() {
  local target=$1
  for b in "${BUNDLES[@]}"; do
    [[ "$(bundle_id "$b")" == "$target" ]] && echo "$b" && return 0
  done
  return 1
}

is_installed() {
  [ -f "$ALIAS_DIR/$1.zsh" ]
}

ensure_alias_dir() {
  mkdir -p "$ALIAS_DIR"
  chmod 700 "$ALIAS_DIR" 2>/dev/null || true
}

# Detect: is this invocation running piped from curl (no local repo)?
is_remote_run() {
  [ ! -f "${SCRIPT_DIR:-/nonexistent}/install.zsh" ]
}

# Fetch a bundle file into $ALIAS_DIR/<id>.zsh
# Source priority: local clone (if SCRIPT_DIR has the file) → remote curl
fetch_bundle() {
  local id=$1
  local remote_path=$2
  local dest="$ALIAS_DIR/$id.zsh"
  local local_src="${SCRIPT_DIR}/${remote_path}"

  if [ -n "${SCRIPT_DIR:-}" ] && [ -f "$local_src" ]; then
    cp "$local_src" "$dest"
  else
    local url="${RAW_BASE}/${remote_path}"
    if ! curl -fsSL "$url" -o "$dest.tmp"; then
      print_err "Failed to download: $url"
      rm -f "$dest.tmp"
      return 1
    fi
    mv "$dest.tmp" "$dest"
  fi
  chmod 600 "$dest" 2>/dev/null || true
  return 0
}

# Ensure ~/.zshrc has a single loader block that sources $ALIAS_DIR/*.zsh
ensure_loader_in_zshrc() {
  touch "$ZSHRC"
  if grep -qF "$BLOCK_MARKER_START" "$ZSHRC"; then
    return 0
  fi
  {
    echo ""
    echo "$BLOCK_MARKER_START"
    echo "# Loads alias bundles from ${ALIAS_DIR}"
    echo "if [ -d \"\$HOME/.config/zsh-alias\" ]; then"
    echo "  for f in \"\$HOME/.config/zsh-alias\"/*.zsh(N); do"
    echo "    source \"\$f\""
    echo "  done"
    echo "fi"
    echo "$BLOCK_MARKER_END"
  } >> "$ZSHRC"
}

remove_loader_from_zshrc() {
  [ -f "$ZSHRC" ] || return 0
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "/${BLOCK_MARKER_START}/,/${BLOCK_MARKER_END}/d" "$ZSHRC"
  else
    sed -i "/${BLOCK_MARKER_START}/,/${BLOCK_MARKER_END}/d" "$ZSHRC"
  fi
}

backup_zshrc() {
  [ -f "$ZSHRC" ] || return 0
  local backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$ZSHRC" "$backup"
  print_ok "Backup: $backup"
}

# ── banner ───────────────────────────────────────────────────
print_banner() {
  echo ""
  echo "${BOLD}${CYAN}╔══════════════════════════════════════════╗${NC}"
  echo "${BOLD}${CYAN}║       zsh-alias  —  Installer            ║${NC}"
  echo "${BOLD}${CYAN}╚══════════════════════════════════════════╝${NC}"
  echo ""
}

# ── commands ─────────────────────────────────────────────────

cmd_list() {
  print_banner
  echo "${BOLD}Available alias bundles:${NC}"
  echo ""
  local prev_cat=""
  for bundle in "${BUNDLES[@]}"; do
    local id=$(bundle_id "$bundle")
    local label=$(bundle_label "$bundle")
    local cat=$(bundle_cat "$bundle")

    [ "$cat" != "$prev_cat" ] && echo "  ${BOLD}${MAGENTA}${cat}${NC}" && prev_cat="$cat"

    if is_installed "$id"; then
      echo "    ${GREEN}●${NC} ${BOLD}${id}${NC} — ${label} ${DIM}(installed)${NC}"
    else
      echo "    ${DIM}○${NC} ${BOLD}${id}${NC} — ${label}"
    fi
  done
  echo ""
  echo "${DIM}  Installed bundles live in: ${ALIAS_DIR}${NC}"
  echo ""
}

install_one() {
  local id=$1 label=$2 remote_path=$3
  if is_installed "$id"; then
    print_info "Updating: ${BOLD}${id}${NC} — ${label}"
  else
    print_info "Installing: ${BOLD}${id}${NC} — ${label}"
  fi
  if fetch_bundle "$id" "$remote_path"; then
    print_ok "Ready: ${BOLD}${id}${NC}"
  else
    print_err "Skipped: ${BOLD}${id}${NC}"
    return 1
  fi
}

cmd_install() {
  local ids=("$@")
  print_banner
  ensure_alias_dir
  backup_zshrc

  local selected_bundles=()
  for id in "${ids[@]}"; do
    local b
    if b=$(find_bundle_by_id "$id"); then
      selected_bundles+=("$b")
    else
      print_warn "Unknown bundle: $id (skipping)"
    fi
  done

  [ ${#selected_bundles[@]} -eq 0 ] && print_warn "Nothing to install." && exit 0

  echo ""
  for bundle in "${selected_bundles[@]}"; do
    install_one "$(bundle_id "$bundle")" "$(bundle_label "$bundle")" "$(bundle_path "$bundle")"
  done

  ensure_loader_in_zshrc

  echo ""
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo "${BOLD}  ✅ Installation complete!${NC}"
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo ""
  echo "  Run ${BOLD}source ~/.zshrc${NC} or open a new terminal."
  echo ""
}

cmd_all() {
  local all_ids=()
  for b in "${BUNDLES[@]}"; do all_ids+=("$(bundle_id "$b")"); done
  cmd_install "${all_ids[@]}"
}

cmd_update() {
  print_banner
  ensure_alias_dir
  local updated=0
  for bundle in "${BUNDLES[@]}"; do
    local id=$(bundle_id "$bundle")
    if is_installed "$id"; then
      install_one "$id" "$(bundle_label "$bundle")" "$(bundle_path "$bundle")"
      updated=$((updated+1))
    fi
  done
  [ $updated -eq 0 ] && print_warn "No bundles installed to update." && return 0
  echo ""
  print_ok "Updated ${updated} bundle(s)."
  echo ""
}

cmd_remove() {
  local id=$1
  [ -z "$id" ] && print_err "Usage: --remove <id>" && return 1

  if ! is_installed "$id"; then
    print_warn "'${id}' is not installed."
    return 0
  fi
  rm -f "$ALIAS_DIR/$id.zsh"
  print_ok "Removed: ${BOLD}${id}${NC}"
}

cmd_uninstall() {
  print_banner
  print_warn "This will remove ALL zsh-alias bundles and the loader from ~/.zshrc."
  printf "  Continue? [y/N]: "
  local confirm
  read -r confirm < /dev/tty
  [[ ! "$confirm" =~ ^[Yy]$ ]] && print_info "Aborted." && exit 0

  backup_zshrc
  remove_loader_from_zshrc
  if [ -d "$ALIAS_DIR" ]; then
    rm -rf "$ALIAS_DIR"
    print_ok "Removed: $ALIAS_DIR"
  fi
  print_ok "Loader removed from ~/.zshrc"
  echo ""
  echo "${BOLD}  👋 Uninstalled.${NC}"
  echo ""
}

cmd_interactive() {
  print_banner
  echo "${BOLD}Select bundles to install:${NC} ${DIM}(numbers separated by spaces, e.g.: 1 3 5)${NC}"
  echo ""

  local prev_cat=""
  local i=0
  for bundle in "${BUNDLES[@]}"; do
    i=$((i+1))
    local id=$(bundle_id "$bundle")
    local label=$(bundle_label "$bundle")
    local cat=$(bundle_cat "$bundle")

    [ "$cat" != "$prev_cat" ] && echo "  ${BOLD}${MAGENTA}${cat}${NC}" && prev_cat="$cat"

    if is_installed "$id"; then
      echo "    ${GREEN}[${i}]${NC} ${label} ${DIM}(installed)${NC}"
    else
      echo "    ${CYAN}[${i}]${NC} ${label}"
    fi
  done

  echo ""
  echo "  ${BLUE}[a]${NC} Install all    ${YELLOW}[u]${NC} Update installed    ${RED}[q]${NC} Quit"
  echo ""
  printf "${BOLD}Selection: ${NC}"
  local selection
  read -r selection < /dev/tty

  [[ "$selection" == "q" ]] && echo "👋 Bye." && exit 0
  [[ "$selection" == "a" ]] && cmd_all && return
  [[ "$selection" == "u" ]] && cmd_update && return

  local selected_ids=()
  for num in ${=selection}; do
    if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#BUNDLES[@]} )); then
      selected_ids+=("$(bundle_id "${BUNDLES[$num]}")")
    else
      print_warn "Invalid: $num (skipping)"
    fi
  done

  [ ${#selected_ids[@]} -eq 0 ] && print_warn "No bundles selected." && exit 0
  cmd_install "${selected_ids[@]}"
}

# ── entry point ──────────────────────────────────────────────
# SCRIPT_DIR is set only when running from a local clone
if [ -n "${ZSH_SCRIPT:-}" ] && [ -f "$ZSH_SCRIPT" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$ZSH_SCRIPT")" && pwd)"
elif [ -n "${0:-}" ] && [ -f "$0" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
else
  SCRIPT_DIR=""
fi

case "${1:-}" in
  --all)       cmd_all ;;
  --list)      cmd_list ;;
  --update)    cmd_update ;;
  --remove)    cmd_remove "${2:-}" ;;
  --uninstall) cmd_uninstall ;;
  --help|-h)
    print_banner
    sed -n '3,16p' "$0" 2>/dev/null || cat <<EOF
Usage:
  install.zsh [ids...]      Install specific bundles
  install.zsh --all         Install all bundles
  install.zsh --list        List bundles
  install.zsh --update      Re-fetch all installed bundles
  install.zsh --remove <id> Remove one bundle
  install.zsh --uninstall   Remove everything
EOF
    ;;
  "")          cmd_interactive ;;
  *)           cmd_install "$@" ;;
esac
