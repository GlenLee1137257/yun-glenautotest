<script lang="ts" setup>
import type { ColumnsType } from 'ant-design-vue/es/table'

const columns: ColumnsType = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id',
    width: 100,
    fixed: 'left',
  },
  {
    title: '报告ID',
    dataIndex: 'reportId',
    key: 'reportId',
    width: 100,
    fixed: 'left',
  },
  {
    title: '断言信息',
    dataIndex: 'assertInfo',
    key: 'assertInfo',
    width: 150,
  },
  {
    title: '错误数量',
    dataIndex: 'errorCount',
    key: 'errorCount',
    width: 100,
  },
  {
    title: '错误百分比',
    dataIndex: 'errorPercentage',
    key: 'errorPercentage',
    width: 120,
  },
  {
    title: '最大时间',
    dataIndex: 'maxTime',
    key: 'maxTime',
    width: 100,
  },
  {
    title: '平均时间',
    dataIndex: 'meanTime',
    key: 'meanTime',
    width: 100,
  },
  {
    title: '最小时间',
    dataIndex: 'minTime',
    key: 'minTime',
    width: 100,
  },
  {
    title: '接收KB/秒',
    dataIndex: 'receiveKBPerSecond',
    key: 'receiveKBPerSecond',
    width: 130,
  },
  {
    title: '发送KB/秒',
    dataIndex: 'sentKBPerSecond',
    key: 'sentKBPerSecond',
    width: 130,
  },
  {
    title: '请求位置',
    dataIndex: 'requestLocation',
    key: 'requestLocation',
    width: 500,
  },
  {
    title: '请求头',
    dataIndex: 'requestHeader',
    key: 'requestHeader',
    width: 500,
  },
  {
    title: '请求体',
    dataIndex: 'requestBody',
    key: 'requestBody',
    width: 500,
  },
  {
    title: '请求率',
    dataIndex: 'requestRate',
    key: 'requestRate',
    width: 120,
  },
  {
    title: '响应码',
    dataIndex: 'responseCode',
    key: 'responseCode',
    width: 100,
  },
  {
    title: '响应数据',
    dataIndex: 'responseData',
    key: 'responseData',
    width: 500,
  },
  {
    title: '响应头',
    dataIndex: 'responseHeader',
    key: 'responseHeader',
    width: 800,
  },
  {
    title: '采样器数量',
    dataIndex: 'samplerCount',
    key: 'samplerCount',
    width: 120,
  },
  {
    title: '采样器标签',
    dataIndex: 'samplerLabel',
    key: 'samplerLabel',
    width: 150,
  },
  {
    title: '线程数量',
    dataIndex: 'threadCount',
    key: 'threadCount',
    width: 120,
  },
  {
    title: '采样时间',
    dataIndex: 'sampleTime',
    key: 'sampleTime',
    width: 150,
  },
  {
    title: '创建时间',
    dataIndex: 'gmtCreate',
    key: 'gmtCreate',
    width: 150,
    fixed: 'right',
  },
  {
    title: '修改时间',
    dataIndex: 'gmtModified',
    key: 'gmtModified',
    width: 150,
    fixed: 'right',
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
