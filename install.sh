#!/bin/bash
# 安装 docforge 到系统路径

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="/usr/local/bin"

echo "安装 docforge..."

sudo ln -sf "$SCRIPT_DIR/docforge.sh" "$INSTALL_DIR/docforge"

echo "安装完成！现在可以在任意目录使用: docforge input.md"
