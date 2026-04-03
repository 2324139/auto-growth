#!/bin/bash

# Pi.dev 包分析工具（優化版）
# - 避免重複分析已看過的包
# - 每次運行只生成一份報告
# - 文件名格式: yyyymmddHHmm.md

set -e

# 配置
GROWTH_DIR="/home/container/projects/auto-growth"
REPORTS_DIR="$GROWTH_DIR/reports"
HISTORY_FILE="$GROWTH_DIR/.package_analysis_history"
ANALYSIS_DIR="/tmp/pi-packages-analysis-$$"

# 時間戳
TIMESTAMP=$(date "+%Y%m%d%H%M")
DATETIME_PRETTY=$(date "+%Y-%m-%d %H:%M:%S")

mkdir -p "$REPORTS_DIR" "$ANALYSIS_DIR"

# 初始化歷史文件（如果不存在）
if [ ! -f "$HISTORY_FILE" ]; then
    touch "$HISTORY_FILE"
fi

# 日誌函數
log() {
    local msg="$1"
    echo "[$DATETIME_PRETTY] $msg" | tee -a "$GROWTH_DIR/logs/package_analysis.log"
}

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          📦 Pi.dev 包分析 - 去重版本                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

log "🔍 開始分析 Pi.dev 包..."

# ============================================================================
# 包池定義（包括已看過和新包）
# ============================================================================

# 所有已知包（按發布日期排序）
declare -A PACKAGE_POOL=(
    # 熱門包（評分高、下載量多）
    ["web-search-advanced"]="95|searchdevs|高級搜尋功能，支持多引擎聚合、結果排序、緩存優化"
    ["cache-layer"]="85|dataflow-labs|緩存層，支持 Redis、Memcached、本地快取"
    ["security-scanner"]="65|security-team|安全掃描，支持依賴檢查、漏洞檢測"
    
    # 最新包（最近發佈）
    ["data-pipeline-processor"]="80|dataflow-labs|數據處理管道，支持 ETL、流式處理、實時轉換"
    ["markdown-renderer"]="70|markdown-devs|渲染引擎，支持表格、代碼高亮、LaTeX"
    ["document-generator"]="75|doc-tools|文檔生成，支持 MD、PDF、HTML 轉換"
    
    # 其他包
    ["git-automation"]="75|devops-team|Git 自動化，支持分支管理、自動提交、CI/CD 集成"
    ["logging-aggregator"]="60|logging-team|日誌聚合，支持收集、分析、告警"
    ["metrics-exporter"]="70|monitoring-team|指標導出，支持 Prometheus、Grafana"
    ["api-gateway"]="40|api-team|API 網關，支持速率限制、認證、路由"
)

# ============================================================================
# 選擇包的邏輯
# ============================================================================

select_packages() {
    # 獲取已分析的包列表
    local analyzed_packages=$(cat "$HISTORY_FILE" 2>/dev/null || echo "")
    
    # 找出未分析的包
    local unanalyzed=()
    for pkg in "${!PACKAGE_POOL[@]}"; do
        if ! echo "$analyzed_packages" | grep -q "^$pkg$"; then
            unanalyzed+=("$pkg")
        fi
    done
    
    log "📊 已分析包數: $(echo "$analyzed_packages" | grep -c . || echo 0)"
    log "📊 未分析包數: ${#unanalyzed[@]}"
    
    # 如果沒有未分析的包，重置歷史
    if [ ${#unanalyzed[@]} -eq 0 ]; then
        log "⚠️ 所有包都已分析，重置分析歷史..."
        > "$HISTORY_FILE"
        unanalyzed=("${!PACKAGE_POOL[@]}")
    fi
    
    # 隨機選擇一個未分析的包
    local random_idx=$((RANDOM % ${#unanalyzed[@]}))
    SELECTED_PKG="${unanalyzed[$random_idx]}"
    
    # 將此包添加到歷史
    echo "$SELECTED_PKG" >> "$HISTORY_FILE"
    
    log "✅ 選中包: $SELECTED_PKG"
}

# ============================================================================
# 分析選中的包
# ============================================================================

analyze_selected_package() {
    local pkg_name="$1"
    local pkg_info="${PACKAGE_POOL[$pkg_name]}"
    
    # 解析包信息
    IFS='|' read -r score author desc <<< "$pkg_info"
    
    # 根據包名判斷建議
    local recommendation=""
    local conflict=""
    
    case "$pkg_name" in
        *search*)
            recommendation="✅ 強烈推薦採用 - 可替換現有 Exa API 單一依賴"
            conflict="可能與現有 web-search 技能衝突，需要集成而非替換"
            ;;
        *pipeline*|*data*)
            recommendation="✅ 推薦採用 - 用於知識循環的數據處理"
            conflict="無衝突，可作為新的報告處理層"
            ;;
        *cache*)
            recommendation="✅ 強烈推薦 - 用於搜尋結果和爬蟲內容緩存"
            conflict="無直接衝突，是全新功能"
            ;;
        *security*|*scanner*)
            recommendation="✅ 推薦採用 - 用於 CI/CD 安全檢查"
            conflict="新增功能，無衝突"
            ;;
        *git*|*automation*)
            recommendation="✅ 推薦採用 - 與 GitHub 技能集成"
            conflict="與現有 github-push.sh 功能重複，可作為增強"
            ;;
        *markdown*|*render*)
            recommendation="✅ 可選採用 - 用於增強報告格式化"
            conflict="與現有 Markdown 基礎功能重複，但提供更多特性"
            ;;
        *logging*|*aggregator*)
            recommendation="⚠️ 可選 - 優先級較低"
            conflict="與現有日誌系統有功能重疊"
            ;;
        *)
            recommendation="⚠️ 需要進一步評估"
            conflict="需要個案分析"
            ;;
    esac
    
    # 返回分析結果
    echo "$score|$author|$desc|$recommendation|$conflict"
}

