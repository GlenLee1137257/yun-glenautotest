<script lang="ts" setup>
import { Button, Modal, Table } from 'ant-design-vue'
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

        <template
          v-if="['gmtCreate', 'gmtModified'].includes(column.key!.toString())"
        >
          {{
            dayjs(record[column.key as string]).format('YYYY-MM-DD - HH:mm:ss')
          }}
        </template>

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

        <template
          v-else-if="
            column.key === 'isContinue' || column.key === 'isScreenshot'
          "
        >
          {{ value ? '是' : '否' }}
        </template>

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

        <template v-else-if="typeof value === 'boolean'">
          <div font-bold>
            <ExecuteState :model-value="value" />
          </div>
        </template>

        <template v-else-if="value">
          <p truncate>{{ value }}</p>
        </template>

        <template v-else-if="value == null || value === ''"> - </template>
      </template>
    </Table>
  </div>
</template>
