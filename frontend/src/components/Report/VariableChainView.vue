<script lang="ts" setup>
import { Tag, Tooltip, Empty } from 'ant-design-vue'
import { LinkOutlined, ArrowRightOutlined, CheckCircleOutlined, CloseCircleOutlined } from '@ant-design/icons-vue'
import type { IApiCaseStepRelation } from '~/types/apis/api-case'
import JsonPath from 'jsonpath'

const props = defineProps<{
  // 当前步骤序号
  stepNum: number
  // 关联变量配置 JSON字符串
  relation: string
  // 响应体（用于提取变量值）
  responseBody: string
  // 响应头
  responseHeader: string
  // 请求体（用于展示接收到的变量）
  requestBody: string
  // 请求查询参数
  requestQuery: string
  // 请求头
  requestHeader: string
}>()

// 解析关联变量配置
const relationList = computed<IApiCaseStepRelation[]>(() => {
  try {
    return JSON.parse(props.relation || '[]')
  }
  catch {
    return []
  }
})

// 字典映射
const fromNameMap: Record<string, string> = {
  REQUEST_HEADER: '请求头',
  REQUEST_BODY: '请求体',
  REQUEST_QUERY: '请求查询参数',
  RESPONSE_HEADER: '响应头',
  RESPONSE_DATA: '响应体',
}

const typeNameMap: Record<string, string> = {
  JSONPATH: 'JSONPath',
  REGEXP: '正则表达式',
}

// 提取变量值
interface ExtractedVariable {
  name: string
  from: string
  type: string
  express: string
  value: string
  success: boolean
}

function extractVariable(item: IApiCaseStepRelation): ExtractedVariable {
  try {
    let sourceData: any = null

    // 根据来源选择数据源
    if (item.from === 'RESPONSE_DATA') {
      sourceData = JSON.parse(props.responseBody || '{}')
    }
    else if (item.from === 'RESPONSE_HEADER') {
      sourceData = JSON.parse(props.responseHeader || '{}')
    }
    else if (item.from === 'REQUEST_BODY') {
      sourceData = JSON.parse(props.requestBody || '{}')
    }
    else if (item.from === 'REQUEST_HEADER') {
      sourceData = JSON.parse(props.requestHeader || '{}')
    }
    else if (item.from === 'REQUEST_QUERY') {
      sourceData = JSON.parse(props.requestQuery || '{}')
    }

    let extractedValue = ''
    let success = false

    // 根据类型提取值
    if (item.type === 'JSONPATH') {
      const result = JsonPath.query(sourceData, item.express)
      if (result.length > 0) {
        extractedValue = result.length === 1 ? String(result[0]) : JSON.stringify(result)
        success = true
      }
      else {
        extractedValue = 'null (未匹配到值)'
        success = false
      }
    }
    else if (item.type === 'REGEXP') {
      const sourceStr = typeof sourceData === 'string' ? sourceData : JSON.stringify(sourceData)
      const regex = new RegExp(item.express)
      const match = sourceStr.match(regex)
      if (match) {
        extractedValue = match[0]
        success = true
      }
      else {
        extractedValue = '未匹配'
        success = false
      }
    }

    return {
      name: item.name,
      from: item.from,
      type: item.type,
      express: item.express,
      value: extractedValue,
      success,
    }
  }
  catch (error) {
    return {
      name: item.name,
      from: item.from,
      type: item.type,
      express: item.express,
      value: `提取失败: ${error}`,
      success: false,
    }
  }
}

// 提取的变量列表
const extractedVariables = computed<ExtractedVariable[]>(() => {
  return relationList.value.map(item => extractVariable(item))
})

// 从请求中检测使用的变量（简化版，检测 {{变量名}} 模式）
interface UsedVariable {
  name: string
  location: string // 使用位置：请求头/请求体/请求查询参数
}

const usedVariables = computed<UsedVariable[]>(() => {
  const variables: UsedVariable[] = []
  const variablePattern = /\{\{([^}]+)\}\}/g

  // 检查请求体
  if (props.requestBody) {
    const bodyMatches = props.requestBody.matchAll(variablePattern)
    for (const match of bodyMatches) {
      variables.push({
        name: match[1],
        location: '请求体',
      })
    }
  }

  // 检查请求查询参数
  if (props.requestQuery) {
    const queryMatches = props.requestQuery.matchAll(variablePattern)
    for (const match of queryMatches) {
      variables.push({
        name: match[1],
        location: '请求查询参数',
      })
    }
  }

  // 检查请求头
  if (props.requestHeader) {
    const headerMatches = props.requestHeader.matchAll(variablePattern)
    for (const match of headerMatches) {
      variables.push({
        name: match[1],
        location: '请求头',
      })
    }
  }

  // 去重
  const uniqueVariables = variables.filter((v, index, self) =>
    index === self.findIndex(t => t.name === v.name && t.location === v.location),
  )

  return uniqueVariables
})

