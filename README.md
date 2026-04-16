# zsh-aliases 🚀

A collection of aliases for macOS / zsh — organized by **tool** and **role**, with flexible installation.

---

## Quick Install

```zsh
git clone https://github.com/phanvohieunghia/zsh-alias.git ~/zsh-alias
cd ~/zsh-alias
zsh install.zsh
```

---

## Installer Usage

```zsh
zsh install.zsh                # Interactive menu to select bundles
zsh install.zsh --all          # Install all bundles immediately
zsh install.zsh --list         # View list & installation status
zsh install.zsh --remove       # Interactive menu to remove bundles
zsh install.zsh --remove <id>  # Remove a specific bundle by ID
```

---

## How It Works

`install.zsh` injects each bundle into `~/.zshrc` using markers:

```zsh
# >>> zsh-aliases:git
# Git shortcuts & PR opener
# Injected: 2026-04-16 10:00:00
source "/Users/you/zsh-aliases/tools/git/aliases.zsh"
# <<< zsh-aliases:git <<<
```

Each bundle has its own marker so they can be installed, overwritten, or removed independently. A timestamped backup of `~/.zshrc` is always created before any changes.

---

## Alias Bundles

### 🔧 Tools

#### `git` — Git shortcuts & PR opener

| Alias / Function | Command | Description |
|---|---|---|
| `gs` | `git status` | Show working tree status |
| `ga` | `git add` | Stage files |
| `gaa` | `git add .` | Stage all changes |
| `gc` | `git commit -m` | Commit with message |
| `gca` | `git commit --amend --no-edit` | Amend last commit without editing message |
| `gp` | `git push` | Push to remote |
| `gpf` | `git push --force-with-lease` | Safe force push |
| `gl` | `git pull` | Pull from remote |
| `gf` | `git fetch --prune` | Fetch and prune stale branches |
| `gco` | `git checkout` | Checkout branch or file |
| `gcb` | `git checkout -b` | Create and checkout new branch |
| `gbd` | `git branch -d` | Delete branch (safe) |
| `gbD` | `git branch -D` | Delete branch (force) |
| `glog` | `git log --oneline --graph --decorate --all` | Visual commit graph |
| `grb` | `git rebase` | Rebase |
| `grbi` | `git rebase -i` | Interactive rebase |
| `gst` | `git stash` | Stash changes |
| `gstp` | `git stash pop` | Pop stash |
| `gdiff` | `git diff` | Show unstaged diff |
| `gds` | `git diff --staged` | Show staged diff |
| `gbranch` | `git symbolic-ref --short HEAD` | Print current branch name |
| `gpush()` | — | Push current branch and set upstream automatically |
| `gpr <number>` | — | Open PR (GitHub) or MR (GitLab) in browser by number |
| `gclean()` | — | Delete all local branches already merged into main/master |
| `gwip()` | — | Stage all and create a `wip: <timestamp>` commit |

---

#### `npm` — npm / yarn / pnpm

**npm**

| Alias | Command | Description |
|---|---|---|
| `ni` | `npm install` | Install dependencies |
| `nid` | `npm install --save-dev` | Install as dev dependency |
| `nig` | `npm install -g` | Install globally |
| `nun` | `npm uninstall` | Uninstall package |
| `nrun` | `npm run` | Run script |
| `nst` | `npm start` | Start |
| `nt` | `npm test` | Test |
| `nb` | `npm run build` | Build |
| `ndev` | `npm run dev` | Dev server |
| `nlint` | `npm run lint` | Lint |
| `nci` | `npm ci` | Clean install |
| `nout` | `npm outdated` | Show outdated packages |
| `nup` | `npm update` | Update packages |
| `nls` | `npm list --depth=0` | List top-level packages |

**yarn**

| Alias | Command | Description |
|---|---|---|
| `yi` | `yarn install` | Install |
| `ya` | `yarn add` | Add package |
| `yad` | `yarn add --dev` | Add dev dependency |
| `yr` | `yarn remove` | Remove package |
| `yrun` | `yarn run` | Run script |
| `yst` | `yarn start` | Start |
| `yt` | `yarn test` | Test |
| `yb` | `yarn build` | Build |
| `ydev` | `yarn dev` | Dev server |
| `ylint` | `yarn lint` | Lint |

