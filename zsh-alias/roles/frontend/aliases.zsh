# ============================================================
# roles/frontend/aliases.zsh — Frontend (React, Vite, build)
# ============================================================

# --- Vite ---
alias vite-new='npm create vite@latest'
vite-dev()     { command -v vite &>/dev/null || { echo "vite-dev: 'vite' not found (npm i -g vite)"; return 1; }; vite; }
vite-build()   { command -v vite &>/dev/null || { echo "vite-build: 'vite' not found (npm i -g vite)"; return 1; }; vite build; }
vite-preview() { command -v vite &>/dev/null || { echo "vite-preview: 'vite' not found (npm i -g vite)"; return 1; }; vite preview; }

# --- React ---
alias cra='npx create-react-app'
alias next-new='npx create-next-app@latest'

# --- Build / Bundle ---
wb()  { command -v webpack &>/dev/null || { echo "wb: 'webpack' not found (npm i -g webpack webpack-cli)"; return 1; }; webpack --mode production; }
wbd() { command -v webpack &>/dev/null || { echo "wbd: 'webpack' not found (npm i -g webpack webpack-cli)"; return 1; }; webpack --mode development; }
wbw() { command -v webpack &>/dev/null || { echo "wbw: 'webpack' not found (npm i -g webpack webpack-cli)"; return 1; }; webpack --watch; }

# --- CSS / Tailwind ---
alias twbuild='npx tailwindcss -i ./src/input.css -o ./dist/output.css'
alias twwatch='npx tailwindcss -i ./src/input.css -o ./dist/output.css --watch'

# --- Testing ---
alias vtest='npx vitest'
alias vtestui='npx vitest --ui'
alias jest='npx jest'
alias jestw='npx jest --watch'
alias cy='npx cypress open'
alias cyr='npx cypress run'
alias pw='npx playwright test'

# --- Lint / Format ---
alias eslint='npx eslint'
alias eslintfix='npx eslint --fix .'
alias prettier='npx prettier'
alias prettierfix='npx prettier --write .'
alias stylelint='npx stylelint'

# --- Storybook ---
alias sb='npx storybook dev'
alias sbbuild='npx storybook build'

# --- Utilities ---

# Analyze bundle size
bundle-size() {
  if [ -f "pnpm-lock.yaml" ]; then
    pnpm add -D source-map-explorer
  elif [ -f "yarn.lock" ]; then
    yarn add -D source-map-explorer
  else
    npm install --save-dev source-map-explorer
  fi
  npx source-map-explorer 'build/static/js/*.js'
}

# Quick lighthouse score check
lighthouse() {
  local url=${1:-http://localhost:3000}
  npx lighthouse "$url" --view
}

# Kill port 3000 (dev server often conflicts)
alias kill3000='lsof -ti tcp:3000 | xargs kill -9 && echo "✅ Port 3000 cleared"'
alias kill5173='lsof -ti tcp:5173 | xargs kill -9 && echo "✅ Port 5173 cleared"'
