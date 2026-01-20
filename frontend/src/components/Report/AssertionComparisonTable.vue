<script lang="ts" setup>
import { Table, Tag, Tooltip, Alert } from 'ant-design-vue'
import { CheckCircleOutlined, CloseCircleOutlined, InfoCircleOutlined } from '@ant-design/icons-vue'
import type { IApiCaseStepAssertion } from '~/types/apis/api-case'
import type { ColumnsType } from 'ant-design-vue/es/table'

const props = defineProps<{
  // assertion JSON字符串
  assertion: string
  // 断言整体状态（后端执行结果）
  assertionState: boolean
  // 异常信息（断言失败时的详细信息）
  exceptionMsg?: string
}>()

// 解析断言配置
const assertionList = computed<IApiCaseStepAssertion[]>(() => {
  try {
    return JSON.parse(props.assertion || '[]')
  }
  catch {
    return []
  }
})

// 字典名称映射
const fromNameMap: Record<string, string> = {
  RESPONSE_CODE: '响应状态码',
  RESPONSE_HEADER: '响应头',
  RESPONSE_DATA: '响应体',
}

const typeNameMap: Record<string, string> = {
  JSONPATH: 'JSONPath',
  REGEXP: '正则表达式',
}

const actionNameMap: Record<string, string> = {
  EQUAL: '等于',
  NOT_EQUAL: '不等于',
  CONTAIN: '包含',
  NOT_CONTAIN: '不包含',
  GREAT_THEN: '大于',
  LESS_THEN: '小于',
}

// 统计
const stats = computed(() => {
  const total = assertionList.value.length
  return { total }
})

// 构建表格数据源（简化版：只显示配置，不计算实际值）
interface AssertionRow extends IApiCaseStepAssertion {
  index: number
}

const dataSource = computed<AssertionRow[]>(() => {
  return assertionList.value.map((item, index) => ({
    ...item,
    index: index + 1,
  }))
})

// 表格列定义（简化版：移除实际值和结果列）
const columns: ColumnsType = [
  { title: '#', dataIndex: 'index', key: 'index', width: 60, align: 'center' },
  { title: '断言来源', dataIndex: 'from', key: 'from', width: 120, align: 'center' },
  { title: '断言类型', dataIndex: 'type', key: 'type', width: 100, align: 'center' },
  { title: '断言动作', dataIndex: 'action', key: 'action', width: 100, align: 'center' },
  { title: '表达式', dataIndex: 'express', key: 'express', width: 180, align: 'center' },
  { title: '预期值', dataIndex: 'value', key: 'value', width: 150, align: 'center' },
  { title: '说明', dataIndex: 'remark', key: 'remark', width: 250, align: 'center' },
]
</script>

<template>
  <div class="assertion-comparison-container">
    <!-- 统计摘要 -->
    <div class="assertion-summary" mb-4>
      <div flex="~ items-center gap-4" mb-3>
        <span text-lg font-bold>
          <CheckCircleOutlined v-if="assertionState" style="color: #52c41a; margin-right: 8px" />
          <CloseCircleOutlined v-else style="color: #ff4d4f; margin-right: 8px" />
          断言检查结果
        </span>
        <Tag v-if="assertionState" color="success" style="font-size: 14px">
          ✅ 全部通过 ({{ stats.total }} 项)
        </Tag>
        <Tag v-else color="error" style="font-size: 14px">
          ❌ 断言失败
        </Tag>
      </div>

      <!-- 失败时显示错误信息 -->
      <Alert
        v-if="!assertionState && exceptionMsg"
        type="error"
        show-icon
        :message="'断言失败详情'"
        :description="exceptionMsg"
        closable
      />

      <!-- 说明提示 -->
      <Alert
        type="info"
        show-icon
        style="margin-top: 12px"
      >
        <template #message>
          <InfoCircleOutlined style="margin-right: 6px" />
          以下为断言配置信息（执行结果以后端为准）
        </template>
      </Alert>
    </div>

    <!-- 断言对比表 -->
    <Table
      :data-source="dataSource"
      :columns="columns"
      :pagination="false"
      size="small"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <!-- 断言来源 -->
        <template v-if="column.key === 'from'">
          <Tooltip :title="fromNameMap[record.from]" placement="topLeft">
            <Tag color="blue">{{ fromNameMap[record.from] }}</Tag>
          </Tooltip>
        </template>

        <!-- 断言类型 -->
        <template v-else-if="column.key === 'type'">
          <Tag color="cyan">{{ typeNameMap[record.type] }}</Tag>
        </template>

        <!-- 断言动作 -->
        <template v-else-if="column.key === 'action'">
          <Tag color="purple">{{ actionNameMap[record.action] }}</Tag>
        </template>

        <!-- 表达式 -->
        <template v-else-if="column.key === 'express'">
          <Tooltip :title="record.express" placement="topLeft">
            <code text-xs style="cursor: pointer">{{ record.express }}</code>
          </Tooltip>
        </template>

        <!-- 预期值 -->
        <template v-else-if="column.key === 'value'">
          <Tooltip :title="record.value" placement="topLeft">
            <code style="cursor: pointer; font-weight: 500; color: #1890ff">
              {{ record.value }}
            </code>
          </Tooltip>
        </template>

        <!-- 说明 -->
        <template v-else-if="column.key === 'remark'">
          <span v-if="record.remark" style="color: #666">
            {{ record.remark }}
          </span>
          <span v-else style="color: #ccc">-</span>
        </template>
      </template>
    </Table>
  </div>
</template>

<style scoped>
.assertion-comparison-container {
  width: 100%;
}

:deep(.ant-table-small) {
  font-size: 13px;
}

:deep(.ant-table-cell) {
  padding: 8px 12px !important;
}

code {
  background-color: #f5f5f5;
  padding: 2px 6px;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
}
</style>
