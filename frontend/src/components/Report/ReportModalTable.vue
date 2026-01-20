<script lang="ts" setup>
import dayjs from 'dayjs'
import {
  Button,
  DatePicker,
  Form,
  Input,
  Popconfirm,
  Table,
  Tooltip,
  message,
} from 'ant-design-vue'
import { type AfterFetchContext, objectOmit } from '@vueuse/core'
import axios from 'axios'
// import { ToRaw } from '../../types/apis/basic'
import type { IBasicWithPage } from '~/types/apis/basic'
import type { IReport } from '~/types/apis/report'
import type { ColumnsType } from 'ant-design-vue/es/table'

const props = defineProps<{
  reportType: 'stress' | 'api' | 'ui'
}>()

// 统一的ID搜索字段（用于输入用例ID或报告ID）
const idSearchValue = ref<string>('')

const searchParams = reactive<{
  page: number
  size: number
  projectId: number | undefined
  reportId: number | undefined
  caseId: number | undefined
  name: string | undefined
  startTime: string | undefined
  endTime: string | undefined
  totalSize: number
  type: string
}>({
  page: 1,
  size: 8,
  projectId: undefined,
  reportId: undefined,
  caseId: undefined,
  name: undefined,
  type: props.reportType,
  startTime: undefined,
  endTime: undefined,
  totalSize: 0,
})

// 处理ID搜索输入，同时设置用例ID和报告ID
function handleIdSearchChange(value: string) {
  idSearchValue.value = value
  const numValue = value.trim() ? Number(value.trim()) : undefined
  if (numValue && !isNaN(numValue)) {
    // 如果输入的是有效数字，同时设置用例ID和报告ID，后端会进行OR查询
    searchParams.caseId = numValue
    searchParams.reportId = numValue
  } else {
    // 清空时，同时清空两个字段
    searchParams.caseId = undefined
    searchParams.reportId = undefined
  }
}

const columns: ColumnsType = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id',
    align: 'center',
  },
  {
    title: '报告类型',
    dataIndex: 'type',
    key: 'type',
    align: 'center',
  },
  {
    title: '用例名称',
    dataIndex: 'name',
    key: 'name',
    align: 'center',
  },
  {
    title: '摘要',
    dataIndex: 'summary',
    key: 'summary',
    align: 'center',
  },
  {
    title: '总量',
    dataIndex: 'quantity',
    key: 'quantity',
    align: 'center',
  },
  {
    title: '失败数量',
    dataIndex: 'failQuantity',
    key: 'failQuantity',
    align: 'center',
  },
  {
    title: '执行状态',
    dataIndex: 'executeState',
    key: 'executeState',
    align: 'center',
  },
  {
    title: '创建时间',
    dataIndex: 'gmtCreate',
    key: 'gmtCreate',
    align: 'center',
  },
  {
    key: 'operator',
    dataIndex: 'operator',
    title: '操作',
    align: 'center',
  },
]

const route = useRoute()
const router = useRouter()
const globalConfigStore = useGlobalConfigStore()
const {
  post: executeGetReportPage,
  data: dataSource,
  isFetching,
} = useCustomFetch<IReport[]>('/data-service/api/v1/report/page', {
  immediate: false,
  initialData: [],
  afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IReport>>) => {
    if (ctx.data && ctx.data.code === 0) {
      searchParams.totalSize = ctx.data.data.total_record
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
})

const { post: executeDeleteReport } = useCustomFetch<IReport[]>(
  '/data-service/api/v1/report/del',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IReport>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '删除成功！')
      }
      return ctx
    },
  },
)

const { post: executeBatchDeleteReport } = useCustomFetch<IReport[]>(
  '/data-service/api/v1/report/batchDel',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IReport>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(`成功删除 ${ctx.data.data ?? 0} 条测试报告！`)
      }
      return ctx
    },
  },
)

// 选中的行
const selectedRowKeys = ref<number[]>([])

async function reFetch() {
  await nextTick()
  executeGetReportPage(objectOmit(toRaw(searchParams), ['totalSize'])).execute()
  // 清空选中状态（因为数据可能已变化）
  selectedRowKeys.value = []
}

function resetSearchParams() {
  // 重置页码为第一页
  searchParams.page = 1
  // 根据报告类型设置正确的 type（'api' -> 'API', 'ui' -> 'UI', 'stress' -> 'STRESS'）
  searchParams.type = props.reportType.toUpperCase()
  // 不清空 projectId，保留当前项目ID（因为测试报告是按项目查询的）
  // searchParams.projectId = undefined  // 注释掉，不清空项目ID
  // 只清空搜索条件
  idSearchValue.value = ''
  searchParams.reportId = undefined
  searchParams.caseId = undefined
  searchParams.name = undefined
  searchParams.startTime = undefined
  searchParams.endTime = undefined
  // 重新获取数据（会使用保留的 projectId 和正确的 type）
  reFetch()
}

