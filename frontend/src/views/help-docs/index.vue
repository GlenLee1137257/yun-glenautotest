<script lang="ts" setup>
import { Card, List } from 'ant-design-vue'
import { BookOutlined } from '@ant-design/icons-vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const helpItems = [
  {
    title: '接口自动化',
    description: '学习如何使用接口自动化功能，包括接口管理、用例管理、断言配置等',
    path: '/help-docs/interface-automation',
    icon: '🔌',
  },
  {
    title: 'UI自动化',
    description: '学习如何使用UI自动化功能，包括元素定位、操作步骤、断言配置等',
    path: '/help-docs/ui-automation',
    icon: '🖥️',
  },
  {
    title: '性能测试',
    description: '学习如何使用性能测试功能，包括并发配置、性能监控、报告分析等',
    path: '/help-docs/stress-test',
    icon: '⚡',
  },
]

function goToDoc(path: string) {
  router.push(path)
}
</script>

<template>
  <div class="help-docs-index">
    <Card :bordered="false">
      <template #title>
        <div class="flex items-center gap-2">
          <BookOutlined class="text-xl" />
          <span>帮助文档中心</span>
        </div>
      </template>
      
      <div class="mb-4 text-gray-600">
        欢迎使用 Glen 自动化云测平台帮助文档，这里提供了完整的使用指南和最佳实践。
      </div>

      <List
        :data-source="helpItems"
        :grid="{ gutter: 16, xs: 1, sm: 1, md: 2, lg: 3, xl: 3, xxl: 3 }"
      >
        <template #renderItem="{ item }">
          <List.Item>
            <Card 
              :bordered="true" 
              hoverable
              class="help-card"
              @click="goToDoc(item.path)"
            >
              <div class="text-center">
                <div class="text-5xl mb-4">{{ item.icon }}</div>
                <h3 class="text-lg font-bold mb-2">{{ item.title }}</h3>
                <p class="text-gray-600 text-sm">{{ item.description }}</p>
              </div>
            </Card>
          </List.Item>
        </template>
      </List>
    </Card>
  </div>
</template>

<style scoped>
.help-docs-index {
  padding: 0;
}

.help-card {
  cursor: pointer;
  transition: all 0.3s ease;
}

.help-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  transform: translateY(-4px);
}
</style>
