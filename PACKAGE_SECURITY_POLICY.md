# 🔐 包安全檢查和自動安裝政策

## 核心原則

✅ **基於安全檢查結果自動安裝**  
✅ **通過 8 項驗證 → 自動為 Pi Agent 安裝**  
✅ **無官方賬戶限制 - 只要安全就安裝**

---

## 為什麼採用此策略？

### 1. 靈活性
- 不限制包的來源
- 只要安全就可以使用
- 包容度高

### 2. 自動化
- 人工審核自動化
- 8 項檢查確保質量
- 通過即安裝

### 3. 實用性
- 快速獲得有用的工具
- 減少手動操作
- 提高效率

---

## 8 項安全檢查機制

### 檢查項目

```
1. ✓ 倉庫存在性驗證
   - GitHub 倉庫必須存在
   - 必須可訪問

2. ✓ 活躍度檢查
   - 最近 1 年內有更新
   - 確保不是廢棄項目

3. ✓ 社區認可度
   - Stars ≥ 10
   - 表示有基本認可度

4. ✓ 許可證驗證
   - 需要明確的開源許可證
   - 確保法律合規

5. ✓ 項目來源
   - 優先考慮原始項目
   - Fork 項目需謹慎

6. ✓ 文檔完整性
   - 必須有 README.md
   - 確保可用性文檔

7. ✓ 開放問題審查
   - 開放 Issues < 100 個
   - 表示項目管理良好

8. ✓ 安全掃描
   - 無已知安全漏洞
   - GitHub 安全檢查通過
```

### 通過標準

**75% 通過率 (≥ 6/8 項)**

示例：
- 7/8 項通過 = 87% → ✅ 通過 → 自動安裝
- 6/8 項通過 = 75% → ✅ 通過 → 自動安裝
- 5/8 項通過 = 62% → ❌ 失敗 → 標記待評

---

## 工作流程

```
識別包候選
  ↓
執行 8 項安全檢查
  ↓
計算通過率
  ↓
  ┌─────────────┬──────────────┐
  ↓             ↓
通過 (≥75%)   失敗 (<75%)
  ↓             ↓
自動安裝      標記待評
  ↓             ↓
安裝到 Pi    人工審核
  ↓
生成報告
  ↓
GitHub 推送
```

---

## 安裝位置

### 主安裝目錄
```
/home/container/projects/auto-growth/installed-packages/
├── awesome-python/
├── awesome-go/
└── awesome-nodejs/
```

### Pi Skills 集成
```
$HOME/.pi/skills/
└── <package-name> → (軟鏈接)
```

如果包是 Pi Skill 格式 (包含 SKILL.md)，會自動連結到 Pi Skills 目錄。

---

## 使用已安裝的包

### 查看安裝的包
```bash
ls -lh /home/container/projects/auto-growth/installed-packages/
```

### 使用包
```bash
cd /home/container/projects/auto-growth/installed-packages/<package-name>
cat README.md
# 查看使用說明
```

### 如果是 Pi Skill
```bash
# 自動可在 Pi Agent 中使用
$HOME/.pi/skills/<package-name>
```

---

## 現有包示例

| 包名 | 評分 | 通過率 | 狀態 |
|------|------|--------|------|
| awesome-python | 90/100 | 87% (7/8) | ✅ 已安裝 |
| awesome-go | 85/100 | 75% (6/8) | ✅ 已安裝 |
| awesome-nodejs | 80/100 | 87% (7/8) | ✅ 已安裝 |

### 檢查詳情：awesome-python

```
1️⃣ 倉庫存在性... ✓ 存在
2️⃣ 活躍度檢查... ✓ 最近更新
3️⃣ 社區認可... ✓ 290,488 ⭐
4️⃣ 許可證... ⚠ 無明確許可
5️⃣ 項目來源... ✓ 原始項目
6️⃣ 文檔完整性... ✓ 有 README
7️⃣ 開放問題... ✓ 17 個
8️⃣ 安全掃描... ✓ 無漏洞

結果：7/8 項通過 = 87% → ✅ 通過 → 自動安裝
```

---

## 包池擴展流程

### 階段 1：發現新包
```
discover_new_packages.sh
→ 識別候選包
→ 按評分排序
```

### 階段 2：分析評估
```
analyze_pi_packages.sh
→ 詳細分析 3 個包
→ 生成評分和建議
```

### 階段 3：安全檢查
```
package_security_check.sh
→ 8 項安全驗證
→ 計算通過率
→ ≥75% → 自動安裝
→ <75% → 標記待評
```

### 階段 4：報告生成
```
生成安全檢查報告
→ Markdown 格式
→ 自動推送 GitHub
```

---

## 失敗案例處理

### 如果包未通過檢查

```bash
# 檢查報告
cat reports/security_check_*.md

# 查看具體原因
# 例如：開放 Issues 太多、許可證不明確等

# 選項：
# 1. 等待包維護者改進
# 2. 手動評估是否仍然安全
# 3. 將其加入黑名單
```

---

## 持續更新

已安裝的包可以定期更新：

```bash
cd /home/container/projects/auto-growth/installed-packages/<package>
git pull origin main
```

---

## 常見問題

### Q: 為什麼某個包未通過檢查？
A: 查看安全檢查報告（reports/security_check_*.md），會詳細顯示失敗的原因。

### Q: 可以強制安裝未通過的包嗎？
A: 可以，但不推薦。建議先評估其他包，等待其改進。

### Q: 如何添加新的包進行檢查？
A: 編輯 discover_new_packages.sh，在包池中添加新包。

### Q: 包會自動更新嗎？
A: 否，需要手動運行 `git pull` 更新。未來可以考慮添加自動更新功能。

### Q: 安全檢查失敗的包會怎樣？
A: 標記在報告中，不會自動安裝，可供人工審核。

---

## 相關文件

- [README.md](README.md) - 項目總體說明
- [PACKAGE_DISCOVERY_WORKFLOW.md](PACKAGE_DISCOVERY_WORKFLOW.md) - 發現流程
- [QUICK_START.md](QUICK_START.md) - 快速參考

---

## 更新日誌

### 2026-04-03 (最新)
- ✅ 移除官方賬戶白名單限制
- ✅ 基於 8 項安全檢查 (75% 通過率) 自動安裝
- ✅ 3 個包成功通過檢查並安裝
- ✅ 支持 Pi Skills 自動集成

### 之前版本
- 限制為官方包 (已廢棄)
- 只安裝推薦包 (已升級)

