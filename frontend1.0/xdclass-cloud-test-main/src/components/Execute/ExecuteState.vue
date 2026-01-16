<script lang="ts" setup>
import {
  CheckCircleOutlined,
  ExclamationCircleOutlined,
} from '@ant-design/icons-vue'
defineProps<{
  modelValue: string | number | boolean | null | undefined
}>()
</script>

<template>
  <div
    :class="[!!!!modelValue ? 'text-green-500' : 'text-yellow-500']"
    space-x-2
  >
    <ExclamationCircleOutlined v-if="!!!modelValue" />
    <CheckCircleOutlined v-else />
    <span>{{ modelValue ? '成功' : '失败' }}</span>
  </div>
</template>
