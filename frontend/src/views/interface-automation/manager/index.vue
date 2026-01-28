<script lang="ts" setup>
import type { ColumnsType } from 'ant-design-vue/es/table/Table'

const columns = reactive<ColumnsType<any>>([
  {
    key: 'id',
    title: 'ID',
    dataIndex: 'id',
  },
  {
    key: 'name',
    title: '接口名称',
    dataIndex: 'name',
  },
  {
    key: 'path',
    title: '接口地址',
    dataIndex: 'path',
  },
  {
    key: 'moduleId',
    title: '模块Id',
    dataIndex: 'moduleId',
  },
  {
    key: 'environmentId',
    title: '环境Id',
    dataIndex: 'environmentId',
  },
  {
    key: 'gmtCreate',
    title: '创建时间',
    dataIndex: 'gmtCreate',
  },
  {
    key: 'gmtModified',
    title: '更新时间',
    dataIndex: 'gmtModified',
  },
  {
    key: 'operation',
    title: '操作',
    dataIndex: 'operation',
  },
])
</script>

<template>
  <TableModal base-name="api" localized-name="接口" :columns="columns" />
</template>
