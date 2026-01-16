<script lang="ts" setup>
import type { ColumnsType } from 'ant-design-vue/es/table'

const columns: ColumnsType = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id',
    fixed: 'left',
    width: 100,
  },
  {
    title: 'Body',
    dataIndex: 'body',
    key: 'body',
    width: 200,
  },
  {
    title: 'BodyType',
    dataIndex: 'bodyType',
    key: 'bodyType',
    width: 150,
  },
  {
    title: '报告ID',
    dataIndex: 'reportId',
    key: 'reportId',
    width: 100,
  },
  {
    title: '执行状态',
    dataIndex: 'executeState',
    key: 'executeState',
    width: 100,
  },
  {
    title: '断言状态',
    dataIndex: 'assertionState',
    key: 'assertionState',
    width: 100,
  },
  {
    title: '执行信息',
    dataIndex: 'executionMsg',
    key: 'executionMsg',
    width: 150,
  },
  {
    title: '耗时',
    dataIndex: 'expandTime',
    key: 'expandTime',
    width: 100,
  },
  {
    title: '请求头',
    dataIndex: 'requestHeader',
    key: 'requestHeader',
    width: 500,
  },
  {
    title: '请求查询',
    dataIndex: 'requestQuery',
    key: 'requestQuery',
    width: 300,
  },
  {
    title: '请求体',
    dataIndex: 'requestBody',
    key: 'requestBody',
    width: 400,
  },
  {
    title: '响应头',
    dataIndex: 'responseHeader',
    key: 'responseHeader',
    width: 1200,
  },
  {
    title: '响应体',
    dataIndex: 'responseBody',
    key: 'responseBody',
    width: 400,
  },
  {
    title: '环境ID',
    dataIndex: 'environmentId',
    key: 'environmentId',
    width: 100,
  },
  {
    title: '案例ID',
    dataIndex: 'caseId',
    key: 'caseId',
    width: 100,
  },
  {
    title: '编号',
    dataIndex: 'num',
    key: 'num',
    width: 100,
  },
  {
    title: '名称',
    dataIndex: 'name',
    key: 'name',
    width: 150,
  },
  {
    title: '描述',
    dataIndex: 'description',
    key: 'description',
    width: 150,
  },
  {
    title: '断言',
    dataIndex: 'assertion',
    key: 'assertion',
    width: 400,
  },
  {
    title: '关联',
    dataIndex: 'relation',
    key: 'relation',
    width: 400,
  },
  {
    title: '路径',
    dataIndex: 'path',
    key: 'path',
    width: 200,
  },
  {
    title: '方法',
    dataIndex: 'method',
    key: 'method',
    width: 100,
  },
  {
    title: '查询',
    dataIndex: 'query',
    key: 'query',
    width: 200,
  },
  {
    title: '头部',
    dataIndex: 'header',
    key: 'header',
    width: 200,
  },

  {
    title: '创建时间',
    dataIndex: 'gmtCreate',
    key: 'gmtCreate',
    fixed: 'right',
    width: 200,
  },
  {
    title: '修改时间',
    dataIndex: 'gmtModified',
    key: 'gmtModified',
    fixed: 'right',
    width: 200,
  },
  {
    title: '查看详情',
    dataIndex: 'checkDetails',
    key: 'checkDetails',
    fixed: 'right',
    width: 100,
  },
]
</script>

<template>
  <ReportDetailsModalTable
    :columns="
      columns.map((column) => ({ ...column, align: 'center' })) as ColumnsType
    "
  />
</template>
