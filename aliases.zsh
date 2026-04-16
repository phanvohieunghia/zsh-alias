# ============================================================
# tools/git/aliases.zsh
# ============================================================

# --- Core ---
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias gf='git fetch --prune'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias glog='git log --oneline --graph --decorate --all'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gst='git stash'
alias gstp='git stash pop'
alias gdiff='git diff'
alias gds='git diff --staged'
alias gbranch='git symbolic-ref --short HEAD'

# --- Functions ---

# Push new branch + set upstream
gpush() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [ -z "$branch" ] && echo "❌ Could not determine branch" && return 1
  git push --set-upstream origin "$branch"
}

# Open PR (GitHub) or MR (GitLab) by number
gpr() {
  local pr_number=$1
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)
  [ -z "$remote_url" ] && echo "❌ No git remote origin found" && return 1
  [ -z "$pr_number" ] && echo "❌ Usage: gpr <pr_number>" && return 1

  remote_url=$(echo "$remote_url" \
    | sed "s|git@github.com:|https://github.com/|" \
    | sed "s|git@gitlab.com:|https://gitlab.com/|" \
    | sed "s|\.git$||")

  if echo "$remote_url" | grep -q "github.com"; then
    open "${remote_url}/pull/${pr_number}"
    echo "🔗 ${remote_url}/pull/${pr_number}"
  elif echo "$remote_url" | grep -q "gitlab.com"; then
    open "${remote_url}/-/merge_requests/${pr_number}"
    echo "🔗 ${remote_url}/-/merge_requests/${pr_number}"
  else
    echo "❌ Only GitHub / GitLab are supported" && return 1
  fi
}

# Delete local branches already merged into main/master
gclean() {
  local main_branch
  main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
  main_branch=${main_branch:-main}
  echo "🧹 Deleting branches merged into '${main_branch}'..."
  git branch --merged "$main_branch" \
    | grep -v "^\*\|${main_branch}\|master\|main\|develop" \
    | xargs -r git branch -d
  echo "✅ Done"
}

# Create a quick WIP commit
gwip() {
  git add -A
  git commit -m "wip: $(date '+%Y-%m-%d %H:%M')"
}
