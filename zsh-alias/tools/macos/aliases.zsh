# ============================================================
# tools/macos/aliases.zsh — macOS system utilities
# ============================================================

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias dev='cd ~/Developer'

# --- ls / eza ---
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lh --icons --git'
  alias la='eza -lah --icons --git'
  alias lt='eza --tree --icons -L 2'
else
  alias ls='ls -G'
  alias ll='ls -lhG'
  alias la='ls -lahG'
fi

# --- File ops ---
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rmf='rm -rf'

# --- Finder ---
alias show='defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'
alias o='open .'
alias of='open -a Finder .'

# --- Clipboard ---
alias pbp='pbpaste'
alias pbc='pbcopy'
copypwd() { pwd | pbcopy && echo "📋 copied: $(pwd)" }

# --- Network ---
alias ip='curl -s ifconfig.me && echo'
alias localip="ipconfig getifaddr en0"
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo "✅ DNS flushed"'
alias ports='lsof -i -P -n | grep LISTEN'

# --- Kill port ---
# Usage: killport 3000
killport() {
  local port=$1
  [ -z "$port" ] && echo "❌ Usage: killport <port>" && return 1
  local pid
  pid=$(lsof -ti tcp:"$port")
  if [ -z "$pid" ]; then
    echo "⚠️  No process is using port $port"
  else
    kill -9 "$pid"
    echo "✅ Killed process $pid on port $port"
  fi
}

# --- System ---
alias brewup='brew update && brew upgrade && brew cleanup'
alias zrc='vim ~/.zshrc'
alias src='source ~/.zshrc && echo "✅ zshrc reloaded"'
alias path='echo $PATH | tr ":" "\n"'
alias cpu='top -l 1 | grep "CPU usage"'
alias mem='top -l 1 | grep "PhysMem"'

# --- Trash (replaces rm) ---
alias trash='mv -v "$@" ~/.Trash'

# --- Quick server ---
# Usage: serve [port]
serve() {
  local port=${1:-8080}
  echo "🌐 Serving at http://localhost:${port}"
  python3 -m http.server "$port"
}
