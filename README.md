# zsh-aliases 🚀

A collection of aliases for macOS / zsh — organized by **tool** and **role**, with flexible installation.

---

## Quick Install

No clone required — install directly from GitHub:

```zsh
# Interactive menu
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh

# Install specific bundles
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- git npm

# Install all bundles
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --all
```

---

## Installer Usage

All commands work both via remote `curl | zsh -s --` and from a local clone (`zsh install.zsh`):

| Command          | Description                                              |
| ---------------- | -------------------------------------------------------- |
| _(no args)_      | Interactive menu to select bundles                       |
| `<id> [<id>...]` | Install one or more bundles by id (e.g. `git npm macos`) |
| `--all`          | Install all bundles                                      |
| `--list`         | List bundles and installation status                     |
| `--update`       | Re-fetch the latest version of every installed bundle    |
| `--remove <id>`  | Remove a single installed bundle                         |
| `--uninstall`    | Remove all bundles and the loader block from `~/.zshrc`  |

Examples (remote):

```zsh
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --list
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --update
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --remove git
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --uninstall
```

---

## How It Works

The installer downloads **only the bundles you pick** from GitHub raw content and saves each one as a standalone file under `~/.config/zsh-alias/`:

```
~/.config/zsh-alias/
├── git.zsh
├── npm.zsh
└── macos.zsh
```

A single loader block is added to `~/.zshrc` that sources every `.zsh` file in that directory:

```zsh
# >>> zsh-alias:loader >>>
# Loads alias bundles from /Users/you/.config/zsh-alias
if [ -d "$HOME/.config/zsh-alias" ]; then
  for f in "$HOME/.config/zsh-alias"/*.zsh(N); do
    source "$f"
  done
fi
# <<< zsh-alias:loader <<<
```

Benefits:

- **No repo clone required** — users never see bundles they didn't install
- **Self-contained** — uninstalling a bundle is a single `rm` of one file
- **Clean `~/.zshrc`** — only one loader block regardless of how many bundles are installed
- A timestamped backup of `~/.zshrc` is created before any change

---

## Bundles at a Glance

