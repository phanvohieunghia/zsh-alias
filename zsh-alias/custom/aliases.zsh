alias cl='clear'
# Format clipboard to kebab-case (e.g., "Hello World" -> "hello-world"), useful for creating slug/branch name
alias nf='pbpaste | sed -E "s/[[:space:]]+/-/g" | tr "[:upper:]" "[:lower:]" | pbcopy'

# Run Next.js dev in parallel with react-scan to debug re-renders
alias nscan='npx -y react-scan@latest init'

# Copy current git branch name to clipboard (with newline stripped)
alias nc2b="g branch --show-current | tr -d '\n' | pbcopy;"

# nogh - Open GitHub/GitLab repo in browser with optional flags
#   nogh              → open repo homepage
#   nogh -c [branch]  → open compare/create PR page (default target: qc)
#   nogh -p           → open pulls/merge_requests list
#   nogh -p <number>  → open specific PR/MR by number
#   nogh -a           → open Actions tab (GitHub only)
nogh() {
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)
  [ -z "$remote_url" ] && echo "❌ No git remote origin found" && return 1

  remote_url=$(echo "$remote_url" \
    | sed "s|git@github.com-personal:|https://github.com/|;s|git@github.com:|https://github.com/|;s|git@gitlab.com:|https://gitlab.com/|;s|\.git$||")

  local is_github is_gitlab
  echo "$remote_url" | grep -q "github.com" && is_github=1
  echo "$remote_url" | grep -q "gitlab.com" && is_gitlab=1

  _open() { open -a "Google Chrome" "$1" && echo "🔗 $1"; }

  case "$1" in
    -c)
      local branch=${2:-qc}
      _open "${remote_url}/compare/${branch}...$(git branch --show-current)"
      ;;
    -a)
      [ -z "$is_github" ] && echo "❌ Actions tab is only supported on GitHub" && return 1
      _open "${remote_url}/actions"
      ;;
    -p)
      if [ -n "$is_github" ]; then
        _open "${remote_url}/pull${2:+/$2}"
      elif [ -n "$is_gitlab" ]; then
        _open "${remote_url}/-/merge_requests${2:+/$2}"
      else
        echo "❌ Only GitHub / GitLab are supported" && return 1
      fi
      ;;
    *)
      _open "$remote_url"
      ;;
  esac

  unset -f _open
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