function handleOpenDetail(record: IReport) {
  router.push(
    handleParams(
      `/report/${
        props.reportType === 'api' ? 'interface' : props.reportType
      }/details`,
      {
        id: record.id,
        type: record.type,
      },
    ),
  )
}

function handleSummary(record: IReport) {
  return Object.entries(JSON.parse(record.summary))
}

async function handleDelete(record: IReport) {
  await executeDeleteReport({
    id: record.id,
    type: record.type,
    projectId: searchParams.projectId,
  }).execute()
  // 如果删除的记录在选中列表中，从选中列表中移除
  const index = selectedRowKeys.value.indexOf(record.id)
  if (index > -1) {
    selectedRowKeys.value.splice(index, 1)
  }
  reFetch()
}

// 表格行选择变化
function handleSelectChange(keys: number[]) {
  selectedRowKeys.value = keys
}

// 批量删除
async function handleBatchDelete() {
  if (selectedRowKeys.value.length === 0) {
    message.warning('请至少选择一条记录！')
    return
  }

  try {
    await executeBatchDeleteReport({
      ids: selectedRowKeys.value,
      type: searchParams.type,
      projectId: searchParams.projectId,
    }).execute()
    // 清空选中状态
    selectedRowKeys.value = []
    // 刷新数据
    reFetch()
  } catch (error) {
    console.error('批量删除失败:', error)
    message.error('批量删除失败，请稍后重试')
  }
}

const downloadExcel = async () => {
  try {
    const response = await axios.get(
      'http://120.25.217.15:8000/data-service/api/v1/report/export',
      {
        params: {
          type: props.reportType,
          projectId: searchParams.projectId,
          name: searchParams.name,
          startTime: searchParams.startTime,
          endTime: searchParams.endTime,
        },
        responseType: 'blob', // 指定响应类型为 Blob
        headers: {
          satoken: globalConfigStore.loginToken,
        },
      },
    )

    // 创建 Excel 文件的 Blob 对象
    const blob = new Blob([response.data], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    })

    // 生成 Excel 文件的 URL
    const excelDownloadUrl = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.style.display = 'none'
    link.href = excelDownloadUrl
    link.setAttribute('download', `${props.reportType}测试列表.xlsx`)
    document.body.append(link)
    link.click()
    URL.revokeObjectURL(link.href) // 释放URL 对象
    link.remove()
  } catch (error) {
    console.error('下载 Excel 出错：', error)
  }
}

watchImmediate(
  () => globalConfigStore.config.projectId,
  () => {
    if (globalConfigStore.config.projectId === -1) {
      return
    }
    searchParams.page = 1
    searchParams.projectId = globalConfigStore.config.projectId
    reFetch()
  },
)

onMounted(() => {
  if (route.query?.projectId) {
    searchParams.projectId = Number(route.query.projectId)
    if (route.query?.caseId) {
      const caseIdValue = Number(route.query.caseId)
      searchParams.caseId = caseIdValue
      // 同步到统一搜索框
      idSearchValue.value = String(caseIdValue)
      if (route.query?.type) {
        searchParams.type = route.query.type as string
      }
      reFetch()
    }
  }
})
</script>

