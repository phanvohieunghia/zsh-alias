#!/usr/bin/env zsh
# ============================================================
# install.zsh — Interactive installer for zsh-aliases
# Usage:
#   zsh install.zsh              → interactive menu to select bundles
#   zsh install.zsh --all        → install all bundles
#   zsh install.zsh --list       → list available bundles
#   zsh install.zsh --remove     → interactive menu to remove bundles
#   zsh install.zsh --remove <id> → remove a bundle by id
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSHRC="$HOME/.zshrc"
MARKER_PREFIX="# >>> zsh-aliases:"
MARKER_SUFFIX=" <<<"

# ── colors ───────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BLUE='\033[0;34m'; MAGENTA='\033[0;35m'
BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'

print_ok()   { echo "${GREEN}  ✅${NC} $1"; }
print_err()  { echo "${RED}  ❌${NC} $1"; }
print_warn() { echo "${YELLOW}  ⚠️ ${NC} $1"; }
print_info() { echo "${CYAN}  →${NC} $1"; }

# ── bundle list ──────────────────────────────────────────────
# format: "id|label|category|path"
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

is_installed() {
  local id=$1
  grep -qF "${MARKER_PREFIX}${id}" "$ZSHRC" 2>/dev/null
}

# ── banner ───────────────────────────────────────────────────
print_banner() {
  echo ""
  echo "${BOLD}${CYAN}╔══════════════════════════════════════════╗${NC}"
  echo "${BOLD}${CYAN}║       zsh-aliases  —  Installer          ║${NC}"
  echo "${BOLD}${CYAN}╚══════════════════════════════════════════╝${NC}"
  echo ""
}

# ── list mode ────────────────────────────────────────────────
cmd_list() {
  print_banner
  echo "${BOLD}Available alias bundles:${NC}"
  echo ""
  local prev_cat=""
  for bundle in "${BUNDLES[@]}"; do
    local id=$(bundle_id "$bundle")
    local label=$(bundle_label "$bundle")
    local cat=$(bundle_cat "$bundle")
    local path=$(bundle_path "$bundle")

    [ "$cat" != "$prev_cat" ] && echo "  ${BOLD}${MAGENTA}${cat}${NC}" && prev_cat="$cat"

    if is_installed "$id"; then
      echo "    ${GREEN}●${NC} ${BOLD}${id}${NC} — ${label} ${DIM}(installed)${NC}"
    else
      echo "    ${DIM}○${NC} ${BOLD}${id}${NC} — ${label}"
    fi
  done
  echo ""
}

# ── remove single bundle ─────────────────────────────────────
remove_bundle() {
  local id=$1
  local label=$2
  local marker_start="${MARKER_PREFIX}${id}"

  if ! is_installed "$id"; then
    print_warn "'${id}' is not installed, skipping."
    return 0
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "/${marker_start}/,/${MARKER_SUFFIX}/d" "$ZSHRC"
  else
    sed -i "/${marker_start}/,/${MARKER_SUFFIX}/d" "$ZSHRC"
  fi

  print_ok "Removed: ${BOLD}${id}${NC} — ${label}"
}

# ── install single bundle ────────────────────────────────────
install_bundle() {
  local id=$1
  local label=$2
  local filepath="$DOTFILES_DIR/$3"
  local source_line="source \"${filepath}\""
  local marker_start="${MARKER_PREFIX}${id}"
  local marker_end="${MARKER_SUFFIX}"

  if [ ! -f "$filepath" ]; then
    print_err "File not found: $filepath"
    return 1
  fi

  # Already installed → ask to overwrite
  if is_installed "$id"; then
    printf "  ${YELLOW}⚠️  '${id}' is already installed. Overwrite?${NC} [y/N]: "
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      print_warn "Skipping: $id"
      return 0
    fi
    # Remove old block
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "/${marker_start}/,/${marker_end}/d" "$ZSHRC"
    else
      sed -i "/${marker_start}/,/${marker_end}/d" "$ZSHRC"
    fi
  fi

  # Inject
  {
    echo ""
    echo "${marker_start}"
    echo "# ${label}"
    echo "# Injected: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "$source_line"
    echo "# <<< zsh-aliases:${id} <<<"
  } >> "$ZSHRC"

  print_ok "Installed: ${BOLD}${id}${NC} — ${label}"
}

