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
    width: 80,
    fixed: 'left',
  },
  {
    title: '执行状态',
    dataIndex: 'executeState',
    key: 'executeState',
    width: 90,
  },
  {
    title: '断言状态',
    dataIndex: 'assertionState',
    key: 'assertionState',
    width: 90,
  },
  {
    title: '异常信息',
    dataIndex: 'exceptionMsg',
    key: 'exceptionMsg',
    width: 90,
  },
  {
    title: '消耗时间',
    dataIndex: 'expandTime',
    key: 'expandTime',
    width: 90,
  },
  {
    title: '序号',
    dataIndex: 'num',
    key: 'num',
    width: 80,
  },
  {
    title: '用例ID',
    dataIndex: 'caseId',
    key: 'caseId',
    width: 80,
  },
  {
    title: '步骤名称',
    dataIndex: 'name',
    key: 'name',
    width: 200,
  },
  {
    title: '步骤操作类型',
    dataIndex: 'operationType',
    key: 'operationType',
    width: 200,
  },
  {
    title: '截图url',
    dataIndex: 'screenshotUrl',
    key: 'screenshotUrl',
    width: 100,
  },
  {
    title: 'UI元素定位类型',
    dataIndex: 'locationType',
    key: 'locationType',
    width: 200,
  },
  {
    title: 'UI元素定位表达式',
    dataIndex: 'locationExpress',
    key: 'locationExpress',
    width: 200,
  },
  {
    title: '元素查找最长等待时间',
    dataIndex: 'elementWait',
    key: 'elementWait',
    width: 200,
  },
  {
    title: '目标UI元素定位类型',
    dataIndex: 'targetLocationType',
    key: 'targetLocationType',
    width: 200,
  },
  {
    title: '目标UI元素定位表达式',
    dataIndex: 'targetLocationExpress',
    key: 'targetLocationExpress',
    width: 200,
  },
  {
    title: '目标元素查找最长等待时间',
    dataIndex: 'targetElementWait',
    key: 'targetElementWait',
    width: 200,
  },
  {
    title: '步骤值',
    dataIndex: 'value',
    key: 'value',
    width: 200,
  },
  {
    title: '预期属性',
    dataIndex: 'expectKey',
    key: 'expectKey',
    width: 200,
  },
  {
    title: '预期值',
    dataIndex: 'expectValue',
    key: 'expectValue',
    width: 200,
  },
  {
    title: '步骤描述',
    dataIndex: 'description',
    key: 'description',
    width: 200,
  },
  {
    title: '断言失败是否继续执行',
    dataIndex: 'isContinue',
    key: 'isContinue',
    width: 200,
  },
  {
    title: '是否截图',
    dataIndex: 'isScreenshot',
    key: 'isScreenshot',
    width: 200,
  },

  // {
  //   title: '创建时间',
  //   dataIndex: 'gmtCreate',
  //   key: 'gmtCreate',
  //   width: 150,
  //   fixed: 'right',
  // },
  // {
  //   title: '修改时间',
  //   dataIndex: 'gmtModified',
  //   key: 'gmtModified',
  //   width: 150,
  //   fixed: 'right',
  // },
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