**pnpm**

| Alias | Command | Description |
|---|---|---|
| `pi` | `pnpm install` | Install |
| `pa` | `pnpm add` | Add package |
| `pad` | `pnpm add -D` | Add dev dependency |
| `pr` | `pnpm remove` | Remove package |
| `prun` | `pnpm run` | Run script |
| `pst` | `pnpm start` | Start |
| `pt` | `pnpm test` | Test |
| `pb` | `pnpm build` | Build |
| `pdev` | `pnpm dev` | Dev server |
| `plint` | `pnpm lint` | Lint |
| `pci` | `pnpm install --frozen-lockfile` | CI install |

**Smart functions**

| Function | Description |
|---|---|
| `dev()` | Run dev server using the detected package manager (`pnpm` / `yarn` / `npm`) |
| `build()` | Run build using the detected package manager |
| `scripts()` | Pretty-print all scripts defined in `package.json` |

---

#### `macos` — macOS system utilities

**Navigation**

| Alias | Description |
|---|---|
| `..` / `...` / `....` | Go up 1 / 2 / 3 directories |
| `~` | Go to home directory |
| `dl` | Go to `~/Downloads` |
| `dt` | Go to `~/Desktop` |
| `dev` | Go to `~/Developer` |

**Listing (uses `eza` if installed, falls back to `ls`)**

| Alias | Description |
|---|---|
| `ls` | List with icons |
| `ll` | Long list with git status |
| `la` | Long list including hidden files |
| `lt` | Tree view (2 levels) |

**File operations**

| Alias | Description |
|---|---|
| `cp` | Copy with confirmation |
| `mv` | Move with confirmation |
| `mkdir` | Create directory (including parents) |
| `rmf` | Force remove recursively |
| `trash` | Move to `~/.Trash` instead of deleting |

**Finder**

| Alias | Description |
|---|---|
| `show` | Show hidden files in Finder |
| `hide` | Hide hidden files in Finder |
| `o` | Open current directory in Finder |
| `of` | Open Finder at current directory |

**Clipboard**

| Alias / Function | Description |
|---|---|
| `pbp` | Paste from clipboard |
| `pbc` | Copy to clipboard |
| `copypwd()` | Copy current path to clipboard |

**Network**

| Alias | Description |
|---|---|
| `ip` | Show public IP address |
| `localip` | Show local IP address (en0) |
| `flushdns` | Flush DNS cache |
| `ports` | List all listening ports |
| `killport <port>` | Kill the process using a given port |

**System**

| Alias | Description |
|---|---|
| `brewup` | Update, upgrade, and clean up Homebrew |
| `zrc` | Edit `~/.zshrc` in vim |
| `src` | Reload `~/.zshrc` |
| `path` | Print `$PATH` entries line by line |
| `cpu` | Show CPU usage |
| `mem` | Show memory usage |
| `serve [port]` | Start a local HTTP server (default port 8080) |

---

#### `ssh-tmux` — SSH & tmux

**SSH**

| Alias / Function | Description |
|---|---|
| `sshconf` | Open `~/.ssh/config` in `$EDITOR` |
| `sshkeys` | List files in `~/.ssh` |
| `sshadd` | Add `~/.ssh/id_ed25519` to ssh-agent |
| `sshcopy [key]` | Copy public key to clipboard (default: `id_ed25519.pub`) |
| `sshgen <name> <email>` | Generate a new ed25519 SSH key and print the public key |

**tmux**

| Alias / Function | Description |
|---|---|
| `tls` | List tmux sessions |
| `tks <name>` | Kill a tmux session by name |
| `tka` | Kill the tmux server (all sessions) |
| `ta [name]` | Attach to existing session or create new one (default: `main`) |
| `tn [name]` | Create a new tmux session (default: current directory name) |
| `tdev [name]` | Create a 3-window dev layout: `editor`, `terminal`, `logs` |

