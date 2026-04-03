# 🏗️ 系統架構

## 系統概述

Pi Agent Auto-Growth 系統是一個智能的 Pi.dev 包分析和評估平台。

```
┌─────────────────────────────────────────────────────────┐
│                   Pi.dev 包分析系統                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. 包池管理            2. 去重機制        3. 分析引擎  │
│  ┌──────────┐          ┌──────────┐      ┌──────────┐  │
│  │ 10 個包  │          │ 歷史文件 │      │ 評分系統 │  │
│  │  定義    │  ──>     │ .history │  ──> │ 建議生成 │  │
│  └──────────┘          └──────────┘      └──────────┘  │
│                                                │        │
│                                                v        │
│                                   4. 報告生成          │
│                                   ┌──────────────┐    │
│                                   │ Markdown 格式 │    │
│                                   │ yyyymmddHHmm  │    │
│                                   └──────────────┘    │
│                                            │          │
│                                            v          │
│                                   5. GitHub 推送     │
│                                   ┌──────────────┐    │
│                                   │ 自動備份     │    │
│                                   │ 版本控制     │    │
│                                   └──────────────┘    │
└─────────────────────────────────────────────────────────┘
```

## 模塊架構

### 1. 包池管理模塊 (Package Pool)

**文件**: `scripts/analyze_pi_packages.sh`

**功能**:
- 定義 10 個包及其元數據
- 包括：包名、評分、作者、描述
- 支持動態擴展

**包池結構**:
```bash
declare -A PACKAGE_POOL=(
    ["package-name"]="score|author|description"
    ...
)
```

### 2. 去重機制模塊 (Deduplication)

**文件**: `.package_analysis_history`

**功能**:
- 記錄已分析的包
- 避免重複分析
- 完整的分析歷史

**工作流程**:
```
讀取歷史 → 過濾已分析 → 獲取未分析列表 → 隨機選擇 → 記錄到歷史
```

### 3. 分析引擎模塊 (Analysis Engine)

**文件**: `scripts/analyze_pi_packages.sh`

**功能**:
- 評分計算
- 衝突檢查
- 建議生成

**評分邏輯**:
```
包名 → 正則匹配 → 特徵識別 → 評分分配 → 建議映射
```

### 4. 報告生成模塊 (Report Generator)

**文件**: `reports/yyyymmddHHmm.md`

**格式**:
- 時間戳精確到分鐘
- Markdown 標準格式
- 結構化內容

**報告結構**:
```markdown
# 標題
## 分析的包
### 包名
### 應用性分析
## 系統狀態
```

### 5. GitHub 集成模塊 (GitHub Integration)

**使用**: GitHub 技能 (`/home/container/.pi/skills/github/`)

**功能**:
- 自動提交
- 自動推送
- 遠程備份

**倉庫**: `https://github.com/2324139/auto-growth-logs`

## 數據流

```
┌────────────┐
│ 執行分析   │
└─────┬──────┘
      │
      v
┌────────────────┐
│ 讀取歷史文件   │ ← .package_analysis_history
└─────┬──────────┘
      │
      v
┌──────────────────┐
│ 篩選未分析的包   │
└─────┬────────────┘
      │
      v
┌──────────────────┐
│ 隨機選擇一個包   │
└─────┬────────────┘
      │
      v
┌──────────────────┐
│ 執行分析邏輯     │ ← 評分、建議、衝突
└─────┬────────────┘
      │
      v
┌──────────────────┐
│ 生成 Markdown    │ → reports/yyyymmddHHmm.md
└─────┬────────────┘
      │
      v
┌──────────────────┐
│ 記錄包到歷史     │ → .package_analysis_history
└─────┬────────────┘
      │
      v
┌──────────────────┐
│ 推送至 GitHub    │ → auto-growth-logs
└──────────────────┘
```

## 文件結構

```
auto-growth/
├── scripts/
│   ├── analyze_pi_packages.sh      # 核心分析腳本
│   │   ├── 包池定義
│   │   ├── 去重邏輯
│   │   ├── 分析函數
│   │   ├── 報告生成
│   │   └── GitHub 推送
│   └── run_daily_analysis.sh       # 運行器
│
├── reports/                        # 報告輸出
│   └── yyyymmddHHmm.md
│
├── logs/
│   └── package_analysis.log
│
├── docs/
│   ├── PROGRESS.md
│   └── ARCHITECTURE.md
│
├── .package_analysis_history       # 去重記錄
├── .gitignore
└── README.md
```

## 關鍵算法

### 包選擇算法

```bash
# 1. 讀取歷史
history = readFile(".package_analysis_history")

# 2. 篩選未分析的包
unanalyzed = []
for pkg in PACKAGE_POOL:
    if pkg not in history:
        unanalyzed.append(pkg)

# 3. 如果全部分析過，重置
if unanalyzed.length == 0:
    unanalyzed = PACKAGE_POOL
    clearFile(".package_analysis_history")

# 4. 隨機選擇
selected = unanalyzed[random(0, unanalyzed.length)]

# 5. 記錄
appendFile(".package_analysis_history", selected)
```

### 評分映射算法

```bash
case package.name:
    when contains("search"):       score = 95
    when contains("cache"):        score = 85
    when contains("pipeline"):     score = 80
    when contains("markdown"):     score = 70
    when contains("git"):          score = 75
    when contains("security"):     score = 65
    when contains("logging"):      score = 60
    when contains("gateway"):      score = 40
    else:                          score = 50
```

## 性能優化

### 1. 去重效率
- **時間複雜度**: O(n)，其中 n 是已分析包數
- **空間複雜度**: O(1)，使用單個文件存儲歷史

### 2. 報告生成
- **耗時**: < 2 秒
- **文件大小**: ~1KB
- **格式化**: 使用 Markdown heredoc

### 3. GitHub 推送
- **耗時**: < 3 秒
- **並發**: 單線程順序執行
- **容錯**: 使用 git push -f 強制推送

## 擴展點

### 1. 添加新包

```bash
["new-package"]="score|author|description"
```

### 2. 自定義評分

修改 `analyze_selected_package()` 函數中的 case 語句

### 3. 自定義報告格式

修改報告生成部分的 heredoc 內容

### 4. 多源分析

可擴展支持多個來源（npm、GitHub Marketplace 等）

## 安全考慮

1. **Git 認證**
   - 使用 `.git-credentials` 存儲 Token
   - 自動讀取憑證
   - 避免硬編碼

2. **文件權限**
   - 腳本使用 755 權限
   - 數據文件使用 644 權限

3. **去重記錄**
   - 本地保存，不上傳 GitHub
   - 用戶可隨時重置

## 監控和日誌

### 日誌位置
- `logs/package_analysis.log` - 分析日誌
- `logs/daily_analysis.log` - 運行日誌

### 日誌格式
```
[2026-04-03 19:53:18] 🔍 開始分析 Pi.dev 包...
[2026-04-03 19:53:18] ✅ 選中包: markdown-renderer
```

### 性能指標
- 分析次數
- 平均耗時
- GitHub 推送成功率

---

**最後更新**: 2026-04-03
**架構版本**: 1.0
