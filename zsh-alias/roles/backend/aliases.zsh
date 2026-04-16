# ============================================================
# roles/backend/aliases.zsh — Backend (Node, Python, DB)
# ============================================================

# --- Node.js ---
alias node-version='node -v && npm -v'
alias nvm-list='nvm list'
alias nvm-use='nvm use'
alias nvm-latest='nvm install --lts && nvm use --lts'

# --- Python ---
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias vact='source .venv/bin/activate'
alias vdeact='deactivate'
alias pipr='pip install -r requirements.txt'
alias pipf='pip freeze > requirements.txt'

# Tạo venv và activate ngay
venv-init() {
  python3 -m venv .venv
  source .venv/bin/activate
  echo "✅ Đã tạo và activate .venv"
  [ -f "requirements.txt" ] && pip install -r requirements.txt && echo "✅ Installed requirements"
}

# --- PostgreSQL ---
alias pgstart='brew services start postgresql'
alias pgstop='brew services stop postgresql'
alias pgrestart='brew services restart postgresql'
alias pglog='tail -f /usr/local/var/log/postgresql*.log'

# Connect psql nhanh
pgcon() {
  local db=${1:-postgres}
  local user=${2:-$(whoami)}
  psql -U "$user" -d "$db"
}

# --- MySQL ---
alias mystart='brew services start mysql'
alias mystop='brew services stop mysql'
alias mycon='mysql -u root -p'

# --- Redis ---
alias rdstart='brew services start redis'
alias rdstop='brew services stop redis'
alias rdcli='redis-cli'
alias rdflush='redis-cli FLUSHALL && echo "✅ Redis flushed"'

# --- MongoDB ---
alias mgstart='brew services start mongodb-community'
alias mgstop='brew services stop mongodb-community'
alias mgcli='mongosh'

# --- API testing ---
alias http='httpie'

# Tạo request nhanh với curl + json đẹp
jcurl() {
  curl -s "$@" | python3 -m json.tool
}

# --- Logs ---
alias logf='tail -f'
alias logerr='tail -f /var/log/system.log | grep -i error'

# --- Server process ---
# Tìm process đang dùng port
whichport() {
  local port=$1
  [ -z "$port" ] && echo "❌ Dùng: whichport <port>" && return 1
  lsof -i tcp:"$port"
}

# Xem ENV vars của project
envshow() {
  if [ -f ".env" ]; then
    echo "📄 .env:"
    grep -v '^#' .env | grep -v '^$' | sort
  elif [ -f ".env.local" ]; then
    echo "📄 .env.local:"
    grep -v '^#' .env.local | grep -v '^$' | sort
  else
    echo "❌ Không tìm thấy .env"
  fi
}