---

### 👤 Roles

#### `frontend` — React, Vite, build tools

**Vite**

| Alias | Description |
|---|---|
| `vite-new` | Create a new Vite project |
| `vite-dev` | Start Vite dev server |
| `vite-build` | Build with Vite |
| `vite-preview` | Preview Vite production build |

**React / Next.js**

| Alias | Description |
|---|---|
| `cra` | Create React App |
| `next-new` | Create a new Next.js app |

**Webpack**

| Alias | Description |
|---|---|
| `wb` | Build for production |
| `wbd` | Build for development |
| `wbw` | Watch mode |

**Tailwind CSS**

| Alias | Description |
|---|---|
| `twbuild` | One-shot Tailwind build |
| `twwatch` | Tailwind watch mode |

**Testing**

| Alias | Description |
|---|---|
| `vtest` | Run Vitest |
| `vtestui` | Run Vitest with UI |
| `jest` | Run Jest |
| `jestw` | Run Jest in watch mode |
| `cy` | Open Cypress |
| `cyr` | Run Cypress headless |
| `pw` | Run Playwright tests |

**Lint / Format**

| Alias | Description |
|---|---|
| `eslint` | Run ESLint |
| `eslintfix` | Auto-fix ESLint issues in entire project |
| `prettier` | Run Prettier |
| `prettierfix` | Auto-format entire project with Prettier |
| `stylelint` | Run Stylelint |

**Storybook**

| Alias | Description |
|---|---|
| `sb` | Start Storybook dev server |
| `sbbuild` | Build Storybook |

**Utilities**

| Alias / Function | Description |
|---|---|
| `bundle-size()` | Analyze bundle size with `source-map-explorer` |
| `lighthouse [url]` | Run Lighthouse audit (default: `http://localhost:3000`) |
| `kill3000` | Kill process on port 3000 |
| `kill5173` | Kill process on port 5173 (Vite default) |

---

#### `backend` — Node, Python, databases

**Node.js / nvm**

| Alias | Description |
|---|---|
| `node-version` | Print current Node.js and npm versions |
| `nvm-list` | List installed Node.js versions |
| `nvm-use` | Switch Node.js version |
| `nvm-latest` | Install and use latest LTS |

**Python**

| Alias / Function | Description |
|---|---|
| `py` | `python3` |
| `pip` | `pip3` |
| `venv` | Create `.venv` virtual environment |
| `vact` | Activate `.venv` |
| `vdeact` | Deactivate virtual environment |
| `pipr` | `pip install -r requirements.txt` |
| `pipf` | Freeze dependencies to `requirements.txt` |
| `venv-init()` | Create `.venv`, activate it, and install `requirements.txt` if present |

**PostgreSQL**

| Alias / Function | Description |
|---|---|
| `pgstart` | Start PostgreSQL (Homebrew) |
| `pgstop` | Stop PostgreSQL |
| `pgrestart` | Restart PostgreSQL |
| `pglog` | Tail PostgreSQL logs |
| `pgcon [db] [user]` | Connect via psql (defaults: `postgres` / current user) |

**MySQL**

| Alias | Description |
|---|---|
| `mystart` | Start MySQL (Homebrew) |
| `mystop` | Stop MySQL |
| `mycon` | Connect as root |

**Redis**

| Alias | Description |
|---|---|
| `rdstart` | Start Redis (Homebrew) |
| `rdstop` | Stop Redis |
| `rdcli` | Open `redis-cli` |
| `rdflush` | Flush all Redis data |

**MongoDB**

| Alias | Description |
|---|---|
| `mgstart` | Start MongoDB (Homebrew) |
| `mgstop` | Stop MongoDB |
| `mgcli` | Open `mongosh` |

**API / Logs / Utilities**

| Alias / Function | Description |
|---|---|
| `http` | `httpie` shortcut |
| `jcurl <url>` | `curl` with pretty-printed JSON output |
| `logf` | `tail -f` |
| `logerr` | Tail system log filtered by errors |
| `whichport <port>` | Show which process is using a port |
| `envshow()` | Print non-comment lines from `.env` or `.env.local` |

