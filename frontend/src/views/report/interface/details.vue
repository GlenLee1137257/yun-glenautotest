<script lang="ts" setup>
import { Table, Button, Collapse, Divider, Tag, Tooltip } from 'ant-design-vue'
import { CaretRightOutlined, LeftOutlined } from '@ant-design/icons-vue'
import dayjs from 'dayjs'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { IApiReportDetail } from '~/types/apis/report'
import type { IBasicWithPage } from '~/types/apis/basic'
import type { AfterFetchContext } from '@vueuse/core'
import AssertionComparisonTable from '~/components/Report/AssertionComparisonTable.vue'
import VariableChainView from '~/components/Report/VariableChainView.vue'
import RequestResponseDetail from '~/components/Report/RequestResponseDetail.vue'

const route = useRoute()
const router = useRouter()

const pageConfig = reactive<{
  page: number
  size: number
  reportId: number | undefined
  type: string
  totalSize: number
}>({
  page: 1,
  size: 10,
  reportId: undefined,
  type: 'API',
  totalSize: 0,
})

// 获取数据
const {
  post,
  data: dataSource,
  isFetching,
} = useCustomFetch<IApiReportDetail[]>(
  '/data-service/api/v1/report_detail/page',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IApiReportDetail>>) => {
      if (ctx.data && ctx.data.code === 0) {
        pageConfig.totalSize = ctx.data.data.total_record
        return {
          data: ctx.data.data.current_data,
          response: ctx.response,
        }
      }
      return {
        data: [],
        response: ctx.response,
      }
    },
  },
)

async function reFetch() {
  await nextTick()
  post(toRaw(pageConfig)).execute()
}

onMounted(() => {
  if (route.query.id) {
    pageConfig.reportId = Number(route.query.id)
    pageConfig.type = route.query.type as string
  }
  reFetch()
})

// 简化的表格列（只显示关键信息）
const columns: ColumnsType = [
  {
    title: '序号',
    dataIndex: 'num',
    key: 'num',
    width: 80,
    align: 'center',
  },
  {
    title: '步骤名称',
    dataIndex: 'name',
    key: 'name',
    width: 200,
    align: 'center',
  },
  {
    title: '请求方法',
    dataIndex: 'method',
    key: 'method',
    width: 100,
    align: 'center',
  },
  {
    title: '请求路径',
    dataIndex: 'path',
    key: 'path',
    width: 250,
    align: 'center',
  },
  {
    title: '执行状态',
    dataIndex: 'executeState',
    key: 'executeState',
    width: 100,
    align: 'center',
  },
  {
    title: '断言状态',
    dataIndex: 'assertionState',
    key: 'assertionState',
    width: 100,
    align: 'center',
  },
  {
    title: '耗时',
    dataIndex: 'expendTime',
    key: 'expendTime',
    width: 100,
    align: 'center',
  },
]

// 获取方法颜色
function getMethodColor(method: string): string {
  const colors: Record<string, string> = {
    GET: 'blue',
    POST: 'green',
    PUT: 'orange',
    DELETE: 'red',
    PATCH: 'purple',
    HEAD: 'cyan',
    OPTIONS: 'default',
  }
  return colors[method?.toUpperCase()] || 'default'
}
</script>

