# ============================================================
# roles/devops/aliases.zsh — DevOps (CI/CD, cloud, infra)
# ============================================================

# --- Docker ---
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstop='docker stop $(docker ps -q)'
alias dstopa='docker stop $(docker ps -aq)'
alias dclean='docker system prune -f && echo "✅ Docker cleaned"'
alias dcleanall='docker system prune -af --volumes && echo "✅ Docker fully cleaned"'
alias dlogs='docker logs -f'
alias dexec='docker exec -it'

# Build and run image quickly
dbuild() {
  local tag=${1:-app}
  docker build -t "$tag" .
  echo "✅ Built image: $tag"
}

drun() {
  local image=${1:-app}
  local port=${2:-3000}
  docker run -d -p "${port}:${port}" --name "$image" "$image"
  echo "✅ Running $image on port $port"
}

# --- Docker Compose ---
alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcb='docker compose build'
alias dcl='docker compose logs -f'
alias dce='docker compose exec'
alias dcps='docker compose ps'

# --- Terraform ---
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfda='terraform destroy -auto-approve'
alias tfo='terraform output'
alias tfw='terraform workspace'
alias tfwl='terraform workspace list'
alias tfws='terraform workspace select'

# --- AWS CLI ---
alias awsid='aws sts get-caller-identity'
alias awsregion='aws configure get region'
alias s3ls='aws s3 ls'
alias s3cp='aws s3 cp'
alias s3sync='aws s3 sync'
alias ecrlogs='aws ecr describe-repositories --query "repositories[*].repositoryName"'

# Switch AWS profile quickly
awsuse() {
  export AWS_PROFILE=$1
  echo "✅ AWS Profile: $AWS_PROFILE"
  aws sts get-caller-identity
}

# --- GitHub Actions (gh cli) ---
alias gwf='gh workflow list'
alias gwfr='gh workflow run'
alias grun='gh run list'
alias grunw='gh run watch'
alias grund='gh run download'

# --- Nginx ---
alias ngtest='sudo nginx -t'
alias ngreload='sudo nginx -s reload'
alias nglog='sudo tail -f /var/log/nginx/access.log'
alias ngerr='sudo tail -f /var/log/nginx/error.log'

# --- SSL / Certs ---
# Check SSL cert expiry for a domain
certcheck() {
  local domain=$1
  [ -z "$domain" ] && echo "❌ Usage: certcheck <domain>" && return 1
  echo | openssl s_client -servername "$domain" -connect "${domain}:443" 2>/dev/null \
    | openssl x509 -noout -dates
}

# --- System monitoring ---
alias topcpu='ps aux | sort -rk 3,3 | head -10'
alias topmem='ps aux | sort -rk 4,4 | head -10'
alias diskuse='du -sh * | sort -rh | head -20'
alias dfh='df -h'
