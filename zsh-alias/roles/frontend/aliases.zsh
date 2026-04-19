# ============================================================
# roles/frontend/aliases.zsh — Frontend (React, Vite, build)
# ============================================================

# --- Vite ---
alias vite-new='npm create vite@latest'
alias vite-dev='vite'
alias vite-build='vite build'
alias vite-preview='vite preview'

# --- React ---
alias cra='npx create-react-app'
alias next-new='npx create-next-app@latest'

# --- Build / Bundle ---
alias wb='webpack --mode production'
alias wbd='webpack --mode development'
alias wbw='webpack --watch'

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
