# ============================================================
# tools/ssh-tmux/aliases.zsh — SSH & tmux
# ============================================================

# --- SSH ---
alias sshconf='$EDITOR ~/.ssh/config'
alias sshkeys='ls -la ~/.ssh'
alias sshadd='ssh-add ~/.ssh/id_ed25519'

# Copy SSH public key ra clipboard
sshcopy() {
  local key=${1:-~/.ssh/id_ed25519.pub}
  if [ -f "$key" ]; then
    cat "$key" | pbcopy
    echo "📋 Đã copy public key: $key"
  else
    echo "❌ Không tìm thấy: $key"
  fi
}

# Tạo SSH key mới
sshgen() {
  local name=${1:-id_ed25519}
  local email=${2:-""}
  if [ -z "$email" ]; then
    echo "❌ Dùng: sshgen <tên_key> <email>"
    return 1
  fi
  ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/"$name"
  echo "✅ Key tạo tại ~/.ssh/$name"
  echo "📋 Public key:"
  cat ~/.ssh/"${name}.pub"
}

# --- tmux ---
alias tls='tmux list-sessions'
alias tks='tmux kill-session -t'
alias tka='tmux kill-server'

# Attach hoặc tạo session mới
ta() {
  local name=${1:-main}
  tmux attach-session -t "$name" 2>/dev/null || tmux new-session -s "$name"
}

# Tạo session mới
tn() {
  local name=${1:-$(basename "$PWD")}
  tmux new-session -s "$name"
}

# tmux layout nhanh cho dev (editor + terminal + logs)
tdev() {
  local name=${1:-dev}
  tmux new-session -d -s "$name" -n "editor"
  tmux new-window   -t "$name" -n "terminal"
  tmux new-window   -t "$name" -n "logs"
  tmux select-window -t "$name:editor"
  tmux attach-session -t "$name"
  echo "✅ Tạo tmux session '$name' với 3 windows: editor, terminal, logs"
}