// 统计
const stats = computed(() => {
  const extracted = extractedVariables.value.length
  const extractedSuccess = extractedVariables.value.filter(v => v.success).length
  const used = usedVariables.value.length

  return { extracted, extractedSuccess, used }
})
</script>

<template>
  <div class="variable-chain-container">
    <div flex="~ items-center gap-4" mb-4>
      <span text-lg font-bold>
        <LinkOutlined style="color: #1890ff; margin-right: 8px" />
        变量传递链
      </span>
      <Tag v-if="stats.used > 0" color="blue">
        使用 {{ stats.used }} 个变量
      </Tag>
      <Tag v-if="stats.extracted > 0" color="green">
        提取 {{ stats.extractedSuccess }}/{{ stats.extracted }} 个变量
      </Tag>
    </div>

    <!-- 接收到的变量（从上一步传递来的） -->
    <div v-if="usedVariables.length > 0" class="variable-section" mb-6>
      <div class="section-title" mb-3>
        <ArrowRightOutlined style="color: #1890ff; margin-right: 6px" />
        <span font-semibold>本步骤接收的变量</span>
        <span text-sm text-gray-500 ml-2>(来自前序步骤)</span>
      </div>
      <div class="variable-list" flex="~ wrap gap-3">
        <div
          v-for="(v, index) in usedVariables"
          :key="index"
          class="variable-item"
          p-3
          bg-blue-50
          rounded
          border="~ blue-200"
        >
          <div flex="~ items-center gap-2" mb-2>
            <Tag color="processing">
              变量名
            </Tag>
            <code text-sm font-bold>{{ v.name }}</code>
          </div>
          <div text-xs text-gray-600>
            使用位置: {{ v.location }}
          </div>
        </div>
      </div>
    </div>

    <!-- 本步骤提取的变量（传递给后续步骤） -->
    <div v-if="extractedVariables.length > 0" class="variable-section">
      <div class="section-title" mb-3>
        <ArrowRightOutlined style="color: #52c41a; margin-right: 6px" />
        <span font-semibold>本步骤提取的变量</span>
        <span text-sm text-gray-500 ml-2>(供后续步骤使用)</span>
      </div>
      <div class="variable-list" flex="~ wrap gap-3">
        <div
          v-for="(v, index) in extractedVariables"
          :key="index"
          class="variable-item"
          p-3
          rounded
          border="~"
          :class="v.success ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'"
        >
          <div flex="~ items-center justify-between" mb-2>
            <div flex="~ items-center gap-2">
              <Tag :color="v.success ? 'success' : 'error'">
                {{ v.name }}
              </Tag>
              <CheckCircleOutlined v-if="v.success" style="color: #52c41a" />
              <CloseCircleOutlined v-else style="color: #ff4d4f" />
            </div>
          </div>

          <div class="variable-details" text-xs>
            <div mb-1>
              <span text-gray-500>来源: </span>
              <Tag size="small" color="blue">{{ fromNameMap[v.from] }}</Tag>
            </div>
            <div mb-1>
              <span text-gray-500>类型: </span>
              <Tag size="small" color="cyan">{{ typeNameMap[v.type] }}</Tag>
            </div>
            <div mb-1>
              <span text-gray-500>表达式: </span>
              <Tooltip :title="v.express">
                <code>{{ v.express }}</code>
              </Tooltip>
            </div>
            <div>
              <span text-gray-500>提取值: </span>
              <Tooltip :title="v.value">
                <span
                  font-semibold
                  :style="{ color: v.success ? '#52c41a' : '#ff4d4f' }"
                >
                  {{ v.value }}
                </span>
              </Tooltip>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 无变量时的提示 -->
    <Empty
      v-if="usedVariables.length === 0 && extractedVariables.length === 0"
      description="本步骤未使用或提取变量"
      :image="Empty.PRESENTED_IMAGE_SIMPLE"
    />
  </div>
</template>

<style scoped>
.variable-chain-container {
  width: 100%;
}

.section-title {
  display: flex;
  align-items: center;
  font-size: 14px;
}

.variable-item {
  min-width: 280px;
  max-width: 400px;
  transition: all 0.3s ease;
}

.variable-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

code {
  background-color: #f5f5f5;
  padding: 2px 6px;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
  font-size: 12px;
}

.variable-details {
  line-height: 1.8;
}
</style>
