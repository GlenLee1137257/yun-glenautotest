<script lang="ts" setup>
import { ref, onMounted, computed } from 'vue'
import { Card, Spin } from 'ant-design-vue'
import { marked } from 'marked'

const markdownContent = ref('')
const loading = ref(true)

// 配置 marked
marked.setOptions({
  breaks: true,
  gfm: true,
})

onMounted(async () => {
  try {
    // 从后端或public目录读取markdown文件
    const response = await fetch('/markdown/接口自动化帮助文档.md')
    markdownContent.value = await response.text()
  } catch (error) {
    console.error('加载文档失败:', error)
    markdownContent.value = '# 文档加载失败\n\n请检查文件路径是否正确。'
  } finally {
    loading.value = false
  }
})

const renderedHtml = computed(() => {
  if (!markdownContent.value) return ''
  return marked(markdownContent.value) as string
})
</script>

<template>
  <div class="help-docs-container">
    <Card title="接口自动化帮助文档" :bordered="false">
      <Spin :spinning="loading" tip="加载中...">
        <div 
          v-if="renderedHtml"
          class="markdown-body prose max-w-none"
          v-html="renderedHtml"
        />
        <div v-else class="text-gray-400 text-center py-20">
          暂无内容
        </div>
      </Spin>
    </Card>
  </div>
</template>

<style scoped>
.help-docs-container {
  padding: 0;
}

.markdown-body {
  line-height: 1.8;
  color: #333;
}

.markdown-body :deep(h1) {
  border-bottom: 2px solid #eee;
  padding-bottom: 10px;
}

.markdown-body :deep(h2) {
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
}

.markdown-body :deep(pre) {
  background-color: #f6f8fa;
  border-radius: 6px;
  padding: 16px;
  overflow-x: auto;
  font-size: 14px;
}

.markdown-body :deep(code) {
  background-color: #f0f0f0;
  padding: 2px 6px;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
  font-size: 0.9em;
}

.markdown-body :deep(table) {
  border-collapse: collapse;
  width: 100%;
  margin: 20px 0;
}

.markdown-body :deep(table th),
.markdown-body :deep(table td) {
  border: 1px solid #ddd;
  padding: 8px 12px;
  text-align: left;
}

.markdown-body :deep(table th) {
  background-color: #f6f8fa;
  font-weight: bold;
}

.markdown-body :deep(img) {
  max-width: 100%;
  height: auto;
  margin: 20px 0;
}

.markdown-body :deep(blockquote) {
  border-left: 4px solid #dfe2e5;
  padding-left: 16px;
  color: #6a737d;
  margin: 20px 0;
}
</style>
