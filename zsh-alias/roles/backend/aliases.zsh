# ============================================================
# roles/backend/aliases.zsh — Backend (Node, Python, DB)
# ============================================================

# --- Node.js ---
alias node-version='node -v && npm -v'
nvm-list()   { command -v nvm &>/dev/null || { echo "nvm-list: 'nvm' not found (https://github.com/nvm-sh/nvm)"; return 1; }; nvm list; }
nvm-use()    { command -v nvm &>/dev/null || { echo "nvm-use: 'nvm' not found (https://github.com/nvm-sh/nvm)"; return 1; }; nvm use "$@"; }
nvm-latest() { command -v nvm &>/dev/null || { echo "nvm-latest: 'nvm' not found (https://github.com/nvm-sh/nvm)"; return 1; }; nvm install --lts && nvm use --lts; }

# --- Python ---
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias vact='source .venv/bin/activate'
alias vdeact='deactivate'
alias pipr='pip install -r requirements.txt'
alias pipf='pip freeze > requirements.txt'

# Create venv and activate immediately
venv-init() {
  python3 -m venv .venv
  source .venv/bin/activate
  echo "✅ Created and activated .venv"
  [ -f "requirements.txt" ] && pip install -r requirements.txt && echo "✅ Installed requirements"
}

# --- PostgreSQL ---
alias pgstart='brew services start postgresql'
alias pgstop='brew services stop postgresql'
alias pgrestart='brew services restart postgresql'
alias pglog='tail -f /usr/local/var/log/postgresql*.log'

# Quick psql connect
pgcon() {
  command -v psql &>/dev/null || { echo "pgcon: 'psql' not found (brew install postgresql)"; return 1; }
  local db=${1:-postgres}
  local user=${2:-$(whoami)}
  psql -U "$user" -d "$db"
}

# --- MySQL ---
alias mystart='brew services start mysql'
alias mystop='brew services stop mysql'
mycon() { command -v mysql &>/dev/null || { echo "mycon: 'mysql' not found (brew install mysql)"; return 1; }; mysql -u root -p; }

# --- Redis ---
alias rdstart='brew services start redis'
alias rdstop='brew services stop redis'
rdcli()   { command -v redis-cli &>/dev/null || { echo "rdcli: 'redis-cli' not found (brew install redis)"; return 1; }; redis-cli "$@"; }
rdflush() { command -v redis-cli &>/dev/null || { echo "rdflush: 'redis-cli' not found (brew install redis)"; return 1; }; redis-cli FLUSHALL && echo "✅ Redis flushed"; }

# --- MongoDB ---
alias mgstart='brew services start mongodb-community'
alias mgstop='brew services stop mongodb-community'
mgcli() { command -v mongosh &>/dev/null || { echo "mgcli: 'mongosh' not found (brew install mongosh)"; return 1; }; mongosh; }

# --- API testing ---
http() { command -v http &>/dev/null || { echo "http: 'httpie' not found (brew install httpie)"; return 1; }; http "$@"; }

# Quick curl request with pretty JSON output
jcurl() {
  curl -s "$@" | python3 -m json.tool
}

# --- Logs ---
alias logf='tail -f'
alias logerr='tail -f /var/log/system.log | grep -i error'

# --- Server process ---
# Find process using a port
whichport() {
  local port=$1
  [ -z "$port" ] && echo "❌ Usage: whichport <port>" && return 1
  lsof -i tcp:"$port"
}

# Show project ENV vars
envshow() {
  if [ -f ".env" ]; then
    echo "📄 .env:"
    grep -v '^#' .env | grep -v '^$' | sort
  elif [ -f ".env.local" ]; then
    echo "📄 .env.local:"
    grep -v '^#' .env.local | grep -v '^$' | sort
  else
    echo "❌ .env not found"
  fi
}
