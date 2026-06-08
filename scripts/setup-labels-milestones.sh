#!/usr/bin/env bash
# 初始化 workbench-data 的标签与示例里程碑。
# 用法： bash scripts/setup-labels-milestones.sh [owner/repo]
set -euo pipefail
REPO="${1:-guaner-334/workbench-data}"

echo "==> 创建类型标签 ($REPO)"
gh label create "策划案" --repo "$REPO" --color "1f6feb" --description "策划文档需求" --force
gh label create "交互稿" --repo "$REPO" --color "2da44e" --description "交互稿 / 原型需求" --force
gh label create "原画"   --repo "$REPO" --color "8957e5" --description "原画 / 概念美术需求" --force

echo "==> 创建状态标签"
gh label create "待处理" --repo "$REPO" --color "d4c5f9" --description "已登记，待认领" --force
gh label create "生成中" --repo "$REPO" --color "fbca04" --description "skill 正在产出" --force
gh label create "待审核" --repo "$REPO" --color "d93f0b" --description "已提交 pending，等审批" --force
gh label create "已定稿" --repo "$REPO" --color "0e8a16" --description "已合并进正式库" --force

echo "==> 创建示例里程碑 v0.1 原型"
gh api "repos/$REPO/milestones" \
  -f title="v0.1 原型" \
  -f state="open" \
  -f description="第一个可玩原型：核心策划 + 关键交互稿 + 主角原画" \
  >/dev/null 2>&1 && echo "   已创建" || echo "   （已存在或创建失败，跳过）"

echo "==> 完成"
