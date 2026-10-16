#!/usr/bin/env bash

#
# 让 Bash 在遇到某些错误时停止执行
#
set -euo pipefail

#
# 进入项目根目录
#
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

#
# 创建 .env 文件
#
cat > .env <<EOF
EOF

#
# 启动服务
#
COMPOSE=(docker compose -f compose.yaml --env-file .env)

if [[ "${1:-}" == "--no-build" ]]; then
  "${COMPOSE[@]}" up -d --no-build
else
  "${COMPOSE[@]}" build
  "${COMPOSE[@]}" up -d
fi
