# ============================================================
# roles/devops/aliases.zsh — DevOps (CI/CD, cloud, infra)
# ============================================================

# --- Docker ---
_require_docker() { command -v docker &>/dev/null || { echo "${1}: 'docker' not found (https://docs.docker.com/get-docker/)"; return 1; }; }

alias d='docker'
dps()     { _require_docker dps     || return 1; docker ps; }
dpsa()    { _require_docker dpsa    || return 1; docker ps -a; }
di()      { _require_docker di      || return 1; docker images; }
drm()     { _require_docker drm     || return 1; docker rm "$@"; }
drmi()    { _require_docker drmi    || return 1; docker rmi "$@"; }
dstop()   { _require_docker dstop   || return 1; docker stop $(docker ps -q); }
dstopa()  { _require_docker dstopa  || return 1; docker stop $(docker ps -aq); }
dclean()  { _require_docker dclean  || return 1; docker system prune -f && echo "✅ Docker cleaned"; }
dcleanall() { _require_docker dcleanall || return 1; docker system prune -af --volumes && echo "✅ Docker fully cleaned"; }
dlogs()   { _require_docker dlogs   || return 1; docker logs -f "$@"; }
dexec()   { _require_docker dexec   || return 1; docker exec -it "$@"; }

dbuild() {
  _require_docker dbuild || return 1
  local tag=${1:-app}
  docker build -t "$tag" .
  echo "✅ Built image: $tag"
}

drun() {
  _require_docker drun || return 1
  local image=${1:-app}
  local port=${2:-3000}
  docker run -d -p "${port}:${port}" --name "$image" "$image"
  echo "✅ Running $image on port $port"
}

# --- Docker Compose ---
dc()   { _require_docker dc   || return 1; docker compose "$@"; }
dcu()  { _require_docker dcu  || return 1; docker compose up "$@"; }
dcud() { _require_docker dcud || return 1; docker compose up -d "$@"; }
dcd()  { _require_docker dcd  || return 1; docker compose down "$@"; }
dcr()  { _require_docker dcr  || return 1; docker compose restart "$@"; }
dcb()  { _require_docker dcb  || return 1; docker compose build "$@"; }
dcl()  { _require_docker dcl  || return 1; docker compose logs -f "$@"; }
dce()  { _require_docker dce  || return 1; docker compose exec "$@"; }
dcps() { _require_docker dcps || return 1; docker compose ps "$@"; }

# --- Terraform ---
_require_terraform() { command -v terraform &>/dev/null || { echo "${1}: 'terraform' not found (brew install terraform)"; return 1; }; }

tf()   { _require_terraform tf   || return 1; terraform "$@"; }
tfi()  { _require_terraform tfi  || return 1; terraform init; }
tfp()  { _require_terraform tfp  || return 1; terraform plan; }
tfa()  { _require_terraform tfa  || return 1; terraform apply; }
tfaa() { _require_terraform tfaa || return 1; terraform apply -auto-approve; }
tfd()  { _require_terraform tfd  || return 1; terraform destroy; }
tfda() { _require_terraform tfda || return 1; terraform destroy -auto-approve; }
tfo()  { _require_terraform tfo  || return 1; terraform output; }
tfw()  { _require_terraform tfw  || return 1; terraform workspace "$@"; }
tfwl() { _require_terraform tfwl || return 1; terraform workspace list; }
tfws() { _require_terraform tfws || return 1; terraform workspace select "$@"; }

# --- AWS CLI ---
_require_aws() { command -v aws &>/dev/null || { echo "${1}: 'aws' not found (brew install awscli)"; return 1; }; }

awsid()     { _require_aws awsid     || return 1; aws sts get-caller-identity; }
awsregion() { _require_aws awsregion || return 1; aws configure get region; }
s3ls()      { _require_aws s3ls      || return 1; aws s3 ls "$@"; }
s3cp()      { _require_aws s3cp      || return 1; aws s3 cp "$@"; }
s3sync()    { _require_aws s3sync    || return 1; aws s3 sync "$@"; }
ecrlogs()   { _require_aws ecrlogs   || return 1; aws ecr describe-repositories --query "repositories[*].repositoryName"; }

awsuse() {
  _require_aws awsuse || return 1
  export AWS_PROFILE=$1
  echo "✅ AWS Profile: $AWS_PROFILE"
  aws sts get-caller-identity
}

# --- GitHub Actions (gh cli) ---
_require_gh() { command -v gh &>/dev/null || { echo "${1}: 'gh' not found (brew install gh)"; return 1; }; }

gwf()   { _require_gh gwf   || return 1; gh workflow list; }
gwfr()  { _require_gh gwfr  || return 1; gh workflow run "$@"; }
grun()  { _require_gh grun  || return 1; gh run list; }
grunw() { _require_gh grunw || return 1; gh run watch "$@"; }
grund() { _require_gh grund  || return 1; gh run download "$@"; }

# --- Nginx ---
_require_nginx() { command -v nginx &>/dev/null || { echo "${1}: 'nginx' not found (brew install nginx)"; return 1; }; }

ngtest()   { _require_nginx ngtest   || return 1; sudo nginx -t; }
ngreload() { _require_nginx ngreload || return 1; sudo nginx -s reload; }
nglog()    { _require_nginx nglog    || return 1; sudo tail -f /var/log/nginx/access.log; }
ngerr()    { _require_nginx ngerr    || return 1; sudo tail -f /var/log/nginx/error.log; }

# --- SSL / Certs ---
certcheck() {
  local domain=$1
  [ -z "$domain" ] && echo "❌ Usage: certcheck <domain>" && return 1
  command -v openssl &>/dev/null || { echo "certcheck: 'openssl' not found (brew install openssl)"; return 1; }
  echo | openssl s_client -servername "$domain" -connect "${domain}:443" 2>/dev/null \
    | openssl x509 -noout -dates
}

# --- System monitoring ---
alias topcpu='ps aux | sort -rk 3,3 | head -10'
alias topmem='ps aux | sort -rk 4,4 | head -10'
alias diskuse='du -sh * | sort -rh | head -20'
alias dfh='df -h'