| Bundle                  | Category    | Features                                                                                                   |
| ----------------------- | ----------- | ---------------------------------------------------------------------------------------------------------- |
| [`git`](#git)           | 🔧 Tool     | Status/stage/commit • push/pull/fetch • branches • log/diff • stash • rebase • PR opener • cleanup helpers |
| [`npm`](#npm)           | 🔧 Tool     | npm • yarn • pnpm • auto-detected `dev` / `build` / `scripts`                                              |
| [`macos`](#macos)       | 🔧 Tool     | Navigation • listing (`eza`) • file ops • Finder • clipboard • network • system                            |
| [`ssh-tmux`](#ssh-tmux) | 🔧 Tool     | SSH keys & config • tmux sessions • dev layout                                                             |
| [`frontend`](#frontend) | 👤 Role     | Vite • React/Next • Webpack • Tailwind • testing • lint/format • Storybook                                 |
| [`backend`](#backend)   | 👤 Role     | Node/nvm • Python/venv • Postgres • MySQL • Redis • MongoDB • HTTP/logs                                    |
| [`devops`](#devops)     | 👤 Role     | Docker • Compose • Terraform • AWS • GitHub Actions • Nginx • SSL/monitoring                               |
| [`custom`](#custom)     | ✨ Personal | Clipboard helpers • PR/branch openers • branch cleanup                                                     |

---

## Alias Bundles

### 🔧 Tools

#### `git`

**Features:** status & staging · committing · push/pull/fetch · branches · log & diff · stash · rebase · PR/MR opener · branch cleanup

<details open>
<summary><b>Status & staging</b></summary>

| Alias | Command      | Description              |
| ----- | ------------ | ------------------------ |
| `gs`  | `git status` | Show working tree status |
| `ga`  | `git add`    | Stage files              |
| `gaa` | `git add .`  | Stage all changes        |

</details>

<details open>
<summary><b>Committing</b></summary>

| Alias | Command                        | Description                               |
| ----- | ------------------------------ | ----------------------------------------- |
| `gc`  | `git commit -m`                | Commit with message                       |
| `gca` | `git commit --amend --no-edit` | Amend last commit without editing message |

</details>

<details open>
<summary><b>Push / pull / fetch</b></summary>

| Alias / Function | Command                       | Description                                                                           |
| ---------------- | ----------------------------- | ------------------------------------------------------------------------------------- |
| `gp`             | `git push` (no arg)           | Push to remote; with a branch arg: switch to it, pull, switch back, then rebase on it |
| `gpf`            | `git push --force-with-lease` | Safe force push                                                                       |
| `gl`             | `git pull`                    | Pull from remote                                                                      |
| `gf`             | `git fetch --prune`           | Fetch and prune stale branches                                                        |
| `gpush()`        | —                             | Push current branch and set upstream automatically                                    |

</details>

<details open>
<summary><b>Branches</b></summary>

| Alias / Function | Command                         | Description                                               |
| ---------------- | ------------------------------- | --------------------------------------------------------- |
| `gco`            | `git checkout`                  | Checkout branch or file                                   |
| `gcb`            | `git checkout -b`               | Create and checkout new branch                            |
| `gbd`            | `git branch -d`                 | Delete branch (safe)                                      |
| `gbD`            | `git branch -D`                 | Delete branch (force)                                     |
| `gbranch`        | `git symbolic-ref --short HEAD` | Print current branch name                                 |
| `gclean()`       | —                               | Delete all local branches already merged into main/master |

</details>

<details open>
<summary><b>Log & diff</b></summary>

| Alias   | Command                                      | Description         |
| ------- | -------------------------------------------- | ------------------- |
| `glog`  | `git log --oneline --graph --decorate --all` | Visual commit graph |
| `gdiff` | `git diff`                                   | Show unstaged diff  |
| `gds`   | `git diff --staged`                          | Show staged diff    |

</details>

<details open>
<summary><b>Switch</b></summary>

| Alias    | Command                                                    | Description                                     |
| -------- | ---------------------------------------------------------- | ----------------------------------------------- |
| `gw`     | `git switch`                                               | Switch branch                                   |
| `gwc`    | `git switch -c`                                            | Create and switch to a new branch               |
| `gwst`   | `git switch staging`                                       | Switch to `staging` branch                      |
| `gwprod` | `git switch production`                                    | Switch to `production` branch                   |
| `gwp`    | `git switch $(git branch -r \| fzf \| sed "s/origin\///")` | Pick a remote branch via `fzf` and switch to it |

</details>

<details open>
<summary><b>Stash</b></summary>

| Alias  | Command             | Description                          |
| ------ | ------------------- | ------------------------------------ |
| `gst`  | `git stash`         | Stash changes                        |
| `gstp` | `git stash pop`     | Pop stash                            |
| `gss`  | `git stash save -u` | Save stash including untracked files |
| `gsp`  | `git stash pop`     | Pop stash                            |
| `gsd`  | `git stash drop`    | Drop the latest stash                |
| `gsa`  | `git stash apply`   | Apply stash without removing it      |

</details>

<details open>
<summary><b>Rebase</b></summary>

| Alias  | Command                 | Description                      |
| ------ | ----------------------- | -------------------------------- |
| `gr`   | `git rebase`            | Rebase                           |
| `gri`  | `git rebase -i`         | Interactive rebase               |
| `grb`  | `git rebase`            | Rebase                           |
| `grbi` | `git rebase -i`         | Interactive rebase               |
| `grc`  | `git rebase --continue` | Continue a paused rebase         |
| `gra`  | `git rebase --abort`    | Abort the current rebase         |
| `grs`  | `git rebase --skip`     | Skip current patch during rebase |

</details>

<details open>
<summary><b>Reset</b></summary>

| Alias / Function | Command                                       | Description                                                           |
| ---------------- | --------------------------------------------- | --------------------------------------------------------------------- |
| `grh`            | `git reset HEAD`                              | Reset index to HEAD (unstage, keep working tree)                      |
| `grhh`           | `git reset --hard HEAD`                       | Discard all uncommitted changes                                       |
| `grhs`           | `git reset --soft HEAD`                       | Soft reset to HEAD (keep index and working tree)                      |
| `grm`            | `git reset --mixed HEAD`                      | Mixed reset to HEAD (unstage, keep working tree)                      |
| `grhom`          | `git reset --hard origin/<current-branch>`    | Hard-reset current branch to its remote                               |
| `gunstage`       | `git reset HEAD --`                           | Unstage files                                                         |
| `grhhn [n]`      | `git reset --hard HEAD~n` (with confirmation) | Hard reset N commits back; prompts before destroying uncommitted work |
| `grshn [n]`      | `git reset --soft HEAD~n` (with confirmation) | Soft reset N commits back (keeps changes, unstages commits)           |

</details>

<details open>
<summary><b>PR / MR opener</b></summary>

| Function       | Description                                          |
| -------------- | ---------------------------------------------------- |
| `gpr <number>` | Open PR (GitHub) or MR (GitLab) in browser by number |

</details>

---

#### `npm`

**Features:** npm shortcuts · yarn shortcuts · pnpm shortcuts · auto-detected `dev` / `build` / `scripts`

<details open>
<summary><b>npm</b></summary>

| Alias   | Command                  | Description               |
| ------- | ------------------------ | ------------------------- |
| `ni`    | `npm install`            | Install dependencies      |
| `nid`   | `npm install --save-dev` | Install as dev dependency |
| `nig`   | `npm install -g`         | Install globally          |
| `nun`   | `npm uninstall`          | Uninstall package         |
| `nrun`  | `npm run`                | Run script                |
| `nst`   | `npm start`              | Start                     |
| `nt`    | `npm test`               | Test                      |
| `nb`    | `npm run build`          | Build                     |
| `ndev`  | `npm run dev`            | Dev server                |
| `nlint` | `npm run lint`           | Lint                      |
| `nci`   | `npm ci`                 | Clean install             |
| `nout`  | `npm outdated`           | Show outdated packages    |
| `nup`   | `npm update`             | Update packages           |
| `nls`   | `npm list --depth=0`     | List top-level packages   |

</details>

<details open>
<summary><b>yarn</b></summary>

| Alias   | Command          | Description        |
| ------- | ---------------- | ------------------ |
| `yi`    | `yarn install`   | Install            |
| `ya`    | `yarn add`       | Add package        |
| `yad`   | `yarn add --dev` | Add dev dependency |
| `yr`    | `yarn remove`    | Remove package     |
| `yrun`  | `yarn run`       | Run script         |
| `yst`   | `yarn start`     | Start              |
| `yt`    | `yarn test`      | Test               |
| `yb`    | `yarn build`     | Build              |
| `ydev`  | `yarn dev`       | Dev server         |
| `ylint` | `yarn lint`      | Lint               |

</details>

<details open>
<summary><b>pnpm</b></summary>

| Alias   | Command                          | Description        |
| ------- | -------------------------------- | ------------------ |
| `pi`    | `pnpm install`                   | Install            |
| `pa`    | `pnpm add`                       | Add package        |
| `pad`   | `pnpm add -D`                    | Add dev dependency |
| `pr`    | `pnpm remove`                    | Remove package     |
| `prun`  | `pnpm run`                       | Run script         |
| `pst`   | `pnpm start`                     | Start              |
| `pt`    | `pnpm test`                      | Test               |
| `pb`    | `pnpm build`                     | Build              |
| `pdev`  | `pnpm dev`                       | Dev server         |
| `plint` | `pnpm lint`                      | Lint               |
| `pci`   | `pnpm install --frozen-lockfile` | CI install         |

</details>

<details open>
<summary><b>Smart functions (auto-detect package manager)</b></summary>

| Function    | Description                                                                 |
| ----------- | --------------------------------------------------------------------------- |
| `dev()`     | Run dev server using the detected package manager (`pnpm` / `yarn` / `npm`) |
| `build()`   | Run build using the detected package manager                                |
| `scripts()` | Pretty-print all scripts defined in `package.json`                          |

</details>

---

#### `macos`

**Features:** navigation · listing (`eza`) · file operations · Finder · clipboard · network · system

<details open>
<summary><b>Navigation</b></summary>

| Alias                 | Description                 |
| --------------------- | --------------------------- |
| `..` / `...` / `....` | Go up 1 / 2 / 3 directories |
| `~`                   | Go to home directory        |
| `dl`                  | Go to `~/Downloads`         |
| `dt`                  | Go to `~/Desktop`           |
| `dev`                 | Go to `~/Developer`         |

</details>

<details open>
<summary><b>Listing (uses <code>eza</code> if installed, falls back to <code>ls</code>)</b></summary>

| Alias | Description                      |
| ----- | -------------------------------- |
| `ls`  | List with icons                  |
| `ll`  | Long list with git status        |
| `la`  | Long list including hidden files |
| `lt`  | Tree view (2 levels)             |

</details>

<details open>
<summary><b>File operations</b></summary>

| Alias   | Description                            |
| ------- | -------------------------------------- |
| `cp`    | Copy with confirmation                 |
| `mv`    | Move with confirmation                 |
| `mkdir` | Create directory (including parents)   |
| `rmf`   | Force remove recursively               |
| `trash` | Move to `~/.Trash` instead of deleting |

</details>

<details open>
<summary><b>Finder</b></summary>

| Alias  | Description                      |
| ------ | -------------------------------- |
| `show` | Show hidden files in Finder      |
| `hide` | Hide hidden files in Finder      |
| `o`    | Open current directory in Finder |
| `of`   | Open Finder at current directory |

</details>

<details open>
<summary><b>Clipboard</b></summary>

| Alias / Function | Description                    |
| ---------------- | ------------------------------ |
| `pbp`            | Paste from clipboard           |
| `pbc`            | Copy to clipboard              |
| `copypwd()`      | Copy current path to clipboard |

</details>

<details open>
<summary><b>Network</b></summary>

| Alias             | Description                         |
| ----------------- | ----------------------------------- |
| `ip`              | Show public IP address              |
| `localip`         | Show local IP address (en0)         |
| `flushdns`        | Flush DNS cache                     |
| `ports`           | List all listening ports            |
| `killport <port>` | Kill the process using a given port |

</details>

<details open>
<summary><b>System</b></summary>

| Alias          | Description                                   |
| -------------- | --------------------------------------------- |
| `brewup`       | Update, upgrade, and clean up Homebrew        |
| `zrc`          | Edit `~/.zshrc` in vim                        |
| `src`          | Reload `~/.zshrc`                             |
| `path`         | Print `$PATH` entries line by line            |
| `cpu`          | Show CPU usage                                |
| `mem`          | Show memory usage                             |
| `serve [port]` | Start a local HTTP server (default port 8080) |

</details>

---

#### `ssh-tmux`

**Features:** SSH keys & config · tmux session management · dev layout

<details open>
<summary><b>SSH</b></summary>

| Alias / Function        | Description                                              |
| ----------------------- | -------------------------------------------------------- |
| `sshconf`               | Open `~/.ssh/config` in `$EDITOR`                        |
| `sshkeys`               | List files in `~/.ssh`                                   |
| `sshadd`                | Add `~/.ssh/id_ed25519` to ssh-agent                     |
| `sshcopy [key]`         | Copy public key to clipboard (default: `id_ed25519.pub`) |
| `sshgen <name> <email>` | Generate a new ed25519 SSH key and print the public key  |

</details>

<details open>
<summary><b>tmux</b></summary>

| Alias / Function | Description                                                    |
| ---------------- | -------------------------------------------------------------- |
| `tls`            | List tmux sessions                                             |
| `tks <name>`     | Kill a tmux session by name                                    |
| `tka`            | Kill the tmux server (all sessions)                            |
| `ta [name]`      | Attach to existing session or create new one (default: `main`) |
| `tn [name]`      | Create a new tmux session (default: current directory name)    |
| `tdev [name]`    | Create a 3-window dev layout: `editor`, `terminal`, `logs`     |

</details>

---

### 👤 Roles

#### `frontend`

**Features:** Vite · React/Next · Webpack · Tailwind · testing (Vitest/Jest/Cypress/Playwright) · lint & format · Storybook · bundle analysis

<details open>
<summary><b>Vite</b></summary>

| Alias          | Description                   |
| -------------- | ----------------------------- |
| `vite-new`     | Create a new Vite project     |
| `vite-dev`     | Start Vite dev server         |
| `vite-build`   | Build with Vite               |
| `vite-preview` | Preview Vite production build |

</details>

<details open>
<summary><b>React / Next.js</b></summary>

| Alias      | Description              |
| ---------- | ------------------------ |
| `cra`      | Create React App         |
| `next-new` | Create a new Next.js app |

</details>

<details open>
<summary><b>Webpack</b></summary>

| Alias | Description           |
| ----- | --------------------- |
| `wb`  | Build for production  |
| `wbd` | Build for development |
| `wbw` | Watch mode            |

</details>

<details open>
<summary><b>Tailwind CSS</b></summary>

| Alias     | Description             |
| --------- | ----------------------- |
| `twbuild` | One-shot Tailwind build |
| `twwatch` | Tailwind watch mode     |

</details>

<details open>
<summary><b>Testing</b></summary>

| Alias     | Description            |
| --------- | ---------------------- |
| `vtest`   | Run Vitest             |
| `vtestui` | Run Vitest with UI     |
| `jest`    | Run Jest               |
| `jestw`   | Run Jest in watch mode |
| `cy`      | Open Cypress           |
| `cyr`     | Run Cypress headless   |
| `pw`      | Run Playwright tests   |

</details>

<details open>
<summary><b>Lint / Format</b></summary>

| Alias         | Description                              |
| ------------- | ---------------------------------------- |
| `eslint`      | Run ESLint                               |
| `eslintfix`   | Auto-fix ESLint issues in entire project |
| `prettier`    | Run Prettier                             |
| `prettierfix` | Auto-format entire project with Prettier |
| `stylelint`   | Run Stylelint                            |

</details>

<details open>
<summary><b>Storybook</b></summary>

| Alias     | Description                |
| --------- | -------------------------- |
| `sb`      | Start Storybook dev server |
| `sbbuild` | Build Storybook            |

</details>

<details open>
<summary><b>Utilities</b></summary>

| Alias / Function   | Description                                             |
| ------------------ | ------------------------------------------------------- |
| `bundle-size()`    | Analyze bundle size with `source-map-explorer`          |
| `lighthouse [url]` | Run Lighthouse audit (default: `http://localhost:3000`) |
| `kill3000`         | Kill process on port 3000                               |
| `kill5173`         | Kill process on port 5173 (Vite default)                |

</details>

---

#### `backend`

**Features:** Node/nvm · Python & venv · PostgreSQL · MySQL · Redis · MongoDB · HTTP & logs

<details open>
<summary><b>Node.js / nvm</b></summary>

| Alias          | Description                            |
| -------------- | -------------------------------------- |
| `node-version` | Print current Node.js and npm versions |
| `nvm-list`     | List installed Node.js versions        |
| `nvm-use`      | Switch Node.js version                 |
| `nvm-latest`   | Install and use latest LTS             |

</details>

<details open>
<summary><b>Python</b></summary>

| Alias / Function | Description                                                            |
| ---------------- | ---------------------------------------------------------------------- |
| `py`             | `python3`                                                              |
| `pip`            | `pip3`                                                                 |
| `venv`           | Create `.venv` virtual environment                                     |
| `vact`           | Activate `.venv`                                                       |
| `vdeact`         | Deactivate virtual environment                                         |
| `pipr`           | `pip install -r requirements.txt`                                      |
| `pipf`           | Freeze dependencies to `requirements.txt`                              |
| `venv-init()`    | Create `.venv`, activate it, and install `requirements.txt` if present |

</details>

<details open>
<summary><b>PostgreSQL</b></summary>

| Alias / Function    | Description                                            |
| ------------------- | ------------------------------------------------------ |
| `pgstart`           | Start PostgreSQL (Homebrew)                            |
| `pgstop`            | Stop PostgreSQL                                        |
| `pgrestart`         | Restart PostgreSQL                                     |
| `pglog`             | Tail PostgreSQL logs                                   |
| `pgcon [db] [user]` | Connect via psql (defaults: `postgres` / current user) |

</details>

<details open>
<summary><b>MySQL</b></summary>

| Alias     | Description            |
| --------- | ---------------------- |
| `mystart` | Start MySQL (Homebrew) |
| `mystop`  | Stop MySQL             |
| `mycon`   | Connect as root        |

</details>

<details open>
<summary><b>Redis</b></summary>

| Alias     | Description            |
| --------- | ---------------------- |
| `rdstart` | Start Redis (Homebrew) |
| `rdstop`  | Stop Redis             |
| `rdcli`   | Open `redis-cli`       |
| `rdflush` | Flush all Redis data   |

</details>

<details open>
<summary><b>MongoDB</b></summary>

| Alias     | Description              |
| --------- | ------------------------ |
| `mgstart` | Start MongoDB (Homebrew) |
| `mgstop`  | Stop MongoDB             |
| `mgcli`   | Open `mongosh`           |

</details>

<details open>
<summary><b>API / Logs / Utilities</b></summary>

| Alias / Function   | Description                                         |
| ------------------ | --------------------------------------------------- |
| `http`             | `httpie` shortcut                                   |
| `jcurl <url>`      | `curl` with pretty-printed JSON output              |
| `logf`             | `tail -f`                                           |
| `logerr`           | Tail system log filtered by errors                  |
| `whichport <port>` | Show which process is using a port                  |
| `envshow()`        | Print non-comment lines from `.env` or `.env.local` |

</details>

---

#### `devops`

**Features:** Docker · Docker Compose · Terraform · AWS CLI · GitHub Actions · Nginx · SSL & system monitoring

<details open>
<summary><b>Docker</b></summary>

| Alias / Function      | Description                                             |
| --------------------- | ------------------------------------------------------- |
| `d`                   | `docker`                                                |
| `dps`                 | List running containers                                 |
| `dpsa`                | List all containers                                     |
| `di`                  | List images                                             |
| `drm`                 | Remove container                                        |
| `drmi`                | Remove image                                            |
| `dstop`               | Stop all running containers                             |
| `dstopa`              | Stop all containers (including stopped)                 |
| `dclean`              | Prune unused resources                                  |
| `dcleanall`           | Prune everything including volumes                      |
| `dlogs`               | `docker logs -f`                                        |
| `dexec`               | `docker exec -it`                                       |
| `dbuild [tag]`        | Build image from current directory (default tag: `app`) |
| `drun [image] [port]` | Run container, mapping port (default: `app:3000`)       |

</details>

<details open>
<summary><b>Docker Compose</b></summary>

| Alias  | Description              |
| ------ | ------------------------ |
| `dc`   | `docker compose`         |
| `dcu`  | `docker compose up`      |
| `dcud` | `docker compose up -d`   |
| `dcd`  | `docker compose down`    |
| `dcr`  | `docker compose restart` |
| `dcb`  | `docker compose build`   |
| `dcl`  | `docker compose logs -f` |
| `dce`  | `docker compose exec`    |
| `dcps` | `docker compose ps`      |

</details>

<details open>
<summary><b>Terraform</b></summary>

| Alias  | Description                       |
| ------ | --------------------------------- |
| `tf`   | `terraform`                       |
| `tfi`  | `terraform init`                  |
| `tfp`  | `terraform plan`                  |
| `tfa`  | `terraform apply`                 |
| `tfaa` | `terraform apply -auto-approve`   |
| `tfd`  | `terraform destroy`               |
| `tfda` | `terraform destroy -auto-approve` |
| `tfo`  | `terraform output`                |
| `tfw`  | `terraform workspace`             |
| `tfwl` | `terraform workspace list`        |
| `tfws` | `terraform workspace select`      |

</details>

<details open>
<summary><b>AWS CLI</b></summary>

| Alias / Function   | Description                            |
| ------------------ | -------------------------------------- |
| `awsid`            | Print current AWS caller identity      |
| `awsregion`        | Print configured AWS region            |
| `s3ls`             | `aws s3 ls`                            |
| `s3cp`             | `aws s3 cp`                            |
| `s3sync`           | `aws s3 sync`                          |
| `ecrlogs`          | List ECR repository names              |
| `awsuse <profile>` | Switch AWS profile and verify identity |

</details>

<details open>
<summary><b>GitHub Actions (gh CLI)</b></summary>

| Alias   | Description              |
| ------- | ------------------------ |
| `gwf`   | List workflows           |
| `gwfr`  | Trigger a workflow run   |
| `grun`  | List recent runs         |
| `grunw` | Watch a run in real time |
| `grund` | Download run artifacts   |

</details>

<details open>
<summary><b>Nginx</b></summary>

| Alias      | Description              |
| ---------- | ------------------------ |
| `ngtest`   | Test nginx configuration |
| `ngreload` | Reload nginx             |
| `nglog`    | Tail nginx access log    |
| `ngerr`    | Tail nginx error log     |

</details>

<details open>
<summary><b>SSL / System Monitoring</b></summary>

| Alias / Function     | Description                                     |
| -------------------- | ----------------------------------------------- |
| `certcheck <domain>` | Check SSL certificate expiry dates for a domain |
| `topcpu`             | Top 10 processes by CPU usage                   |
| `topmem`             | Top 10 processes by memory usage                |
| `diskuse`            | Top 20 directories/files by disk usage          |
| `dfh`                | `df -h` disk free summary                       |

</details>

---

### ✨ Personal

#### `custom`

**Features:** clipboard helpers · PR/branch openers · branch cleanup · misc dev shortcuts

<details open>
<summary><b>Shell</b></summary>

| Alias | Description |
| ----- | ----------- |
| `cl`  | `clear`     |

</details>

<details open>
<summary><b>Clipboard helpers</b></summary>

| Alias  | Description                                                           |
| ------ | --------------------------------------------------------------------- |
| `nf`   | Format clipboard text to kebab-case (useful for slugs / branch names) |
| `nc2b` | Copy current git branch name to clipboard (newline stripped)          |

</details>

<details open>
<summary><b>Git / PR</b></summary>

| Function           | Description                                                                                |
| ------------------ | ------------------------------------------------------------------------------------------ |
| `nogh`             | Open the repo in Chrome (github)                                                           |
| `nogh -c [branch]` | Compare current branch against target and open the PR creation page (default target: `qc`) |
| `nogh -p`          | Browse all open PRs / MRs                                                                  |
| `nogh -p <number>` | Jump to a specific PR (GitHub) or MR (GitLab) by number                                    |
| `nogh -a`          | Go to the Actions tab (GitHub only)                                                        |
| `ngclean [branch]` | Delete local branches already merged into target (default: current branch)                 |

</details>

<details open>
<summary><b>Dev utilities</b></summary>

| Alias / Function | Description                                                                                      |
| ---------------- | ------------------------------------------------------------------------------------------------ |
| `nscan`          | Run `react-scan` to debug React re-renders                                                       |
| `norepo()`       | Fuzzy-pick a project directory (depth ≤ 4, excluding `node_modules`/`.git`/`dist`/`.next`) and `cd` into it |

</details>

---

## Project Structure

```
zsh-alias/                   ← Source repo (maintainers only)
├── install.zsh              ← Remote installer
├── README.md
└── zsh-alias/
    ├── tools/
    │   ├── git/aliases.zsh
    │   ├── npm/aliases.zsh
    │   ├── macos/aliases.zsh
    │   └── ssh-tmux/aliases.zsh
    ├── roles/
    │   ├── frontend/aliases.zsh
    │   ├── backend/aliases.zsh
    │   └── devops/aliases.zsh
    └── custom/
        └── aliases.zsh
```

End-user layout after install:

```
~/.config/zsh-alias/         ← Only the bundles the user chose
├── git.zsh
└── npm.zsh
```

---

## Adding a New Bundle

1. Create a file: `zsh-alias/tools/<name>/aliases.zsh` or `zsh-alias/roles/<name>/aliases.zsh`
2. Add an entry to the `BUNDLES` array in `install.zsh`:

```zsh
"myalias|Short description|🔧 Tools|zsh-alias/tools/myalias/aliases.zsh"
```

3. Commit and push to `main` — users can install with:

```zsh
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- myalias
```

---

## Updating

Re-fetch the latest version of every installed bundle:

```zsh
curl -fsSL https://raw.githubusercontent.com/phanvohieunghia/zsh-alias/main/install.zsh | zsh -s -- --update
```
