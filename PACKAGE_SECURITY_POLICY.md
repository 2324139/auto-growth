# 🔐 Pi.dev 包安全檢查政策

## 核心原則

✅ **只檢查 Pi.dev/packages 官方包**  
❌ **不檢查或安裝第三方工具包**

---

## 為什麼要限制為官方包？

### 1. 安全性保障
- 官方包經過 Pi 團隊審核
- 符合 Pi Agent 架構標準
- 集成度高，兼容性強

### 2. 質量控制
- 官方維護，持續更新
- 文檔完整，示例清晰
- Bug 修復及時

### 3. 系統一致性
- 遵循 Pi Agent 設計規範
- 統一的代碼風格和接口
- 易於集成和維護

---

## 官方包驗證機制

### 身份驗證
```bash
GitHub 用戶必須為：
  • 2324139 (主官方賬戶)
  • pi-dev (官方開發賬戶)
  • 其他認可的官方賬戶

示例：
  ✅ github.com/2324139/pi-web-search
  ✅ github.com/pi-dev/pi-cache-layer
  ❌ github.com/awesome-python/awesome-python
  ❌ github.com/awesome-go/awesome-go
```

### 8 項安全檢查
```
1. ✓ 倉庫存在性驗證
2. ✓ Pi.dev 官方身份驗證 ← 核心檢查
3. ✓ 活躍度檢查
4. ✓ 社區認可度
5. ✓ 許可證驗證
6. ✓ 文檔完整性
7. ✓ 開放問題審查
8. ✓ 安全性驗證
```

---

## 包來源流程

### 階段 1：發現新包
```
來源：Pi.dev/packages 官方包列表
工具：discover_new_packages.sh
輸出：新包候選列表
```

### 階段 2：評估分析
```
工具：analyze_pi_packages.sh
評分：0-100 (基於功能性、集成度等)
篩選：評分 ≥ 75/100 的包
```

### 階段 3：安全檢查
```
工具：package_security_check.sh
驗證：官方身份 + 8 項安全檢查
結果：通過 → 自動安裝 | 失敗 → 標記待評
```

### 階段 4：安裝和集成
```
安裝位置：/home/container/projects/auto-growth/installed-packages/
集成方式：符合 Pi Agent 標準
```

---

## 官方推薦包池

當前評估的 Pi.dev 官方包（評分 ≥ 75/100）：

| 包名 | 評分 | 狀態 | 功能 |
|------|------|------|------|
| web-search-advanced | 95/100 | 推薦 | 多引擎搜尋 |
| cache-layer | 85/100 | 推薦 | 緩存優化層 |
| data-pipeline-processor | 80/100 | 推薦 | 數據處理管道 |
| document-generator | 75/100 | 推薦 | 文檔自動生成 |
| git-automation | 75/100 | 推薦 | Git 自動化工具 |

---

## 非官方包處理

### 為什麼不安裝第三方包？

```
第三方包問題：
❌ 無法保證與 Pi Agent 兼容
❌ 代碼風格可能不一致
❌ 安全審核標準不同
❌ 依賴關係不明確
❌ 長期維護風險
```

### 替代方案

如果需要第三方工具：
```bash
# 方案 1：手動評估和安裝
cd /home/container/projects
git clone <third-party-repo>

# 方案 2：構建 Pi 官方包包裝
# 向 Pi 團隊提交功能請求
# 等待官方包發佈

# 方案 3：本地集成
# 在項目中直接集成所需功能
```

---

## 安全檢查工作流

```
Pi.dev/packages
  ↓
identify candidates
(評分 ≥ 75/100)
  ↓
security check
(8 項驗證 + 官方身份)
  ↓
通過 ✅          失敗 ❌
  ↓                ↓
auto install    標記待評
  ↓                ↓
集成             人工審核
  ↓
報告生成
  ↓
GitHub 推送
```

---

## 使用示例

### 檢查官方包
```bash
cd /home/container/projects/auto-growth
./scripts/package_security_check.sh

輸出：
  🔍 檢查 Pi.dev 包: web-search-advanced (95/100)
     1️⃣ 驗證倉庫存在... ✓ 通過
     2️⃣ 驗證 Pi.dev 官方身份... ✓ 官方包
     3️⃣ 檢查活躍度... ✓ 通過
     ...
     ✅ 通過檢查 → 自動安裝
```

### 檢查非官方包（被拒絕）
```bash
系統會檢查 GitHub 用戶：
  ✗ github.com/awesome-python
  → 不是 2324139 或 pi-dev
  → ❌ 安全檢查失敗
  → 跳過安裝
```

---

## 官方包標準

Pi.dev 官方包必須滿足：

### 1. 架構標準
- [ ] 符合 Pi Agent 設計規範
- [ ] 實現必要的 API 接口
- [ ] 遵循命名約定

### 2. 文檔要求
- [ ] 完整的 README.md
- [ ] 使用示例
- [ ] API 文檔
- [ ] 故障排除指南

### 3. 代碼質量
- [ ] 代碼審查通過
- [ ] 單元測試覆蓋
- [ ] 類型檢查通過
- [ ] 無安全漏洞

### 4. 維護承諾
- [ ] 定期更新
- [ ] Issue 響應及時
- [ ] Pull Request 審查
- [ ] 向後兼容性

---

## 常見問題

### Q: 為什麼不能安裝我喜歡的第三方包？
A: 為了確保系統穩定性和安全性，我們只安裝經過官方審核的 Pi.dev 包。第三方包可能存在兼容性或安全問題。

### Q: 如何將第三方工具添加為官方包？
A: 向 Pi 團隊提交功能請求，包含：
   - 功能描述
   - 使用場景
   - 集成方案
   - 安全性分析

### Q: 官方包發佈後多久可以使用？
A: 通常需要經過：
   - 代碼審查 (1-2 週)
   - 安全審計 (1-2 週)
   - 文檔完善 (1 週)
   - 發佈測試 (3-5 天)
   
   總計：3-5 週

### Q: 已安裝的官方包如何更新？
A: 系統會自動檢查更新：
   ```bash
   cd /home/container/projects/auto-growth/installed-packages/<package>
   git pull origin main
   ```

---

## 相關文件

- [README.md](README.md) - 項目總體說明
- [PACKAGE_DISCOVERY_WORKFLOW.md](PACKAGE_DISCOVERY_WORKFLOW.md) - 包發現流程
- [QUICK_START.md](QUICK_START.md) - 快速參考

---

## 更新日誌

### 2026-04-03
- ✅ 建立 Pi.dev 官方包安全檢查政策
- ✅ 實現 8 項安全驗證機制
- ✅ 設置官方身份驗證 (GitHub 用戶白名單)
- ✅ 移除非官方第三方包

