#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${1:?repo url required}"
APP_DIR=/root/flask-web-app

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y git python3-pip supervisor

# 首次或更新代码
if [ ! -d "$APP_DIR/.git" ]; then
  rm -rf "$APP_DIR"
  git clone "$REPO_URL" "$APP_DIR"
else
  cd "$APP_DIR"
  git remote set-url origin "$REPO_URL" || true
  git fetch origin
  git reset --hard origin/main
fi

cd "$APP_DIR"
pip3 install --upgrade pip
pip3 install -r requirements.txt

# 安装/更新 supervisor 配置（从仓库拷贝）
install -m 644 deploy/supervisor/flask-web-app.conf /etc/supervisor/conf.d/flask-web-app.conf

# 让 supervisor 识别并拉起服务
supervisorctl reread || true
supervisorctl update || true
supervisorctl restart flask-web-app || supervisorctl start flask-web-app

# 简单健康检查
supervisorctl status flask-web-app || true
tail -n 50 "$APP_DIR/app.log" || true
