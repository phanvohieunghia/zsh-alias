# Format clipboard thành kebab-case (vd: "Hello World" -> "hello-world"), hữu ích để tạo slug/branch name
alias nf='pbpaste | sed -E "s/[[:space:]]+/-/g" | tr "[:upper:]" "[:lower:]" | pbcopy'

# Clear terminal
alias cl='clear'

# Chạy Next.js dev song song với react-scan để debug re-render
alias nscan='next dev & npx react-scan@latest localhost:3000'

# Copy tên branch git hiện tại vào clipboard (đã xóa newline)
alias cb="g branch --show-current | tr -d '\n' | pbcopy;"

# Mở trang compare/tạo PR trên Chrome: so sánh branch hiện tại với target branch (mặc định: qc)
# Usage: nopr [target_branch]
nopr() {
  local target_branch=${1:-qc}
  local remote_url
  remote_url=$(git remote get-url origin | sed 's|git@\(.*\):\(.*\)|https://\1/\2|' | sed 's|\.git$||')
  open -a "Google Chrome" "${remote_url}/compare/${target_branch}...$(git branch --show-current)"
}



# Mở PR (GitHub) hoặc MR (GitLab) theo số PR/MR trên browser mặc định
# Usage: ngpr <pr_number>
ngpr() {
  local pr_number=$1
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)

  if [ -z "$remote_url" ]; then
    echo "❌ No git remote origin found"
    return 1
  fi

  if [ -z "$pr_number" ]; then
    echo "❌ Missing PR number. Usage: gpr <pr_number>"
    return 1
  fi

  remote_url=$(echo "$remote_url" | sed "s/git@github.com:/https:\/\/github.com\//; s/git@gitlab.com:/https:\/\/gitlab.com\//; s/\.git$//")

  if echo "$remote_url" | grep -q "github.com"; then
    open "${remote_url}/pull/${pr_number}"
  elif echo "$remote_url" | grep -q "gitlab.com"; then
    open "${remote_url}/-/merge_requests/${pr_number}"
  else
    echo "❌ Unrecognized host (only GitHub/GitLab supported)"
    return 1
  fi
}


# Open PR (GitHub) or MR (GitLab) by number
nogpr() {
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
ngclean() {
  local main_branch
  main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
  main_branch=${main_branch:-main}
  echo "🧹 Deleting branches merged into '${main_branch}'..."
  git branch --merged "$main_branch" \
    | grep -v "^\*\|${main_branch}\|master\|main\|develop" \
    | xargs -r git branch -d
  echo "✅ Done"
}



