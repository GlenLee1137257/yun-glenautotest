<script lang="ts" setup>
import { Button } from 'ant-design-vue'
import type { ColumnsType } from 'ant-design-vue/es/table/Table'

const columns = reactive<ColumnsType<any>>([
  { title: 'ID', dataIndex: 'id', key: 'id' },
  { title: '模块ID', dataIndex: 'moduleId', key: 'moduleId' },
  { title: '浏览器', dataIndex: 'browser', key: 'browser' },
  { title: '名称', dataIndex: 'name', key: 'name' },
  { title: '描述', dataIndex: 'description', key: 'description' },
  { title: '级别', dataIndex: 'level', key: 'level' },
  // { title: '状态', dataIndex: 'status', key: 'status' },
  { title: '创建时间', dataIndex: 'gmtCreate', key: 'gmtCreate' },
  { title: '修改时间', dataIndex: 'gmtModified', key: 'gmtModified' },
  { key: 'operation', title: '操作', dataIndex: 'operation' },
])

const visibleModel = ref(false)
const executeId = ref<number>(-1)
const executeModalColumnsBefore: ColumnsType<any> = [
  {
    key: 'name',
    title: '接口名称',
    dataIndex: 'name',
    align: 'center',
    width: 90,
  },
  {
    key: 'locationType',
    title: '定位类型',
    dataIndex: 'locationType',
    align: 'center',
    width: 90,
  },
  {
    key: 'locationExpress',
    title: '定位表达式',
    dataIndex: 'locationExpress',
    align: 'center',
    width: 200,
  },
  {
    key: 'value',
    title: '值',
    dataIndex: 'value',
    align: 'center',
    width: 90,
  },
  {
    key: 'description',
    title: '步骤描述',
    dataIndex: 'description',
    align: 'center',
    width: 90,
  },
]

function handleExecute(id: number) {
  executeId.value = id
  visibleModel.value = true
}
</script>

<template>
  <ExecuteModal
    v-model:execute-id="executeId"
    v-model:visible-model="visibleModel"
    :expand-columns-before="executeModalColumnsBefore"
    base-name="ui"
  />

  <TableModal base-name="ui_case" localized-name="UI 用例" :columns="columns">
    <template #operation="{ record }">
      <Button type="link" @click="handleExecute(record.id)"> 执行 </Button>
    </template>
  </TableModal>
</template>
