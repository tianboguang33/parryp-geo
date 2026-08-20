#!/bin/bash
# update-urls.sh - 更新站点所有 canonical URL 到实际部署域名
# 用法: ./update-urls.sh https://your-actual-domain.com

set -e

NEW_DOMAIN="${1:-}"
if [ -z "$NEW_DOMAIN" ]; then
  echo "用法: ./update-urls.sh https://your-domain.com"
  echo "示例: ./update-urls.sh https://parryp.vercel.app"
  echo "      ./update-urls.sh https://parryp.dev"
  exit 1
fi

# 移除末尾斜杠
NEW_DOMAIN="${NEW_DOMAIN%/}"
OLD_DOMAIN="https://parryp.dev"

echo "=== GEO 站点 URL 更新 ==="
echo "旧域名: $OLD_DOMAIN"
echo "新域名: $NEW_DOMAIN"
echo ""

# 更新所有 HTML 文件
HTML_FILES=$(find . -name "*.html" -not -path "./.github/*")
for file in $HTML_FILES; do
  count=$(grep -c "$OLD_DOMAIN" "$file" 2>/dev/null || echo 0)
  if [ "$count" -gt 0 ]; then
    sed -i "s|$OLD_DOMAIN|$NEW_DOMAIN|g" "$file"
    echo "  [OK] $file ($count 处替换)"
  fi
done

# 更新 llms.txt
if grep -q "$OLD_DOMAIN" llms.txt 2>/dev/null; then
  sed -i "s|$OLD_DOMAIN|$NEW_DOMAIN|g" llms.txt
  echo "  [OK] llms.txt"
fi

# 更新 sitemap.xml
if grep -q "$OLD_DOMAIN" sitemap.xml 2>/dev/null; then
  sed -i "s|$OLD_DOMAIN|$NEW_DOMAIN|g" sitemap.xml
  echo "  [OK] sitemap.xml"
fi

echo ""
echo "=== 更新完成 ==="
echo "新域名: $NEW_DOMAIN"
echo ""
echo "验证:"
echo "  curl -s $NEW_DOMAIN/llms.txt"
echo "  curl -s $NEW_DOMAIN/sitemap.xml"
echo "  curl -s $NEW_DOMAIN/index.html | python3 -m json.tool"
