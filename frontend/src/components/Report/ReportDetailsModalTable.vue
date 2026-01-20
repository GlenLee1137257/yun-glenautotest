<script lang="ts" setup>
import { Button, Modal, Table, Tooltip } from 'ant-design-vue'
import dayjs from 'dayjs'
import JsonEditorVue from 'json-editor-vue'
import type { IBasicWithPage } from '~/types/apis/basic'
import type { AfterFetchContext } from '@vueuse/core'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { IReportDetails } from '~/types/apis/report'

defineProps<{
  columns: ColumnsType
}>()

const route = useRoute()
const pageConfig = reactive<{
  page: number
  size: number
  reportId: number | undefined
  type: string
  totalSize: number
}>({
  page: 1,
  size: 8,
  reportId: undefined,
  type: 'STRESS',
  totalSize: 0,
})

const router = useRouter()
const modalOpen = ref<boolean>()
const modalContent = ref<Record<string, any>>({})

const screenshotModalOpen = ref<boolean>()
const screenshotFileUrl = ref<string>('')
const executeScreentshotUrl = computed(
  () =>
    `/engine-service/api/v1/file/get_temp_url?fileUrl=${screenshotFileUrl.value}`,
)

const {
  post,
  data: dataSource,
  isFetching,
} = useCustomFetch<IReportDetails[]>(
  '/data-service/api/v1/report_detail/page',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IReportDetails>>) => {
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

const { data: screentshotUrl, execute: getScreenshotUrl } =
  useCustomFetch<string>(executeScreentshotUrl, {
    immediate: false,
    initialData: '',
    afterFetch(ctx) {
      return {
        data: ctx.data.data,
        response: ctx.response,
      }
    },
  })

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
</script>

<template>
  <div>
    <Button float-right mb-6 @click="router.back()">返回</Button>

    <Modal v-model:open="modalOpen" :footer="null" width="80%">
      <JsonEditorVue v-model="modalContent" read-only />
    </Modal>

    <Modal v-model:open="screenshotModalOpen" :footer="null" width="50%">
      <div b="~ solid #333" my-8 w-full rounded>
        <a :href="screentshotUrl ?? ''" target="_blank">
          <img :src="screentshotUrl ?? ''" w-full />
        </a>
      </div>
    </Modal>

    <Table
      :loading="isFetching"
      :columns="columns"
      :data-source="dataSource!"
      :scroll="{ x: 1500 }"
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
    >
      <template #bodyCell="{ column, record, value }">
        <slot :column="column" :record="record" />

        <!-- 日期时间字段 -->
        <template
          v-if="['gmtCreate', 'gmtModified'].includes(column.key!.toString())"
        >
          <Tooltip
            :title="dayjs(record[column.key as string]).format('YYYY-MM-DD - HH:mm:ss')"
            placement="topLeft"
          >
            <span style="cursor: pointer">
              {{
                dayjs(record[column.key as string]).format('YYYY-MM-DD - HH:mm:ss')
              }}
            </span>
          </Tooltip>
        </template>

        <!-- 操作按钮字段 -->
        <template v-else-if="column.key?.toString() === 'checkDetails'">
          <Button
            type="primary"
            size="small"
            @click="
              () => {
                modalOpen = true
                modalContent = record
              }
            "
          >
            查看详情
          </Button>
        </template>

        <!-- 布尔值字段（是/否） -->
        <template
          v-else-if="
            column.key === 'isContinue' || column.key === 'isScreenshot'
          "
        >
          <Tooltip :title="value ? '是' : '否'" placement="topLeft">
            <span style="cursor: pointer">{{ value ? '是' : '否' }}</span>
          </Tooltip>
        </template>

        <!-- 截图URL字段 -->
        <template v-else-if="column.key === 'screenshotUrl'">
          <Button
            v-if="value"
            type="primary"
            size="small"
            @click="
              () => {
                screenshotModalOpen = true
                screenshotFileUrl = value
                getScreenshotUrl()
              }
            "
          >
            查看
          </Button>
          <span v-else> - </span>
        </template>

        <!-- 布尔值字段（执行状态） -->
        <template v-else-if="typeof value === 'boolean'">
          <Tooltip :title="value ? '成功' : '失败'" placement="topLeft">
            <div font-bold style="cursor: pointer">
              <ExecuteState :model-value="value" />
            </div>
          </Tooltip>
        </template>

        <!-- 执行信息字段：无异常时显示“正常” -->
        <template v-else-if="column.key === 'exceptionMsg'">
          <span v-if="!value || value === ''">正常</span>
          <Tooltip v-else :title="String(value)" placement="topLeft">
            <p truncate style="cursor: pointer; margin: 0">{{ value }}</p>
          </Tooltip>
        </template>

        <!-- 耗时字段格式化显示（毫秒转换为友好格式） -->
        <template v-else-if="column.key === 'expendTime'">
          <Tooltip
            v-if="value && value > 0"
            :title="`${value}ms (${(value / 1000).toFixed(2)}s)`"
            placement="topLeft"
          >
            <span style="cursor: pointer">
              {{ value >= 1000 ? `${(value / 1000).toFixed(2)}s` : `${value}ms` }}
            </span>
          </Tooltip>
          <span v-else> - </span>
        </template>

        <!-- 所有其他有值的字段都使用 Tooltip 显示完整内容 -->
        <template v-else-if="value && value !== ''">
          <Tooltip :title="String(value)" placement="topLeft">
            <p truncate style="cursor: pointer; margin: 0">{{ value }}</p>
          </Tooltip>
        </template>

        <!-- 空值显示 -->
        <template v-else-if="value == null || value === ''"> - </template>
      </template>
    </Table>
  </div>
</template>
