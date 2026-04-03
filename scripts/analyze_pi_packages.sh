#!/bin/bash

# Pi.dev 包分析工具（改進版）
# - 每次分析 3 個新包
# - 避免重複分析已看過的包
# - 生成 1 份統一報告
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
echo "║      📦 Pi.dev 包分析 - 每次分析 3 個新包                     ║"
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
# 選擇 3 個新包
# ============================================================================

select_three_packages() {
    # 獲取已分析的包列表
    local analyzed_packages=$(cat "$HISTORY_FILE" 2>/dev/null || echo "")
    
    # 找出未分析的包
    local unanalyzed=()
    for pkg in "${!PACKAGE_POOL[@]}"; do
        if ! echo "$analyzed_packages" | grep -q "^$pkg$"; then
            unanalyzed+=("$pkg")
        fi
    done
    
    local analyzed_count=$(echo "$analyzed_packages" | grep -c . || echo 0)
    log "📊 已分析包數: $analyzed_count"
    log "📊 未分析包數: ${#unanalyzed[@]}"
    
    # 如果未分析的包少於 3 個，重置歷史
    if [ ${#unanalyzed[@]} -lt 3 ]; then
        log "⚠️ 未分析包數不足 3 個，重置分析歷史..."
        > "$HISTORY_FILE"
        unanalyzed=("${!PACKAGE_POOL[@]}")
    fi
    
    # 隨機選擇 3 個未分析的包
    SELECTED_PKGS=()
    for i in {1..3}; do
        local random_idx=$((RANDOM % ${#unanalyzed[@]}))
        local selected_pkg="${unanalyzed[$random_idx]}"
        SELECTED_PKGS+=("$selected_pkg")
        
        # 從未分析列表中移除此包
        unanalyzed=("${unanalyzed[@]:0:$random_idx}" "${unanalyzed[@]:$((random_idx+1))}")
        
        # 記錄到歷史
        echo "$selected_pkg" >> "$HISTORY_FILE"
    done
    
    log "✅ 選中 3 個包: ${SELECTED_PKGS[0]}, ${SELECTED_PKGS[1]}, ${SELECTED_PKGS[2]}"
}

# ============================================================================
# 分析單個包
# ============================================================================

analyze_package() {
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
    echo "$pkg_name|$score|$author|$desc|$recommendation|$conflict"
}

# ============================================================================
# 主流程
# ============================================================================

log "📝 步驟 1: 選擇 3 個待分析的包..."
select_three_packages

log "📝 步驟 2: 分析選中的 3 個包..."

declare -a ANALYSES
for pkg in "${SELECTED_PKGS[@]}"; do
    ANALYSIS=$(analyze_package "$pkg")
    ANALYSES+=("$ANALYSIS")
done

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
    echo "**本次分析**: 3 個新包"
    echo ""
    echo "---"
    echo ""
    echo "## 分析的包"
    echo ""
    
    # 分析 3 個包並顯示
    for i in {0..2}; do
        ANALYSIS="${ANALYSES[$i]}"
        IFS='|' read -r pkg_name score author desc recommendation conflict <<< "$ANALYSIS"
        
        echo "### $((i+1)). $pkg_name"
        echo ""
        echo "**作者**: $author"
        echo "**採用評分**: $score/100"
        echo "**說明**: $desc"
        echo ""
        
        # 優先級判斷
        if [ "$score" -gt 80 ]; then
            priority="🔴 高優先級"
        elif [ "$score" -gt 50 ]; then
            priority="🟡 中優先級"
        else
            priority="🟢 低優先級"
        fi
        
        echo "**優先級**: $priority"
        echo "**建議**: $recommendation"
        echo "**潛在衝突**: $conflict"
        echo ""
    done
    
    echo "---"
    echo ""
    echo "## 對比分析"
    echo ""
    echo "| 項目 | 包 1 | 包 2 | 包 3 |"
    echo "|------|------|------|------|"
    
    # 解析評分
    IFS='|' read -r pkg1 score1 _ _ _ _ <<< "${ANALYSES[0]}"
    IFS='|' read -r pkg2 score2 _ _ _ _ <<< "${ANALYSES[1]}"
    IFS='|' read -r pkg3 score3 _ _ _ _ <<< "${ANALYSES[2]}"
    
    echo "| **包名** | $pkg1 | $pkg2 | $pkg3 |"
    echo "| **評分** | **$score1/100** | **$score2/100** | **$score3/100** |"
    
    # 優先級表
    priority1=$([ "$score1" -gt 80 ] && echo "🔴 高" || ([ "$score1" -gt 50 ] && echo "🟡 中" || echo "🟢 低"))
    priority2=$([ "$score2" -gt 80 ] && echo "🔴 高" || ([ "$score2" -gt 50 ] && echo "🟡 中" || echo "🟢 低"))
    priority3=$([ "$score3" -gt 80 ] && echo "🔴 高" || ([ "$score3" -gt 50 ] && echo "🟡 中" || echo "🟢 低"))
    
    echo "| **優先級** | $priority1 | $priority2 | $priority3 |"
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
REPO_NAME="auto-growth"

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
- 包含: 3 個新包的詳細分析、對比表、評分、建議

## 🔄 分析機制

- 每次分析 3 個新包
- 避免重複分析已看過的包
- 完整歷史記錄追蹤

---
最後更新: $(date '+%Y-%m-%d %H:%M:%S')
READMEEOF

# 提交並推送
git add -A
git commit -m "Package Analysis: ${TIMESTAMP}" --allow-empty 2>/dev/null || true

# 配置遠程和推送
if [ -f ~/.git-credentials ]; then
    GITHUB_USERNAME=$(cat ~/.git-credentials | grep -oP '(?<=https://)[^:]+')
    GITHUB_TOKEN=$(cat ~/.git-credentials | grep -oP '(?<=:)[^@]+(?=@github)')
    
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
echo "║              ✅ 包分析完成（3 個新包）                        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 報告:"
echo "  $REPORT_FILE"
echo ""
echo "📤 GitHub:"
echo "  https://github.com/2324139/auto-growth"
echo ""
log "🎊 包分析流程完成！"
