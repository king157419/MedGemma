#!/bin/bash

# MedReport Bridge 初始化脚本
# 用于设置开发环境和验证基本功能

set -e

echo "=========================================="
echo "  MedReport Bridge - 项目初始化"
echo "=========================================="

# 检查 MoonBit 是否安装
echo ""
echo "[1/5] 检查 MoonBit 环境..."
if command -v moon &> /dev/null; then
    MOON_VERSION=$(moon version 2>&1 || echo "unknown")
    echo "    ✓ MoonBit 已安装: $MOON_VERSION"
else
    echo "    ✗ MoonBit 未安装"
    echo "    请从 https://www.moonbitlang.cn/download/ 下载安装"
    exit 1
fi

# 检查 Git 是否安装
echo ""
echo "[2/5] 检查 Git 环境..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    echo "    ✓ Git 已安装: $GIT_VERSION"
else
    echo "    ✗ Git 未安装"
    exit 1
fi

# 创建目录结构
echo ""
echo "[3/5] 创建目录结构..."
mkdir -p cmd/main
mkdir -p src/parser
mkdir -p src/gateway
mkdir -p src/formatter
mkdir -p src/types
mkdir -p src/server
mkdir -p tests
echo "    ✓ 目录结构已创建"

# 检查项目配置
echo ""
echo "[4/5] 验证项目配置..."
if [ -f "moon.mod.json" ]; then
    echo "    ✓ moon.mod.json 存在"
else
    echo "    ✗ moon.mod.json 不存在"
    exit 1
fi

if [ -f "moon.pkg.json" ]; then
    echo "    ✓ moon.pkg.json 存在"
else
    echo "    ✗ moon.pkg.json 不存在"
    exit 1
fi

# 构建测试
echo ""
echo "[5/5] 执行构建测试..."
moon check
if [ $? -eq 0 ]; then
    echo "    ✓ 项目检查通过"
else
    echo "    ! 项目检查有警告（可能是空项目）"
fi

echo ""
echo "=========================================="
echo "  初始化完成！"
echo "=========================================="
echo ""
echo "下一步操作："
echo "  1. 编写项目申报书 (docs/proposal.md)"
echo "  2. 开始开发核心模块"
echo "  3. 定期提交代码并更新 progress.md"
echo ""