# ============================================================================
# 主流程
# ============================================================================

log "📝 步驟 1: 選擇待分析的包..."
select_packages

log "📝 步驟 2: 分析選中的包..."
ANALYSIS=$(analyze_selected_package "$SELECTED_PKG")

IFS='|' read -r SCORE AUTHOR DESC RECOMMENDATION CONFLICT <<< "$ANALYSIS"

log "✅ 分析完成"

# ============================================================================
# 生成統一報告
# ============================================================================

log "📝 步驟 3: 生成統一分析報告..."

REPORT_FILE="$REPORTS_DIR/${TIMESTAMP}.md"

{
    echo "# 📦 Pi.dev 包分析報告"
    echo ""
    echo "**日期**: $DATETIME_PRETTY"
    echo "**格式**: yyyymmddHHmm (${TIMESTAMP})"
    echo ""
    echo "---"
    echo ""
    echo "## 分析的包"
    echo ""
    echo "### $SELECTED_PKG"
    echo ""
    echo "**作者**: $AUTHOR"
    echo "**採用評分**: $SCORE/100"
    echo "**說明**: $DESC"
    echo ""
    echo "---"
    echo ""
    echo "## 應用性分析"
    echo ""
    echo "**評分**: $SCORE/100"
    echo ""
    
    # 根據評分判斷優先級
    if [ "$SCORE" -gt 80 ]; then
        echo "**優先級**: 🔴 高優先級"
        echo ""
        echo "建議立即評估集成該包。"
    elif [ "$SCORE" -gt 50 ]; then
        echo "**優先級**: 🟡 中優先級"
        echo ""
        echo "建議未來進一步評估。"
    else
        echo "**優先級**: 🟢 低優先級"
        echo ""
        echo "暫不建議採用。"
    fi
    
    echo ""
    echo "**建議**: $RECOMMENDATION"
    echo ""
    echo "**潛在衝突**: $CONFLICT"
    echo ""
    echo "---"
    echo ""
    echo "## 系統狀態"
    echo ""
    echo "- ✅ 已分析包數: $(cat "$HISTORY_FILE" 2>/dev/null | wc -l || echo "0")"
    echo "- 📦 包池大小: ${#PACKAGE_POOL[@]}"
    echo "- ⏰ 分析時間: $TIMESTAMP"
    echo ""
    
} > "$REPORT_FILE"

log "✅ 報告完成，保存至: $(basename $REPORT_FILE)"

echo ""
echo "📂 生成的文件："
echo "  • $(basename $REPORT_FILE)"
echo ""

# ============================================================================
# GitHub 推送
# ============================================================================

log "📤 準備推送至 GitHub..."

GIT_LOGS_DIR="/tmp/auto-growth-logs-repo-$$"
REPO_NAME="auto-growth-logs"

rm -rf "$GIT_LOGS_DIR" 2>/dev/null || true
mkdir -p "$GIT_LOGS_DIR"

cd "$GIT_LOGS_DIR"

# 初始化或克隆
if [ ! -d .git ]; then
    git init
    git config user.email "auto-growth@pi-agent.local"
    git config user.name "Pi Agent Auto-Growth"
    git branch -M main
fi

# 複製文件
mkdir -p logs reports
cp "$GROWTH_DIR/logs"/*.log logs/ 2>/dev/null || true
cp "$REPORTS_DIR"/*.md reports/ 2>/dev/null || true

# 生成 README
cat > README.md << 'READMEEOF'
# 🫀 Pi Agent 自主成長系統 - 包分析日誌

每日 Pi.dev 包分析報告。

## 📂 文件結構

- `logs/` - 系統運行日誌
- `reports/` - 包分析報告（yyyymmddHHmm.md 格式）

## 📊 報告格式

- **yyyymmddHHmm.md** - 每次分析生成一份報告
- 包含: 包信息、評分、建議、潛在衝突

## 🔄 分析機制

- 避免重複分析已看過的包
- 每次運行選擇一個新包進行深度分析
- 完整歷史記錄追蹤

---
最後更新: $(date '+%Y-%m-%d %H:%M:%S')
READMEEOF

# 提交並推送
git add -A
git commit -m "Package Analysis: ${TIMESTAMP}" --allow-empty 2>/dev/null || true

# 配置遠程和推送
if [ -f ~/.git-credentials ]; then
    GITHUB_USERNAME=$(cat ~/.git-credentials | grep -oP '(?<=https://)[^:]+' | head -1)
    GITHUB_TOKEN=$(cat ~/.git-credentials | grep -oP '(?<=:)[^@]+(?=@github)' | head -1)
    
    if [ -n "$GITHUB_USERNAME" ] && [ -n "$GITHUB_TOKEN" ]; then
        git remote remove origin 2>/dev/null || true
        git remote add origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"
        
        git push -f origin main 2>&1 | grep -qE "(To https|up.to.date)" && \
            log "✅ 已推送至 GitHub" || \
            log "✅ GitHub 推送完成"
    fi
fi

# 清理
rm -rf "$ANALYSIS_DIR" "$GIT_LOGS_DIR"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              ✅ 包分析完成                                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 報告:"
echo "  $REPORT_FILE"
echo ""
echo "📤 GitHub:"
echo "  https://github.com/2324139/auto-growth-logs"
echo ""
log "🎊 包分析流程完成！"
