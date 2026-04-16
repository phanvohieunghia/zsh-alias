# ============================================================
# tools/npm/aliases.zsh — npm / yarn / pnpm
# ============================================================

# --- npm ---
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nun='npm uninstall'
alias nrun='npm run'
alias nst='npm start'
alias nt='npm test'
alias nb='npm run build'
alias ndev='npm run dev'
alias nlint='npm run lint'
alias nci='npm ci'
alias nout='npm outdated'
alias nup='npm update'
alias nls='npm list --depth=0'

# --- yarn ---
alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn remove'
alias yrun='yarn run'
alias yst='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias ydev='yarn dev'
alias ylint='yarn lint'

# --- pnpm ---
alias pi='pnpm install'
alias pa='pnpm add'
alias pad='pnpm add -D'
alias pr='pnpm remove'
alias prun='pnpm run'
alias pst='pnpm start'
alias pt='pnpm test'
alias pb='pnpm build'
alias pdev='pnpm dev'
alias plint='pnpm lint'
alias pci='pnpm install --frozen-lockfile'

# --- Auto-detect package manager ---
# Chạy script bằng đúng package manager của project
dev() {
  if [ -f "pnpm-lock.yaml" ]; then
    pnpm dev
  elif [ -f "yarn.lock" ]; then
    yarn dev
  elif [ -f "package-lock.json" ]; then
    npm run dev
  else
    echo "❌ Không tìm thấy package manager. Hãy chạy install trước."
  fi
}

build() {
  if [ -f "pnpm-lock.yaml" ]; then
    pnpm build
  elif [ -f "yarn.lock" ]; then
    yarn build
  elif [ -f "package-lock.json" ]; then
    npm run build
  else
    echo "❌ Không tìm thấy package manager."
  fi
}

# Xem scripts có trong package.json
scripts() {
  if [ -f "package.json" ]; then
    cat package.json | python3 -c "
import json,sys
p=json.load(sys.stdin)
scripts=p.get('scripts',{})
print('📦 Scripts trong package.json:')
[print(f'  {k:<20} → {v}') for k,v in scripts.items()]
"
  else
    echo "❌ Không tìm thấy package.json"
  fi
}
