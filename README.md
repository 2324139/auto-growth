# 📦 Pi Agent Auto-Growth 系統

自主成長系統 - 智能 Pi.dev 包分析和評估。

## 🎯 核心功能

### Pi.dev 每日包分析（優化版 v2）

每次自動分析 **3 個新包**：

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
- 包含 3 個包的詳細分析 + 對比表

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

## 📊 報告示例

**第一次運行分析**:
- markdown-renderer (70/100)
- api-gateway (40/100)
- git-automation (75/100)

**第二次運行分析**:
- document-generator (75/100)
- web-search-advanced (95/100)
- data-pipeline-processor (80/100)

每個報告包含：
1. 3 個包的詳細信息
2. 採用評分和優先級
3. 對比分析表

## 📂 項目結構

```
auto-growth/
├── scripts/
│   ├── analyze_pi_packages.sh      # 核心分析引擎
│   └── run_daily_analysis.sh       # 每日運行器
├── reports/
│   ├── 202604032010.md             # 第一次分析
│   ├── 202604032012.md             # 第二次分析
│   └── ...
├── logs/
│   └── package_analysis.log
├── docs/
│   ├── PROGRESS.md
│   └── ARCHITECTURE.md
└── .package_analysis_history       # 已分析包記錄
```

## 🔄 工作流程

```
1️⃣ 選擇 3 個新包
   └─ 從未分析的包中隨機選擇
   
2️⃣ 分析每個包
   ├─ 評估應用場景
   ├─ 檢查與現有功能衝突
   ├─ 生成評分
   └─ 給出建議
   
3️⃣ 生成統一報告
   ├─ 3 個包的詳細信息
   └─ 對比分析表
   
4️⃣ 推送至 GitHub
   └─ 自動提交和推送
```

## 📈 評分標準

| 評分範圍 | 優先級 | 建議 |
|----------|--------|------|
| > 80 | 🔴 高 | ✅ 推薦採用 |
| 50-80 | 🟡 中 | ⚠️ 可選採用 |
| < 50 | 🟢 低 | ❌ 暫不採用 |

## 🌐 GitHub 備份

所有報告自動推送至：
https://github.com/2324139/auto-growth

## 📚 查看報告

### 本地查看
```bash
ls -lh reports/
cat reports/202604032010.md
```

### GitHub 查看
```
https://github.com/2324139/auto-growth/tree/main/reports
```

## ✨ 特色

✅ **每次 3 個包** - 提高分析效率  
✅ **智能去重** - 不重複分析已看過的包  
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

## 📊 包池狀態

| 包名 | 評分 | 狀態 |
|------|------|------|
| web-search-advanced | 95 | ✓ 已分析 |
| cache-layer | 85 | ⏳ 待分析 |
| security-scanner | 65 | ⏳ 待分析 |
| data-pipeline-processor | 80 | ✓ 已分析 |
| markdown-renderer | 70 | ✓ 已分析 |
| document-generator | 75 | ✓ 已分析 |
| git-automation | 75 | ✓ 已分析 |
| logging-aggregator | 60 | ⏳ 待分析 |
| metrics-exporter | 70 | ⏳ 待分析 |
| api-gateway | 40 | ✓ 已分析 |

進度: ██████░░░░ 70%

## 📞 常用命令

【執行分析】
```bash
cd /home/container/projects/auto-growth
./scripts/analyze_pi_packages.sh
```

【查看報告】
```bash
ls -lh reports/
cat reports/202604032010.md
```

【查看歷史】
```bash
cat .package_analysis_history
```

【重置歷史】
```bash
rm .package_analysis_history
```

## 💻 定時執行

### Cron（每天 8:00 AM）
```bash
0 8 * * * cd /home/container/projects/auto-growth && ./scripts/analyze_pi_packages.sh
```

### 系統啟動時執行
```bash
# 在 startup.sh 中添加
/home/container/projects/auto-growth/scripts/analyze_pi_packages.sh
```

---

**最後更新**: 2026-04-03  
**版本**: 2.0 (每次分析 3 個新包)
