<script lang="ts" setup>
import { Form, Select } from 'ant-design-vue'

defineProps<{ disabled?: boolean }>()

const method = defineModel<string>('method', { required: true })
</script>

<template>
  <Form.Item label="请求方式">
    <Select v-model:value="method" default-value="GET" :disabled="disabled">
      <Select.Option value="GET">GET</Select.Option>
      <Select.Option value="POST">POST</Select.Option>
      <Select.Option value="PUT">PUT</Select.Option>
      <Select.Option value="DELETE">DELETE</Select.Option>
      <Select.Option value="HEAD">HEAD</Select.Option>
      <Select.Option value="OPTIONS">OPTIONS</Select.Option>
    </Select>
  </Form.Item>
</template>