<template>
  <div class="api-report-detail-page" p-6>
    <Button type="default" mb-6 @click="router.back()">
      <LeftOutlined />
      返回
    </Button>

    <Table
      :loading="isFetching"
      :columns="columns"
      :data-source="dataSource"
      :pagination="{
        showLessItems: true,
        current: pageConfig.page,
        pageSize: pageConfig.size,
        total: pageConfig.totalSize,
        onChange(page, pageSize) {
          pageConfig.page = page
          pageConfig.size = pageSize
          reFetch()
        },
      }"
      :expand-row-by-click="true"
      row-key="id"
    >
      <!-- 自定义表格单元格 -->
      <template #bodyCell="{ column, record, index }">
        <!-- 序号列：显示从 1 开始 -->
        <template v-if="column.key === 'num'">
          {{ index + 1 }}
        </template>

        <!-- 步骤名称 -->
        <template v-else-if="column.key === 'name'">
          <Tooltip :title="record.name" placement="topLeft">
            <span font-semibold style="cursor: pointer">{{ record.name }}</span>
          </Tooltip>
        </template>

        <!-- 请求方法 -->
        <template v-else-if="column.key === 'method'">
          <Tag :color="getMethodColor(record.method)" style="font-weight: bold">
            {{ record.method }}
          </Tag>
        </template>

        <!-- 请求路径 -->
        <template v-else-if="column.key === 'path'">
          <Tooltip :title="record.path" placement="topLeft">
            <code text-xs style="cursor: pointer">{{ record.path }}</code>
          </Tooltip>
        </template>

        <!-- 执行状态 -->
        <template v-else-if="column.key === 'executeState'">
          <Tag :color="record.executeState ? 'success' : 'error'">
            {{ record.executeState ? '✅ 成功' : '❌ 失败' }}
          </Tag>
        </template>

        <!-- 断言状态 -->
        <template v-else-if="column.key === 'assertionState'">
          <Tag :color="record.assertionState ? 'success' : 'error'">
            {{ record.assertionState ? '✅ 通过' : '❌ 未通过' }}
          </Tag>
        </template>

        <!-- 耗时 -->
        <template v-else-if="column.key === 'expendTime'">
          <Tooltip
            v-if="record.expendTime && record.expendTime > 0"
            :title="`${record.expendTime}ms (${(record.expendTime / 1000).toFixed(2)}s)`"
            placement="topLeft"
          >
            <span style="cursor: pointer">
              {{ record.expendTime >= 1000 ? `${(record.expendTime / 1000).toFixed(2)}s` : `${record.expendTime}ms` }}
            </span>
          </Tooltip>
          <span v-else>-</span>
        </template>
      </template>

      <!-- 可展开的详情内容 -->
      <template #expandedRowRender="{ record }">
        <div class="expanded-row-content" p-6 bg-gray-50 rounded>
          <!-- 步骤概览 -->
          <div class="step-overview" mb-6 p-4 bg-white rounded shadow-sm>
            <div text-lg font-bold mb-3>
              📋 步骤概览
            </div>
            <div grid="~ cols-2 gap-4">
              <div>
                <span text-gray-600>步骤序号: </span>
                <!-- 详情里的步骤序号也从 1 开始展示，和用例编辑页保持一致 -->
                <span font-semibold>{{ (record.num ?? 0) + 1 }}</span>
              </div>
              <div>
                <span text-gray-600>步骤名称: </span>
                <span font-semibold>{{ record.name }}</span>
              </div>
              <div>
                <span text-gray-600>步骤描述: </span>
                <span>{{ record.description || '-' }}</span>
              </div>
              <div>
                <span text-gray-600>执行时间: </span>
                <span>{{ dayjs(record.gmtCreate).format('YYYY-MM-DD HH:mm:ss') }}</span>
              </div>
              <div v-if="record.exceptionMsg">
                <span text-gray-600>执行信息: </span>
                <Tooltip :title="record.exceptionMsg">
                  <span text-red-500 style="cursor: pointer">{{ record.exceptionMsg }}</span>
                </Tooltip>
              </div>
            </div>
          </div>

          <!-- 可折叠的详细信息区域 -->
          <Collapse
            :bordered="false"
            :expand-icon-position="'start'"
            :default-active-key="['variable', 'assertion', 'request-response']"
          >
            <!-- 变量传递链 -->
            <Collapse.Panel key="variable" header="🔗 变量传递链">
              <VariableChainView
                :step-num="record.num"
                :relation="record.relation"
                :response-body="record.responseBody"
                :response-header="record.responseHeader"
                :request-body="record.requestBody"
                :request-query="record.requestQuery"
                :request-header="record.requestHeader"
              />
            </Collapse.Panel>

            <!-- 断言对比 -->
            <Collapse.Panel key="assertion" header="✅ 断言检查">
              <AssertionComparisonTable
                :assertion="record.assertion"
                :assertion-state="record.assertionState"
                :exception-msg="record.exceptionMsg"
              />
            </Collapse.Panel>

            <!-- 请求响应详情 -->
            <Collapse.Panel key="request-response" header="📨 请求/响应详情">
              <RequestResponseDetail
                :method="record.method"
                :path="record.path"
                :request-header="record.requestHeader"
                :request-query="record.requestQuery"
                :request-body="record.requestBody"
                :response-header="record.responseHeader"
                :response-body="record.responseBody"
              />
            </Collapse.Panel>
          </Collapse>
        </div>
      </template>

      <!-- 自定义展开图标 -->
      <template #expandIcon="{ expanded, onExpand, record }">
        <CaretRightOutlined
          :rotate="expanded ? 90 : 0"
          style="font-size: 14px; cursor: pointer; transition: transform 0.2s"
          @click="(e: any) => onExpand(record, e)"
        />
      </template>
    </Table>
  </div>
</template>

<style scoped>
.api-report-detail-page {
  min-height: calc(100vh - 120px);
}

code {
  background-color: #f5f5f5;
  padding: 2px 6px;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
}

.expanded-row-content {
  margin: 0 48px;
}

:deep(.ant-collapse) {
  background-color: transparent;
}

:deep(.ant-collapse-item) {
  margin-bottom: 16px;
  background-color: white;
  border-radius: 8px;
  border: 1px solid #e8e8e8;
  overflow: hidden;
}

:deep(.ant-collapse-header) {
  font-weight: 600;
  font-size: 15px;
  padding: 16px 20px !important;
  background-color: #fafafa;
}

:deep(.ant-collapse-content) {
  border-top: 1px solid #e8e8e8;
}

:deep(.ant-collapse-content-box) {
  padding: 20px;
}

:deep(.ant-table-expanded-row > td) {
  padding: 0 !important;
}
</style>
