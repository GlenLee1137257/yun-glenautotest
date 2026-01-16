<script setup lang="ts">
import { ConfigProvider } from 'ant-design-vue'

import zhCN from 'ant-design-vue/es/locale/zh_CN'
import dayjs from 'dayjs'
import Layout from './layouts/index.vue'
import 'dayjs/locale/zh-cn'

dayjs.locale('zh-cn')

const route = useRoute()
const matched = computed(() => {
  console.log(route.path)
  return !(
    route.fullPath.includes('login') ||
    route.path === '/' ||
    route.fullPath.includes('register')
  )
})
</script>

<template>
  <ConfigProvider :locale="zhCN">
    <Layout v-if="matched">
      <RouterView :key="route.fullPath" />
    </Layout>
    <RouterView v-else />
  </ConfigProvider>
</template>
