<script lang="ts" setup>
import { Form, Select } from 'ant-design-vue'

const moduleId = defineModel<number>('moduleId', { required: true })

const { modules } = storeToRefs(useTemporaryStore())
</script>

<template>
  <Form.Item label="模块ID">
    <Select v-model:value="moduleId" default-value="1">
      <Select.Option v-for="item in modules" :key="item.id" :value="item.id">
        {{ item.name }}
      </Select.Option>
    </Select>
  </Form.Item>
</template>
