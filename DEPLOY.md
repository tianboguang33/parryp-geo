# ParryP GEO 站点部署指南

> 本指南将 ParryP 的 GEO 优化站点从本地部署到公网，让 AI 爬虫（GPTBot、ClaudeBot、PerplexityBot 等）能够抓取和索引。

## 方案对比

| 方案 | 费用 | HTTPS | 自定义域名 | 难度 | 推荐度 |
|------|------|-------|-----------|------|--------|
| Vercel | 免费 | ✓ | ✓（付费域名） | ⭐ 最简单 | 强烈推荐 |
| GitHub Pages | 免费 | ✓ | ✓（需域名） | ⭐⭐ | 推荐 |
| Netlify | 免费 | ✓ | ✓（需域名） | ⭐⭐ | 推荐 |
| 云服务器 | 付费 | 需配置 | ✓ | ⭐⭐⭐ | 有域名后 |

---

## 方案一：Vercel 部署（最简单，3 分钟上线）

### 步骤 1：安装 Vercel CLI

```bash
npm install -g vercel
```

### 步骤 2：更新 canonical URL

```bash
cd geo-parryp-site
./update-urls.sh https://parryp.vercel.app
# 或者用你的自定义域名:
# ./update-urls.sh https://parryp.dev
```

### 步骤 3：部署

```bash
vercel --prod
```

首次运行会要求登录（用 GitHub/Email），然后自动部署。
部署完成后获得 `https://parryp-xxx.vercel.app` 公网地址。

### 步骤 4：绑定自定义域名（可选）

```bash
vercel domains add parryp.dev
```

在域名服务商处添加 DNS 记录：
- CNAME 记录: `parryp.dev` → `cname.vercel-dns.com`

---

## 方案二：GitHub Pages 部署

### 步骤 1：创建 GitHub 仓库

```bash
cd geo-parryp-site
git init
git add -A
git commit -m "ParryP GEO site - initial deploy"
git branch -M main
git remote add origin https://github.com/你的用户名/parryp-geo.git
git push -u origin main
```

### 步骤 2：启用 GitHub Pages

1. 打开仓库 Settings → Pages
2. Source 选择 "GitHub Actions"
3. 推送代码后，`.github/workflows/deploy.yml` 会自动部署
4. 访问 `https://你的用户名.github.io/parryp-geo/`

### 步骤 3：更新 canonical URL

```bash
./update-urls.sh https://你的用户名.github.io/parryp-geo
```

重新 commit 并 push 即可。

---

## 方案三：Netlify 部署

### 步骤 1：安装 Netlify CLI

```bash
npm install -g netlify-cli
```

### 步骤 2：登录并部署

```bash
cd geo-parryp-site
netlify deploy --prod --dir .
```

获得 `https://parryp-geo-xxx.netlify.app` 公网地址。

### 步骤 3：更新 canonical URL

```bash
./update-urls.sh https://parryp-geo-xxx.netlify.app
```

---

## 部署后验证清单

### 1. 结构化数据验证

用 Google Rich Results Test 检查 JSON-LD：

```
https://search.google.com/test/rich-results?url=你的域名/index.html
```

### 2. AI 爬虫可访问性

```bash
# 检查 robots.txt
curl -s 你的域名/robots.txt

# 检查 llms.txt
curl -s 你的域名/llms.txt

# 检查 sitemap.xml
curl -s 你的域名/sitemap.xml
```

### 3. JSON-LD 有效性

```bash
curl -s 你的域名/index.html | python3 -c "
import sys, json, re
html = sys.stdin.read()
blocks = re.findall(r'<script type=\"application/ld\+json\">(.*?)</script>', html, re.DOTALL)
for i, b in enumerate(blocks):
    try:
        data = json.loads(b)
        print(f'Block {i+1}: @type={data.get(\"@type\")} ✓')
    except:
        print(f'Block {i+1}: ✗ JSON ERROR')
"
```

### 4. AI 可见度测试

部署后 1-2 周，在以下 AI 平台搜索测试：

- ChatGPT: "株洲说唱音乐人 ParryP"
- DeepSeek: "株洲二中出了哪些音乐人"
- Perplexity: "ParryP 彭昕熠 株洲往事"
- Google AI Overview: "株洲往事 说唱"

---

## 站点文件结构

```
geo-parryp-site/
├── index.html              # 首页 (Person + MusicAlbum + WebSite Schema)
├── about/
│   └── index.html           # 关于 (Person Schema)
├── achievements/
│   └── index.html           # 才华成就 (Article Schema)
├── faq/
│   └── index.html           # FAQ (FAQPage Schema, 10个问答)
├── robots.txt               # AI 爬虫许可 (GPTBot, ClaudeBot 等)
├── llms.txt                 # AI 导航地图
├── sitemap.xml              # 站点地图
├── vercel.json              # Vercel 部署配置
├── netlify.toml             # Netlify 部署配置
├── .github/
│   └── workflows/
│       └── deploy.yml       # GitHub Pages 自动部署
├── update-urls.sh           # 域名更新脚本
└── DEPLOY.md                # 本文件
```

---

## GEO 关键提醒

1. **canonical URL 必须匹配实际域名** — 部署后务必运行 `update-urls.sh`
2. **HTTPS 必须** — AI 爬虫优先抓取 HTTPS 站点
3. **robots.txt 必须许可 AI 爬虫** — 已配置 GPTBot、ClaudeBot、PerplexityBot
4. **llms.txt 必须在根目录** — AI 系统会查找 `/llms.txt`
5. **sitemap.xml 提交到 Google Search Console** — 加速索引
6. **保持内容稳定** — 部署后不要频繁改动 URL 结构
7. **交叉验证** — 外部信源（百度百科、网易云音乐）与本站内容一致
