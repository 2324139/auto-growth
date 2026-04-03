# 🔐 Pi.dev/packages 包安全檢查政策

## 核心原則

✅ **包來源**：必須從 **pi.dev/packages** 官方列表找到  
✅ **GitHub 賬戶**：無限制，任何賬戶都可以  
✅ **安全驗證**：8 項檢查，75% 通過率自動安裝  

---

## 為什麼採用此策略？

### 1. 確保官方推薦
- pi.dev/packages 是官方認可的包列表
- 只安裝官方推薦的包
- 保證包與 Pi Agent 相關

### 2. 靈活包來源
- 不限制 GitHub 賬戶
- 官方推薦包可以來自任何開發者
- 鼓勵社區貢獻

### 3. 自動化決策
- 8 項安全檢查確保質量
- 無需人工審核
- 通過即自動安裝

---

## 來源驗證流程

```
包候選
  ↓
檢查是否在 pi.dev/packages 中
  ↓
  ✅ 在列表中         ❌ 不在列表中
   ↓                  ↓
進行 8 項檢查        拒絕
   ↓
  ≥75% → 安裝
  <75% → 待評
```

---

## Pi.dev/packages 官方列表

官方列表來源：
- **URL**: https://pi.dev/packages (或相關 API)
- **格式**: JSON/YAML 包列表
- **更新**: 定期維護

例子：
```
- web-search-advanced
- cache-layer
- markdown-renderer
- ... (更多官方包)
```

---

## 8 項安全檢查機制

### 檢查項目

```
1. ✓ 倉庫存在性驗證
   - GitHub 倉庫必須存在
   - 必須可訪問

2. ✓ 活躍度檢查
   - 最近 1 年內有更新
   - 確保非廢棄項目

3. ✓ 社區認可度
   - Stars ≥ 10
   - 表示有基本認可度

4. ✓ 許可證驗證
   - 需要開源許可證
   - 確保法律合規

5. ✓ 項目來源
   - 優先考慮原始項目
   - Fork 項目需謹慎

6. ✓ 文檔完整性
   - 必須有 README.md
   - 確保可用性

7. ✓ 開放問題審查
   - 開放 Issues < 100 個
   - 表示項目維護良好

8. ✓ 安全掃描
   - 無已知安全漏洞
   - GitHub 安全檢查通過
```

### 通過標準

**75% 通過率 (≥ 6/8 項) → ✅ 自動安裝**

示例：
- 7/8 項通過 = 87% → ✅ 通過 → 自動安裝
- 6/8 項通過 = 75% → ✅ 通過 → 自動安裝
- 5/8 項通過 = 62% → ❌ 失敗 → 標記待評

---

## 工作流程

```
pi.dev/packages
  ↓
識別包候選
  ↓
驗證是否在官方列表中
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
├── web-search-advanced/
├── cache-layer/
└── markdown-renderer/
```

### 使用已安裝的包
```bash
cd /home/container/projects/auto-growth/installed-packages/<package-name>
cat README.md
# 查看使用說明
```

---

## 現有包示例

| 包名 | 來源 | GitHub | 通過率 | 狀態 |
|------|------|--------|--------|------|
| awesome-python | pi.dev/packages | vinta/awesome-python | 87% | ✅ 已裝 |
| awesome-go | pi.dev/packages | avelino/awesome-go | 75% | ✅ 已裝 |
| awesome-nodejs | pi.dev/packages | sindresorhus/awesome-nodejs | 87% | ✅ 已裝 |

**說明**：
- 所有包都來自 pi.dev/packages 官方列表
- GitHub 賬戶各不相同（vinta, avelino, sindresorhus...）
- 都通過了 8 項安全檢查

---

## 包池擴展流程

### 階段 1：發現新包
```
discover_new_packages.sh
→ 從 pi.dev/packages 識別新包
→ 對比現有包 (避免重複)
→ 按評分排序
```

### 階段 2：分析評估
```
analyze_pi_packages.sh
→ 詳細分析 3 個新包
→ 生成評分和建議
```

### 階段 3：來源驗證 ⭐
```
package_security_check.sh
→ 確認包在 pi.dev/packages 中
→ 8 項安全驗證
→ 計算通過率
→ ≥75% → 自動安裝
```

### 階段 4：報告生成
```
生成安全檢查報告
→ Markdown 格式
→ 自動推送 GitHub
```

---

## 常見問題

### Q: 如何確認包在 pi.dev/packages 中？
A: 
1. 訪問 https://pi.dev/packages
2. 查看官方包列表
3. 或使用 API 查詢

### Q: GitHub 賬戶有限制嗎？
A: 沒有。只要包在 pi.dev/packages 中，任何 GitHub 賬戶都可以。

### Q: 為什麼使用 75% 通過率？
A: 8 項檢查中通過 6 項以上（75%）表示包足夠安全。

### Q: 未通過檢查的包怎樣？
A: 標記在報告中，不會自動安裝。可供人工評估。

### Q: 如何手動添加新包進行檢查？
A: 
1. 確認包在 pi.dev/packages 中
2. 編輯 discover_new_packages.sh，添加到包池
3. 運行 package_security_check.sh

---

## 相關文件

- [README.md](README.md) - 項目總體說明
- [QUICK_START.md](QUICK_START.md) - 快速參考
- [PACKAGE_DISCOVERY_WORKFLOW.md](PACKAGE_DISCOVERY_WORKFLOW.md) - 發現流程

---

## 更新日誌

### 2026-04-03 (最新)
- ✅ 來源限制為 pi.dev/packages 官方列表
- ✅ GitHub 賬戶無限制（任何開發者都可以）
- ✅ 8 項安全檢查 (75% 通過率)
- ✅ 自動為 Pi Agent 安裝

### 之前版本
- 限制為官方账户 (已廢棄)
- 支持任何安全的包 (升級為官方列表要求)

