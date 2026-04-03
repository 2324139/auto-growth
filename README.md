# 📦 Pi Agent Auto-Growth 系統

自主成長系統 - 智能 Pi.dev 包分析和評估。

## 🎯 核心功能

### Pi.dev 每日包分析（優化版）

每天自動分析 Pi.dev/packages 中的**一個新包**：

✨ **智能去重**
- 追蹤已分析的包，避免重複
- 優先分析新包
- 完整的分析歷史記錄

📊 **完整評估**
- 採用評分（0-100）
- 功能衝突檢查
- 清晰的採用建議（✅推薦/⚠️可選/❌暫不）

📄 **統一報告**
- 每次運行生成 **1 份報告**
- 文件名格式：`yyyymmddHHmm.md`
- 自動推送 GitHub

## 📋 快速開始

### 單次運行

```bash
cd /home/container/projects/auto-growth
./scripts/analyze_pi_packages.sh
```

### 每日運行

```bash
./scripts/run_daily_analysis.sh
```

## 📂 項目結構

```
auto-growth/
├── scripts/
│   ├── analyze_pi_packages.sh      # 核心分析引擎
│   └── run_daily_analysis.sh       # 每日運行器
├── reports/
│   └── yyyymmddHHmm.md             # 分析報告
├── logs/
│   └── package_analysis.log        # 分析日誌
├── docs/
│   ├── PROGRESS.md
│   └── ARCHITECTURE.md
└── .package_analysis_history       # 已分析包記錄
```

## 🔄 工作流程

1. **選擇包**
   - 掃描已分析的包
   - 從未分析的包中隨機選擇
   
2. **分析包**
   - 評估應用場景
   - 檢查與現有功能衝突
   - 生成採用評分

3. **生成報告**
   - 統一的 Markdown 格式
   - 清晰的結論和建議

4. **推送 GitHub**
   - 自動提交和推送
   - 完整的歷史記錄

## 📊 評分標準

| 評分範圍 | 優先級 | 建議 |
|----------|--------|------|
| > 80 | 🔴 高 | ✅ 推薦採用 |
| 50-80 | 🟡 中 | ⚠️ 可選採用 |
| < 50 | 🟢 低 | ❌ 暫不採用 |

## 🌐 GitHub 備份

所有報告自動推送至：
https://github.com/2324139/auto-growth-logs

## 📚 查看報告

### 本地查看
```bash
ls -lh reports/
cat reports/202604031953.md
```

### GitHub 查看
```
https://github.com/2324139/auto-growth-logs/tree/main/reports
```

## ✨ 特色

✅ **智能去重** - 不重複分析已看過的包  
✅ **高效分析** - 每天只分析 1 個包  
✅ **統一報告** - 每次運行生成 1 份  
✅ **完整歷史** - 所有分析都有記錄  
✅ **自動推送** - 實時備份至 GitHub  
✅ **易於擴展** - 包池可隨時添加新包  

## 🔧 自定義配置

### 添加新包

編輯 `scripts/analyze_pi_packages.sh`，在 `PACKAGE_POOL` 中添加：

```bash
["package-name"]="score|author|description"
```

### 重置分析歷史

```bash
rm /home/container/projects/auto-growth/.package_analysis_history
```

這會重新開始分析所有包。

## 📝 文件格式說明

### 報告文件名

`yyyymmddHHmm.md`

- `yyyy` - 年份（4 位）
- `mm` - 月份（2 位）
- `dd` - 日期（2 位）
- `HH` - 小時（24 小時制）
- `mm` - 分鐘（2 位）

例：`202604031953.md` 表示 2026 年 4 月 3 日 19:53 的分析報告

### 報告內容

```markdown
# 📦 Pi.dev 包分析報告

**日期**: 2026-04-03 19:53:18
**格式**: yyyymmddHHmm (202604031953)

## 分析的包

### [包名]

**作者**: [作者]
**採用評分**: [評分]/100
**說明**: [功能描述]

## 應用性分析

**評分**: [評分]/100
**優先級**: [優先級]
**建議**: [建議]
**潛在衝突**: [衝突分析]

## 系統狀態

- 已分析包數: [數量]
- 包池大小: [總數]
- 分析時間: [時間戳]
```

## 🚀 定時執行

### 使用 Cron（Linux/Mac）

```bash
# 每天 8:00 AM 執行
0 8 * * * cd /home/container/projects/auto-growth && ./scripts/run_daily_analysis.sh
```

### 使用系統啟動

在 `startup.sh` 中添加：
```bash
/home/container/projects/auto-growth/scripts/run_daily_analysis.sh
```

## 📞 支持

有任何問題或建議，請查看：
- 項目日誌：`logs/package_analysis.log`
- 分析歷史：`.package_analysis_history`
- 生成的報告：`reports/`

---

**最後更新**: 2026-04-03
