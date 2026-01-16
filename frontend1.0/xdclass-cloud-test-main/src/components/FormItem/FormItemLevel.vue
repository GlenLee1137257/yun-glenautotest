<script lang="ts" setup>
import { Form, Select } from 'ant-design-vue'

const level = defineModel<string>('level', { required: true })
</script>

<template>
  <Form.Item label="接口等级">
    <Select v-model:value="level" default-value="0">
      <Select.Option value="0">P0</Select.Option>
      <Select.Option value="1">P1</Select.Option>
      <Select.Option value="2">P2</Select.Option>
      <Select.Option value="3">P3</Select.Option>
    </Select>
  </Form.Item>
</template>
