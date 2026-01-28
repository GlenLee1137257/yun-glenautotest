<script lang="ts" setup>
import type { ColumnsType } from 'ant-design-vue/es/table/Table'

const columns = reactive<ColumnsType<any>>([
  { title: 'ID', dataIndex: 'id', key: 'id' },
  { title: '模块ID', dataIndex: 'moduleId', key: 'moduleId' },
  { title: '名称', dataIndex: 'name', key: 'name' },
  { title: '定位类型', dataIndex: 'locationType', key: 'locationType' },
  { title: '定位表达式', dataIndex: 'locationExpress', key: 'locationExpress' },
  { title: '描述', dataIndex: 'description', key: 'description' },
  { title: '创建时间', dataIndex: 'gmtCreate', key: 'gmtCreate' },
  { title: '修改时间', dataIndex: 'gmtModified', key: 'gmtModified' },
  { key: 'operation', title: '操作', dataIndex: 'operation' },
])
</script>

<template>
  <TableModal base-name="ui_element" localized-name="UI元素" :columns="columns" />
</template>