---

#### `devops` — Docker, Terraform, AWS, CI/CD

**Docker**

| Alias / Function | Description |
|---|---|
| `d` | `docker` |
| `dps` | List running containers |
| `dpsa` | List all containers |
| `di` | List images |
| `drm` | Remove container |
| `drmi` | Remove image |
| `dstop` | Stop all running containers |
| `dstopa` | Stop all containers (including stopped) |
| `dclean` | Prune unused resources |
| `dcleanall` | Prune everything including volumes |
| `dlogs` | `docker logs -f` |
| `dexec` | `docker exec -it` |
| `dbuild [tag]` | Build image from current directory (default tag: `app`) |
| `drun [image] [port]` | Run container, mapping port (default: `app:3000`) |

**Docker Compose**

| Alias | Description |
|---|---|
| `dc` | `docker compose` |
| `dcu` | `docker compose up` |
| `dcud` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcr` | `docker compose restart` |
| `dcb` | `docker compose build` |
| `dcl` | `docker compose logs -f` |
| `dce` | `docker compose exec` |
| `dcps` | `docker compose ps` |

**Terraform**

| Alias | Description |
|---|---|
| `tf` | `terraform` |
| `tfi` | `terraform init` |
| `tfp` | `terraform plan` |
| `tfa` | `terraform apply` |
| `tfaa` | `terraform apply -auto-approve` |
| `tfd` | `terraform destroy` |
| `tfda` | `terraform destroy -auto-approve` |
| `tfo` | `terraform output` |
| `tfw` | `terraform workspace` |
| `tfwl` | `terraform workspace list` |
| `tfws` | `terraform workspace select` |

**AWS CLI**

| Alias / Function | Description |
|---|---|
| `awsid` | Print current AWS caller identity |
| `awsregion` | Print configured AWS region |
| `s3ls` | `aws s3 ls` |
| `s3cp` | `aws s3 cp` |
| `s3sync` | `aws s3 sync` |
| `ecrlogs` | List ECR repository names |
| `awsuse <profile>` | Switch AWS profile and verify identity |

**GitHub Actions (gh CLI)**

| Alias | Description |
|---|---|
| `gwf` | List workflows |
| `gwfr` | Trigger a workflow run |
| `grun` | List recent runs |
| `grunw` | Watch a run in real time |
| `grund` | Download run artifacts |

**Nginx**

| Alias | Description |
|---|---|
| `ngtest` | Test nginx configuration |
| `ngreload` | Reload nginx |
| `nglog` | Tail nginx access log |
| `ngerr` | Tail nginx error log |

**SSL / System Monitoring**

| Alias / Function | Description |
|---|---|
| `certcheck <domain>` | Check SSL certificate expiry dates for a domain |
| `topcpu` | Top 10 processes by CPU usage |
| `topmem` | Top 10 processes by memory usage |
| `diskuse` | Top 20 directories/files by disk usage |
| `dfh` | `df -h` disk free summary |

---

## Project Structure

```
zsh-aliases/
├── install.zsh              ← Interactive installer
├── aliases.zsh              ← Git tool aliases (loaded directly)
├── README.md
└── zsh-alias/
    ├── tools/
    │   ├── git/aliases.zsh
    │   ├── npm/aliases.zsh
    │   ├── macos/aliases.zsh
    │   └── ssh-tmux/aliases.zsh
    └── roles/
        ├── frontend/aliases.zsh
        ├── backend/aliases.zsh
        └── devops/aliases.zsh
```

---

## Adding a New Bundle

1. Create a file: `zsh-alias/tools/<name>/aliases.zsh` or `zsh-alias/roles/<name>/aliases.zsh`
2. Add an entry to the `BUNDLES` array in `install.zsh`:

```zsh
"myalias|Short description|🔧 Tools|zsh-alias/tools/myalias/aliases.zsh"
```

3. Run `zsh install.zsh` again

---

## Updating

```zsh
cd ~/zsh-alias
git pull
zsh install.zsh   # prompts confirmation for each previously installed bundle
```
