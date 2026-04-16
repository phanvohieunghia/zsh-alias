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

# Push branch mới + set upstream
gpush() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [ -z "$branch" ] && echo "❌ Không xác định được branch" && return 1
  git push --set-upstream origin "$branch"
}

# Mở PR (GitHub) hoặc MR (GitLab) theo số
gpr() {
  local pr_number=$1
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)
  [ -z "$remote_url" ] && echo "❌ Không tìm thấy git remote origin" && return 1
  [ -z "$pr_number" ] && echo "❌ Dùng: gpr <số_pr>" && return 1

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
    echo "❌ Chỉ hỗ trợ GitHub / GitLab" && return 1
  fi
}

# Xóa branch local đã merge vào main/master
gclean() {
  local main_branch
  main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
  main_branch=${main_branch:-main}
  echo "🧹 Xóa branch đã merge vào '${main_branch}'..."
  git branch --merged "$main_branch" \
    | grep -v "^\*\|${main_branch}\|master\|main\|develop" \
    | xargs -r git branch -d
  echo "✅ Done"
}

# Tạo commit WIP nhanh
gwip() {
  git add -A
  git commit -m "wip: $(date '+%Y-%m-%d %H:%M')"
}
