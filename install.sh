#!/bin/bash
# ark-usage 一键安装脚本
# https://github.com/midasism/ark-usage
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

BIN_DIR="$HOME/.local/bin"
SCRIPT_URL="https://raw.githubusercontent.com/midasism/ark-usage/refs/heads/master/ark-usage"

echo ""
echo -e "${BOLD}${CYAN}╭──────────────────────────────────────────────╮${NC}"
echo -e "${BOLD}${CYAN}│${NC}  🔥 火山方舟 · ark-usage 一键安装              ${BOLD}${CYAN}│${NC}"
echo -e "${BOLD}${CYAN}╰──────────────────────────────────────────────╯${NC}"
echo ""

# ── Step 1: 检查 Node.js ──

echo -e "  ${BOLD}[1/4]${NC} 检查 Node.js…"
if ! command -v node &>/dev/null; then
    echo ""
    echo -e "  ${RED}✗ 未检测到 Node.js${NC}"
    echo -e "  ${YELLOW}请先安装 Node.js: https://nodejs.org${NC} （下载 LTS 版本，双击安装）"
    echo -e "  ${DIM}安装完成后重新打开终端，再运行本脚本${NC}"
    echo ""
    exit 1
fi
echo -e "  ${GREEN}✓${NC} Node.js $(node --version)"

# ── Step 2: 安装 arkcli ──

echo -e "  ${BOLD}[2/4]${NC} 安装 arkcli…"
if command -v arkcli &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} arkcli 已安装 ($(arkcli --version 2>/dev/null || echo 'ok'))"
else
    npm install -g @volcengine/ark-cli 2>&1 || {
        echo ""
        echo -e "  ${RED}✗ arkcli 安装失败${NC}"
        echo -e "  ${DIM}请手动运行: npm install -g @volcengine/ark-cli${NC}"
        echo ""
        exit 1
    }
    echo -e "  ${GREEN}✓${NC} arkcli 安装完成"
fi

# ── Step 3: 下载 ark-usage ──

echo -e "  ${BOLD}[3/4]${NC} 安装 ark-usage 脚本…"
mkdir -p "$BIN_DIR"

if command -v curl &>/dev/null; then
    curl -fsSL "$SCRIPT_URL" -o "$BIN_DIR/ark-usage" 2>&1 || {
        echo -e "  ${RED}✗ 下载失败，请检查网络连接${NC}"
        exit 1
    }
elif command -v wget &>/dev/null; then
    wget -q "$SCRIPT_URL" -O "$BIN_DIR/ark-usage" || {
        echo -e "  ${RED}✗ 下载失败，请检查网络连接${NC}"
        exit 1
    }
else
    echo -e "  ${RED}✗ 未找到 curl 或 wget${NC}"
    exit 1
fi

chmod +x "$BIN_DIR/ark-usage"
echo -e "  ${GREEN}✓${NC} 已安装到 ${BIN_DIR}/ark-usage"

# ── Step 4: 配置 PATH ──

echo -e "  ${BOLD}[4/4]${NC} 配置环境变量…"
if ! echo "$PATH" | tr ':' '\n' | grep -qxF "$BIN_DIR"; then
    # 检测 shell 类型
    SHELL_RC=""
    case "$SHELL" in
        */zsh)  SHELL_RC="$HOME/.zshrc" ;;
        */bash) SHELL_RC="$HOME/.bashrc" ;;
        *)      SHELL_RC="$HOME/.profile" ;;
    esac
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
    echo -e "  ${GREEN}✓${NC} 已添加 ~/.local/bin 到 PATH（${SHELL_RC##*/}）"
else
    echo -e "  ${GREEN}✓${NC} PATH 已配置"
fi

# ── 完成 ──

echo ""
echo -e "${BOLD}${CYAN}╭──────────────────────────────────────────────╮${NC}"
echo -e "${BOLD}${CYAN}│${NC}  ${GREEN}✅ 安装完成！${NC}                                ${BOLD}${CYAN}│${NC}"
echo -e "${BOLD}${CYAN}╰──────────────────────────────────────────────╯${NC}"
echo ""
echo -e "  运行: ${BOLD}ark-usage${NC}"
echo ""
echo -e "  ${DIM}首次运行会自动弹出浏览器登录火山方舟${NC}"
echo -e "  ${DIM}登录一次管约 48 小时，过期自动提示重登${NC}"
echo ""

# 尝试立即刷新 PATH 并运行
export PATH="$BIN_DIR:$PATH"
if [ -t 0 ]; then
    read -r -p "  现在运行 ark-usage？[Y/n] " answer
    if [ -z "$answer" ] || [[ "$answer" =~ ^[Yy] ]]; then
        echo ""
        exec ark-usage
    fi
fi
