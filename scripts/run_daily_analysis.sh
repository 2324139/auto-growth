#!/bin/bash

# 每日包分析運行器
# 智能避免重複分析，每次生成一份報告

GROWTH_DIR="/home/container/projects/auto-growth"
ANALYSIS_SCRIPT="$GROWTH_DIR/scripts/analyze_pi_packages.sh"
LOG_FILE="$GROWTH_DIR/logs/daily_analysis.log"

echo "════════════════════════════════════════════════════════════"
echo "        📦 Pi.dev 每日包分析 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "════════════════════════════════════════════════════════════"
echo ""

# 執行分析
if [ -x "$ANALYSIS_SCRIPT" ]; then
    "$ANALYSIS_SCRIPT" 2>&1 | tee -a "$LOG_FILE"
    
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "✅ 每日分析完成"
    echo "════════════════════════════════════════════════════════════"
else
    echo "❌ 分析腳本不存在或不可執行: $ANALYSIS_SCRIPT"
    exit 1
fi
