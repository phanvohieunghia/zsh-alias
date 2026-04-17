# ============================================================
# tools/git/aliases.zsh
# ============================================================

# --- Core ---
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'

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

alias gwst='git switch staging;'
alias gwprod='git switch production;'
alias gw='git switch'
alias gwc='git switch -c'
alias gwp='git switch $(git branch -r | fzf | sed "s/origin\///")'

alias gss='git stash save -u'
alias gsp='git stash pop;'
alias gsd='git stash drop;'
alias gsa='git stash apply;'

alias grc='git rebase --continue;'
alias gra='git rebase --abort;'
alias grs='git rebase --skip;'
alias gr='git rebase'
alias gri='git rebase -i'




# --- Functions ---
# Push new branch + set upstream
gpush() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [ -z "$branch" ] && echo "❌ Could not determine branch" && return 1
  git push --set-upstream origin "$branch"
}

unalias gp 2>/dev/null
gp() {
  if [ -z "$1" ]; then
    git push
    return 1
  fi
  g switch "$1" && g pull && g switch - && g rebase "$1"
}