<template>
  <div>
    <div flex="~ justify-between items-start">
      <Form layout="inline" autocomplete="off" mb style="flex: 1">
        <Form.Item label="报告类型">
          <span style="font-weight: 500">
            {{
              reportType === 'ui'
                ? '功能'
                : reportType === 'api'
                  ? '接口'
                  : '压力'
            }}
          </span>
        </Form.Item>

        <Form.Item label="用例/报告 ID">
          <Input
            :value="idSearchValue"
            @update:value="handleIdSearchChange"
            placeholder="用例ID或报告ID"
            style="width: 140px"
            allow-clear
          />
        </Form.Item>

        <Form.Item label="用例名称">
          <Input
            v-model:value="searchParams.name"
            placeholder="请输入用例名称"
            style="width: 180px"
            allow-clear
          />
        </Form.Item>

        <Form.Item label="开始时间">
          <DatePicker
            v-model:value="searchParams.startTime"
            show-time
            value-format="YYYY-MM-DD HH:mm:ss"
            type="date"
            placeholder="开始时间"
            style="width: 180px"
          />
        </Form.Item>

        <Form.Item label="结束时间">
          <DatePicker
            v-model:value="searchParams.endTime"
            show-time
            value-format="YYYY-MM-DD HH:mm:ss"
            type="date"
            placeholder="结束时间"
            style="width: 180px"
          />
        </Form.Item>

        <Form.Item>
          <Button type="primary" @click="reFetch()"> 搜索 </Button>
        </Form.Item>

        <Form.Item>
          <Button @click="resetSearchParams()"> 清空 </Button>
        </Form.Item>
      </Form>

      <div flex="~ items-center gap-2">
        <span v-if="selectedRowKeys.length > 0" text="sm gray-600 font-500">
          已选择 {{ selectedRowKeys.length }} 条记录
        </span>
        <Popconfirm
          v-if="selectedRowKeys.length > 0"
          :title="`确定要删除选中的 ${selectedRowKeys.length} 条测试报告吗？（此操作不可逆！）`"
          ok-text="确定"
          cancel-text="取消"
          @confirm="handleBatchDelete"
        >
          <Button type="primary" danger size="small">
            批量删除
          </Button>
        </Popconfirm>
        <Button type="dashed" size="small" @click="reFetch()">刷新</Button>
        <Button type="dashed" size="small" @click="downloadExcel()">导出</Button>
      </div>
    </div>
    <Table
      :loading="isFetching"
      :data-source="dataSource!"
      :columns="columns"
      :row-selection="{
        selectedRowKeys: selectedRowKeys,
        onChange: handleSelectChange,
        columnWidth: 50,
      }"
      :pagination="{
        showLessItems: true,
        current: searchParams.page,
        pageSize: searchParams.size,
        total: searchParams.totalSize,
        onChange(page, pageSize) {
          searchParams.page = page
          searchParams.size = pageSize
          // 切换页码时清空选中状态
          selectedRowKeys.value = []
          reFetch()
        },
      }"
      row-key="id"
    >
      <template #bodyCell="{ column, record, value }">
        <template
          v-if="['gmtCreate', 'gmtModified'].includes(column.key!.toString())"
        >
          {{ dayjs(record[column.key!]).format('YYYY-MM-DD - HH:mm:ss') }}
        </template>

        <!-- 执行状态字段：将英文枚举值转换为中文 -->
        <template v-else-if="column.key === 'executeState'">
          <Tooltip :title="value" placement="topLeft">
            <span style="cursor: pointer">
              {{
                value === 'EXECUTE_SUCCESS'
                  ? '执行成功'
                  : value === 'EXECUTE_FAIL'
                    ? '执行失败'
                    : value === 'EXECUTING'
                      ? '执行中'
                      : value === 'COUNTING_REPORT'
                        ? '统计中'
                        : value || '-'
              }}
            </span>
          </Tooltip>
        </template>

        <!-- 报告类型字段：将英文类型转换为中文 -->
        <template v-else-if="column.key === 'type'">
          <Tooltip :title="value" placement="topLeft">
            <span style="cursor: pointer">
              {{
                value === 'API'
                  ? '接口'
                  : value === 'UI'
                    ? 'UI'
                    : value === 'STRESS'
                      ? '压力'
                      : value || '-'
              }}
            </span>
          </Tooltip>
        </template>

        <template v-else-if="column.key === 'summary'">
          <span v-if="!record[column.key!]"> - </span>
          <div v-else grid="~ cols-2 gap-2">
            <div
              v-for="[key, value] in handleSummary(record as IReport)"
              :key="key"
              b="~ solid #333 op-75"
              rounded-2
            >
              <span>{{ key }}:</span>
              <span font-450>{{ value }}</span>
            </div>
          </div>
        </template>

        <template v-else-if="column.key === 'operator'">
          <Button type="link" @click="handleOpenDetail(record as IReport)">
            详情
          </Button>
          <Popconfirm
            title="你确定要删除这个测试报告吗？（此操作不可逆！）"
            @confirm="handleDelete(record as IReport)"
          >
            <Button type="link" danger>删除</Button>
          </Popconfirm>
        </template>

        <!-- 其他字段使用 Tooltip 显示完整内容 -->
        <template v-else-if="value && value !== ''">
          <Tooltip :title="String(value)" placement="topLeft">
            <span style="cursor: pointer">{{ value }}</span>
          </Tooltip>
        </template>

        <template v-else-if="value == null || value === ''"> - </template>
      </template>
    </Table>
  </div>
</template>
