#!/usr/bin/env zsh
# ============================================================
# install.zsh — Interactive installer cho zsh-aliases
# Usage:
#   zsh install.zsh              → menu chọn bộ alias
#   zsh install.zsh --all        → cài tất cả
#   zsh install.zsh --list       → xem danh sách các bộ alias
#   zsh install.zsh --remove     → menu gỡ bộ alias đã cài
#   zsh install.zsh --remove <id> → gỡ bộ alias theo id
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSHRC="$HOME/.zshrc"
MARKER_PREFIX="# >>> zsh-aliases:"
MARKER_SUFFIX=" <<<"

# ── màu ──────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BLUE='\033[0;34m'; MAGENTA='\033[0;35m'
BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'

print_ok()   { echo "${GREEN}  ✅${NC} $1"; }
print_err()  { echo "${RED}  ❌${NC} $1"; }
print_warn() { echo "${YELLOW}  ⚠️ ${NC} $1"; }
print_info() { echo "${CYAN}  →${NC} $1"; }

# ── danh sách các bộ alias ───────────────────────────────────
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
  echo "${BOLD}Các bộ alias có sẵn:${NC}"
  echo ""
  local prev_cat=""
  for bundle in "${BUNDLES[@]}"; do
    local id=$(bundle_id "$bundle")
    local label=$(bundle_label "$bundle")
    local cat=$(bundle_cat "$bundle")
    local path=$(bundle_path "$bundle")

    [ "$cat" != "$prev_cat" ] && echo "  ${BOLD}${MAGENTA}${cat}${NC}" && prev_cat="$cat"

    if is_installed "$id"; then
      echo "    ${GREEN}●${NC} ${BOLD}${id}${NC} — ${label} ${DIM}(đã cài)${NC}"
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
    print_warn "'${id}' chưa được cài, bỏ qua."
    return 0
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "/${marker_start}/,/${MARKER_SUFFIX}/d" "$ZSHRC"
  else
    sed -i "/${marker_start}/,/${MARKER_SUFFIX}/d" "$ZSHRC"
  fi

  print_ok "Đã gỡ: ${BOLD}${id}${NC} — ${label}"
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
    print_err "Không tìm thấy file: $filepath"
    return 1
  fi

  # Đã cài → hỏi overwrite
  if is_installed "$id"; then
    printf "  ${YELLOW}⚠️  '${id}' đã được cài. Ghi đè?${NC} [y/N]: "
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      print_warn "Bỏ qua: $id"
      return 0
    fi
    # Xóa block cũ
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

  print_ok "Đã cài: ${BOLD}${id}${NC} — ${label}"
}

