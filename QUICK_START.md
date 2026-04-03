# 🚀 快速開始指南

## 單行命令

### 執行包分析
```bash
cd /home/container/projects/auto-growth && ./scripts/analyze_pi_packages.sh
```

### 查看最新報告
```bash
cat /home/container/projects/auto-growth/reports/$(ls -t /home/container/projects/auto-growth/reports/*.md 2>/dev/null | head -1 | xargs basename)
```

### 查看分析歷史
```bash
cat /home/container/projects/auto-growth/.package_analysis_history
```

### 查看系統日誌
```bash
tail -f /home/container/projects/auto-growth/logs/package_analysis.log
```

---

## 常見任務

### 查看所有報告
```bash
ls -lh /home/container/projects/auto-growth/reports/
```

### 查看特定報告
```bash
cat /home/container/projects/auto-growth/reports/202604031953.md
```

### 重置分析歷史（重新開始分析所有包）
```bash
rm /home/container/projects/auto-growth/.package_analysis_history
```

### 查看項目文檔
```bash
cat /home/container/projects/auto-growth/README.md
cat /home/container/projects/auto-growth/docs/ARCHITECTURE.md
```

---

## GitHub 操作

### 查看遠程倉庫
```bash
cd /home/container/projects/auto-growth
git remote -v
```

### 提交本地更改
```bash
cd /home/container/projects/auto-growth
git add .
git commit -m "Add new features or updates"
git push origin main
```

### 查看提交歷史
```bash
cd /home/container/projects/auto-growth
git log --oneline -10
```

---

## 定時執行設置

### Cron 任務（每天 8:00 AM）
```bash
# 編輯 crontab
crontab -e

# 添加以下行
0 8 * * * cd /home/container/projects/auto-growth && ./scripts/analyze_pi_packages.sh >> logs/cron.log 2>&1
```

### 系統啟動時執行
```bash
# 編輯啟動腳本
vi /home/container/.pi/startup.sh

# 添加
/home/container/projects/auto-growth/scripts/analyze_pi_packages.sh
```

---

## 包分析流程

```
1. 讀取 .package_analysis_history（已分析包記錄）
   ↓
2. 篩選未分析的包
   ↓
3. 隨機選擇一個未分析的包
   ↓
4. 分析包的適用性
   ├─ 評分計算
   ├─ 衝突檢查
   └─ 建議生成
   ↓
5. 生成 Markdown 報告（yyyymmddHHmm.md）
   ↓
6. 記錄包名到歷史
   ↓
7. 推送至 GitHub
   ↓
8. 完成
```

---

## 包池狀態

### 當前包池（10 個包）

| 包名 | 評分 | 狀態 | 報告 |
|------|------|------|------|
| web-search-advanced | 95 | ⏳ 待分析 | - |
| cache-layer | 85 | ⏳ 待分析 | - |
| security-scanner | 65 | ⏳ 待分析 | - |
| data-pipeline-processor | 80 | ✓ 已分析 | 202604031955.md |
| markdown-renderer | 70 | ✓ 已分析 | 202604031953.md |
| document-generator | 75 | ⏳ 待分析 | - |
| git-automation | 75 | ⏳ 待分析 | - |
| logging-aggregator | 60 | ⏳ 待分析 | - |
| metrics-exporter | 70 | ⏳ 待分析 | - |
| api-gateway | 40 | ⏳ 待分析 | - |

---

## 性能指標

| 指標 | 值 |
|------|-----|
| 單次分析耗時 | ~2-5 秒 |
| 報告文件大小 | ~1KB |
| GitHub 推送耗時 | ~2-3 秒 |
| 包池大小 | 10 個 |
| 完全覆蓋週期 | 10 次運行 |
| 去重記錄大小 | <100B |

---

## 技術棧

- **語言**: Bash
- **版本控制**: Git
- **遠程備份**: GitHub
- **報告格式**: Markdown
- **時間戳格式**: yyyymmddHHmm
- **認證**: Token-based

---

## 故障排查

### 推送至 GitHub 失敗
```bash
# 檢查遠程配置
git remote -v

# 檢查 Token 有效性
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# 重新配置遠程
git remote remove origin
git remote add origin https://USERNAME:TOKEN@github.com/USERNAME/auto-growth.git
git push -u origin main
```

### 包分析失敗
```bash
# 檢查腳本權限
ls -l scripts/analyze_pi_packages.sh

# 手動執行並查看錯誤
bash scripts/analyze_pi_packages.sh

# 查看日誌
cat logs/package_analysis.log
```

### 去重記錄損壞
```bash
# 重置歷史（清空已分析記錄）
rm .package_analysis_history

# 下次運行將重新分析所有包
./scripts/analyze_pi_packages.sh
```

---

## 文檔導航

- **README.md** - 項目總體說明
- **ARCHITECTURE.md** - 系統設計和架構
- **PROGRESS.md** - 項目進度和統計
- **QUICK_START.md** - 本文檔

---

最後更新: 2026-04-03