# ── remove mode ──────────────────────────────────────────────
cmd_remove() {
  local target_id="${1:-}"

  # --remove <id> directly
  if [[ -n "$target_id" ]]; then
    local found=0
    for bundle in "${BUNDLES[@]}"; do
      if [[ "$(bundle_id "$bundle")" == "$target_id" ]]; then
        found=1
        local backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$ZSHRC" "$backup" 2>/dev/null
        print_ok "Backup: $backup"
        remove_bundle "$target_id" "$(bundle_label "$bundle")"
        source "$ZSHRC" 2>/dev/null || true
        break
      fi
    done
    [[ $found -eq 0 ]] && print_err "Bundle not found: '$target_id'"
    return
  fi

  # Interactive remove menu
  print_banner
  echo "${BOLD}Select bundles to remove:${NC} ${DIM}(enter numbers separated by spaces, e.g.: 1 3)${NC}"
  echo ""

  local prev_cat=""
  local i=0
  local installed_map=()

  for bundle in "${BUNDLES[@]}"; do
    i=$((i+1))
    local id=$(bundle_id "$bundle")
    local label=$(bundle_label "$bundle")
    local cat=$(bundle_cat "$bundle")

    [ "$cat" != "$prev_cat" ] && echo "  ${BOLD}${MAGENTA}${cat}${NC}" && prev_cat="$cat"

    if is_installed "$id"; then
      echo "    ${RED}[${i}]${NC} ${label} ${DIM}(installed)${NC}"
    else
      echo "    ${DIM}[-]${NC} ${DIM}${label}${NC}"
    fi
    installed_map+=("$bundle")
  done

  echo ""
  echo "  ${RED}[a]${NC} Remove all"
  echo "  ${BLUE}[q]${NC} Quit"
  echo ""
  printf "${BOLD}Selection: ${NC}"
  read -r selection

  [[ "$selection" == "q" ]] && echo "👋 Bye." && exit 0

  local selected_bundles=()
  if [[ "$selection" == "a" ]]; then
    for bundle in "${BUNDLES[@]}"; do
      is_installed "$(bundle_id "$bundle")" && selected_bundles+=("$bundle")
    done
  else
    for num in ${=selection}; do
      if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#BUNDLES[@]} )); then
        local b="${BUNDLES[$num]}"
        if is_installed "$(bundle_id "$b")"; then
          selected_bundles+=("$b")
        else
          print_warn "Bundle not installed: $(bundle_id "$b") (skipping)"
        fi
      else
        print_warn "Invalid number: $num (skipping)"
      fi
    done
  fi

  [ ${#selected_bundles[@]} -eq 0 ] && print_warn "No bundles selected." && exit 0

  echo ""
  print_info "Creating backup of ~/.zshrc..."
  local backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$ZSHRC" "$backup" 2>/dev/null || true
  print_ok "Backup: $backup"
  echo ""

  for bundle in "${selected_bundles[@]}"; do
    remove_bundle "$(bundle_id "$bundle")" "$(bundle_label "$bundle")"
  done

  echo ""
  print_info "Running source ~/.zshrc..."
  source "$ZSHRC" 2>/dev/null && print_ok "Sourced successfully!" || print_warn "Open a new terminal to apply changes."

  echo ""
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo "${BOLD}  ✅ Uninstall complete!${NC}"
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo ""
}

# ── interactive menu ─────────────────────────────────────────
cmd_interactive() {
  print_banner

  # Display menu
  echo "${BOLD}Select bundles to install:${NC} ${DIM}(enter numbers separated by spaces, e.g.: 1 3 5)${NC}"
  echo ""

  local prev_cat=""
  local i=0
  local index_map=()

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
    index_map+=("$bundle")
  done

  echo ""
  echo "  ${BLUE}[a]${NC} Install all"
  echo "  ${RED}[q]${NC} Quit"
  echo ""
  printf "${BOLD}Selection: ${NC}"
  read -r selection

  [[ "$selection" == "q" ]] && echo "👋 Bye." && exit 0

  local selected_bundles=()
  if [[ "$selection" == "a" ]]; then
    selected_bundles=("${BUNDLES[@]}")
  else
    for num in ${=selection}; do
      if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#BUNDLES[@]} )); then
        selected_bundles+=("${BUNDLES[$num]}")
      else
        print_warn "Invalid number: $num (skipping)"
      fi
    done
  fi

  [ ${#selected_bundles[@]} -eq 0 ] && print_warn "No bundles selected." && exit 0

  # Backup
  echo ""
  print_info "Creating backup of ~/.zshrc..."
  local backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$ZSHRC" "$backup" 2>/dev/null || touch "$ZSHRC"
  print_ok "Backup: $backup"
  echo ""

  # Install each bundle
  for bundle in "${selected_bundles[@]}"; do
    install_bundle "$(bundle_id "$bundle")" "$(bundle_label "$bundle")" "$(bundle_path "$bundle")"
  done

  # Source
  echo ""
  print_info "Running source ~/.zshrc..."
  if source "$ZSHRC" 2>/dev/null; then
    print_ok "Sourced successfully!"
  else
    print_warn "Minor warnings during source — aliases will work in a new terminal."
  fi

  # Summary
  echo ""
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo "${BOLD}  ✅ Installation complete!${NC}"
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo ""
  echo "  Run ${BOLD}source ~/.zshrc${NC} if aliases are not yet available."
  echo "  Run ${BOLD}zsh install.zsh --list${NC} to check status."
  echo ""
}

# ── all mode ─────────────────────────────────────────────────
cmd_all() {
  print_banner
  print_info "Installing all ${#BUNDLES[@]} alias bundles...\n"

  local backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$ZSHRC" "$backup" 2>/dev/null || touch "$ZSHRC"
  print_ok "Backup: $backup\n"

  for bundle in "${BUNDLES[@]}"; do
    install_bundle "$(bundle_id "$bundle")" "$(bundle_label "$bundle")" "$(bundle_path "$bundle")"
  done

  source "$ZSHRC" 2>/dev/null && print_ok "Sourced successfully!" || print_warn "Open a new terminal to apply changes."
  echo ""
}

# ── entry point ──────────────────────────────────────────────
case "${1:-}" in
  --all)    cmd_all ;;
  --list)   cmd_list ;;
  --remove) cmd_remove "${2:-}" ;;
  *)        cmd_interactive ;;
esac
