<script lang="ts" setup>
import dayjs from 'dayjs'
import {
  Button,
  DatePicker,
  Form,
  Input,
  Popconfirm,
  Table,
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

const searchParams = reactive<{
  page: number
  size: number
  projectId: number | undefined
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
  caseId: undefined,
  name: undefined,
  type: props.reportType,
  startTime: undefined,
  endTime: undefined,
  totalSize: 0,
})

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

async function reFetch() {
  await nextTick()
  executeGetReportPage(objectOmit(toRaw(searchParams), ['totalSize'])).execute()
}

function resetSearchParams() {
  searchParams.page = 1
  searchParams.type = 'STRESS'
  searchParams.projectId = undefined
  searchParams.caseId = undefined
  searchParams.name = undefined
  searchParams.startTime = undefined
  searchParams.endTime = undefined
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
  }).execute()
  reFetch()
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
      searchParams.caseId = Number(route.query.caseId)
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
    <div flex="~ justify-between">
      <Form layout="inline" autocomplete="off" mb>
        <Form.Item label="报告类型">
          <span>
            {{
              reportType === 'ui'
                ? '功能'
                : reportType === 'api'
                  ? '接口'
                  : '压力'
            }}
          </span>
        </Form.Item>

        <Form.Item label="用例 ID">
          <Input
            v-model:value="searchParams.caseId"
            placeholder="无"
            style="width: 50px"
          />
        </Form.Item>

        <Form.Item label="用例名称">
          <Input
            v-model:value="searchParams.name"
            placeholder="请输入用例名称"
            style="width: 200px"
          />
        </Form.Item>

        <Form.Item label="开始时间">
          <DatePicker
            v-model:value="searchParams.startTime"
            show-time
            value-format="YYYY-MM-DD HH:mm:ss"
            type="date"
            placeholder="开始时间"
          />
        </Form.Item>

        <Form.Item label="结束时间">
          <DatePicker
            v-model:value="searchParams.endTime"
            show-time
            value-format="YYYY-MM-DD HH:mm:ss"
            type="date"
            placeholder="结束时间"
          />
        </Form.Item>

        <Form.Item>
          <Button type="primary" @click="reFetch()"> 搜索 </Button>
        </Form.Item>

        <Form.Item>
          <Button type="primary" @click="resetSearchParams()"> 清空 </Button>
        </Form.Item>
      </Form>

      <Button type="dashed" size="small" @click="reFetch()">刷新</Button>
      <Button type="dashed" size="small" @click="downloadExcel()">导出</Button>
    </div>
    <Table
      :loading="isFetching"
      :data-source="dataSource!"
      :columns="columns"
      :pagination="{
        showLessItems: true,
        current: searchParams.page,
        pageSize: searchParams.size,
        total: searchParams.totalSize,
        onChange(page, pageSize) {
          searchParams.page = page
          searchParams.size = pageSize
          reFetch()
        },
      }"
    >
      <template #bodyCell="{ column, record }">
        <template
          v-if="['gmtCreate', 'gmtModified'].includes(column.key!.toString())"
        >
          {{ dayjs(record[column.key!]).format('YYYY-MM-DD - HH:mm:ss') }}
        </template>

        <template v-if="column.key === 'summary'">
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

        <template v-if="column.key === 'operator'">
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
      </template>
    </Table>
  </div>
</template>