# ── remove mode ──────────────────────────────────────────────
cmd_remove() {
  local target_id="${1:-}"

  # --remove <id> trực tiếp
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
    [[ $found -eq 0 ]] && print_err "Không tìm thấy bundle: '$target_id'"
    return
  fi

  # Interactive remove menu
  print_banner
  echo "${BOLD}Chọn bộ alias muốn gỡ:${NC} ${DIM}(nhập số, cách nhau bởi space. VD: 1 3)${NC}"
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
      echo "    ${RED}[${i}]${NC} ${label} ${DIM}(đã cài)${NC}"
    else
      echo "    ${DIM}[-]${NC} ${DIM}${label}${NC}"
    fi
    installed_map+=("$bundle")
  done

  echo ""
  echo "  ${RED}[a]${NC} Gỡ tất cả"
  echo "  ${BLUE}[q]${NC} Thoát"
  echo ""
  printf "${BOLD}Lựa chọn: ${NC}"
  read -r selection

  [[ "$selection" == "q" ]] && echo "👋 Thoát." && exit 0

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
          print_warn "Bundle chưa được cài: $(bundle_id "$b") (bỏ qua)"
        fi
      else
        print_warn "Số không hợp lệ: $num (bỏ qua)"
      fi
    done
  fi

  [ ${#selected_bundles[@]} -eq 0 ] && print_warn "Không có bộ nào được chọn." && exit 0

  echo ""
  print_info "Tạo backup ~/.zshrc..."
  local backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$ZSHRC" "$backup" 2>/dev/null || true
  print_ok "Backup: $backup"
  echo ""

  for bundle in "${selected_bundles[@]}"; do
    remove_bundle "$(bundle_id "$bundle")" "$(bundle_label "$bundle")"
  done

  echo ""
  print_info "Chạy source ~/.zshrc..."
  source "$ZSHRC" 2>/dev/null && print_ok "source thành công!" || print_warn "Mở terminal mới để áp dụng."

  echo ""
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo "${BOLD}  ✅ Gỡ cài đặt hoàn tất!${NC}"
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo ""
}

# ── interactive menu ─────────────────────────────────────────
cmd_interactive() {
  print_banner

  # Hiển thị menu
  echo "${BOLD}Chọn bộ alias muốn cài:${NC} ${DIM}(nhập số, cách nhau bởi space. VD: 1 3 5)${NC}"
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
      echo "    ${GREEN}[${i}]${NC} ${label} ${DIM}(đã cài)${NC}"
    else
      echo "    ${CYAN}[${i}]${NC} ${label}"
    fi
    index_map+=("$bundle")
  done

  echo ""
  echo "  ${BLUE}[a]${NC} Cài tất cả"
  echo "  ${RED}[q]${NC} Thoát"
  echo ""
  printf "${BOLD}Lựa chọn: ${NC}"
  read -r selection

  [[ "$selection" == "q" ]] && echo "👋 Thoát." && exit 0

  local selected_bundles=()
  if [[ "$selection" == "a" ]]; then
    selected_bundles=("${BUNDLES[@]}")
  else
    for num in ${=selection}; do
      if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#BUNDLES[@]} )); then
        selected_bundles+=("${BUNDLES[$num]}")
      else
        print_warn "Số không hợp lệ: $num (bỏ qua)"
      fi
    done
  fi

  [ ${#selected_bundles[@]} -eq 0 ] && print_warn "Không có bộ nào được chọn." && exit 0

  # Backup
  echo ""
  print_info "Tạo backup ~/.zshrc..."
  local backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$ZSHRC" "$backup" 2>/dev/null || touch "$ZSHRC"
  print_ok "Backup: $backup"
  echo ""

  # Install từng bộ
  for bundle in "${selected_bundles[@]}"; do
    install_bundle "$(bundle_id "$bundle")" "$(bundle_label "$bundle")" "$(bundle_path "$bundle")"
  done

  # Source
  echo ""
  print_info "Chạy source ~/.zshrc..."
  if source "$ZSHRC" 2>/dev/null; then
    print_ok "source thành công!"
  else
    print_warn "source có cảnh báo nhỏ — alias vẫn hoạt động khi mở terminal mới."
  fi

  # Summary
  echo ""
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo "${BOLD}  ✅ Cài đặt hoàn tất!${NC}"
  echo "${BOLD}${CYAN}══════════════════════════════════════════${NC}"
  echo ""
  echo "  Chạy ${BOLD}source ~/.zshrc${NC} nếu alias chưa xuất hiện."
  echo "  Chạy ${BOLD}zsh install.zsh --list${NC} để xem trạng thái."
  echo ""
}

# ── all mode ─────────────────────────────────────────────────
cmd_all() {
  print_banner
  print_info "Cài tất cả ${#BUNDLES[@]} bộ alias...\n"

  local backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$ZSHRC" "$backup" 2>/dev/null || touch "$ZSHRC"
  print_ok "Backup: $backup\n"

  for bundle in "${BUNDLES[@]}"; do
    install_bundle "$(bundle_id "$bundle")" "$(bundle_label "$bundle")" "$(bundle_path "$bundle")"
  done

  source "$ZSHRC" 2>/dev/null && print_ok "source thành công!" || print_warn "Mở terminal mới để áp dụng."
  echo ""
}

# ── entry point ──────────────────────────────────────────────
case "${1:-}" in
  --all)    cmd_all ;;
  --list)   cmd_list ;;
  --remove) cmd_remove "${2:-}" ;;
  *)        cmd_interactive ;;
esac
