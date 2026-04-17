alias cl='clear'
# Format clipboard to kebab-case (e.g., "Hello World" -> "hello-world"), useful for creating slug/branch name
alias nf='pbpaste | sed -E "s/[[:space:]]+/-/g" | tr "[:upper:]" "[:lower:]" | pbcopy'

# Run Next.js dev in parallel with react-scan to debug re-renders
alias nscan='npx -y react-scan@latest init'

# Copy current git branch name to clipboard (with newline stripped)
alias nc2c="g branch --show-current | tr -d '\n' | pbcopy;"

# Open compare/create PR page in Chrome: compare current branch against target branch (default: qc)
ncpr() {
  local target_branch=${1:-qc}
  local remote_url
  remote_url=$(git remote get-url origin | sed 's|git@\(.*\):\(.*\)|https://\1/\2|' | sed 's|\.git$||')
  open -a "Google Chrome" "${remote_url}/compare/${target_branch}...$(git branch --show-current)"
}


# Open PR (GitHub) or MR (GitLab) by number
nopr() {
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
# Delete local branches already merged into the given branch (default: origin HEAD)
ngclean() {
  local target_branch
  if [ -n "$1" ]; then
    target_branch="$1"
  else
    target_branch=$(git branch --show-current)
  fi
  echo "🧹 Deleting branches merged into '${target_branch}'..."
  git branch --merged "$target_branch" \
    | grep -v "^\*\|${target_branch}\|master\|main\|develop" \
    | xargs -r git branch -d
  echo "✅ Done"
}



