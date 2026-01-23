#!/bin/bash
# 更新帮助文档脚本
# 用途：将 markdown/help/ 目录下的帮助文档复制到前端 public/markdown/ 目录

cd /home/hinkad/yun-glenautotest

echo "🔄 开始更新帮助文档..."

# 检查源文件是否存在
if [ ! -f "markdown/help/接口自动化帮助文档.md" ]; then
    echo "⚠️  警告: markdown/help/接口自动化帮助文档.md 不存在"
else
    cp markdown/help/接口自动化帮助文档.md frontend/public/markdown/
    echo "✅ 已更新: 接口自动化帮助文档.md"
fi

if [ ! -f "markdown/help/UI自动化帮助文档.md" ]; then
    echo "⚠️  警告: markdown/help/UI自动化帮助文档.md 不存在"
else
    cp markdown/help/UI自动化帮助文档.md frontend/public/markdown/
    echo "✅ 已更新: UI自动化帮助文档.md"
fi

if [ ! -f "markdown/help/性能测试帮助文档.md" ]; then
    echo "⚠️  警告: markdown/help/性能测试帮助文档.md 不存在"
else
    cp markdown/help/性能测试帮助文档.md frontend/public/markdown/
    echo "✅ 已更新: 性能测试帮助文档.md"
fi

echo ""
echo "📁 文档位置: frontend/public/markdown/"
echo "✨ 更新完成！请刷新浏览器查看最新文档。"
