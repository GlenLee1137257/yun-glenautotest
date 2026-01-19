<script lang="ts" setup generic="T extends ExexecuteList">
import { Button, Modal, Table } from 'ant-design-vue'
import { type AfterFetchContext, objectOmit } from '@vueuse/core'
import { LoadingOutlined } from '@ant-design/icons-vue'
import type { IBasic } from '~/types/apis/basic'
import type {
  ExexecuteList,
  IExexute,
  IExexuteList,
} from '~/types/apis/execute'
import type { ColumnsType } from 'ant-design-vue/es/table'

const { baseName, expandColumnsBefore, expandColumnsAfter } = withDefaults(
  defineProps<{
    baseName: string
    expandColumnsAfter?: ColumnsType<any>
    expandColumnsBefore?: ColumnsType<any>
  }>(),
  {
    expandColumnsAfter: () => [],
    expandColumnsBefore: () => [],
  },
)
const executeId = defineModel<number>('executeId', { required: true })
const visibleModel = defineModel<boolean>('visibleModel', { required: true })

const executeUrl = computed(
  () => `/engine-service/api/v1/${baseName}_case/execute?id=${executeId.value}`,
)

const {
  data: executeInfo,
  execute: fetchGetExecuteInfo,
  isFetching: loadingWithFetchExexuteInfo,
} = useCustomFetch<IExexute<T>>(executeUrl, {
  immediate: false,
  initialData: [],
  afterFetch(ctx: AfterFetchContext<IBasic<IExexute<T>>>) {
    if (ctx.data && ctx.data.code === 0) {
      return {
        data: ctx.data.data,
        response: ctx.response,
      }
    }
    return ctx
  },
})

const modalDetails = reactive({
  title: '',
  content: '',
  visible: false,
})

const columns = ref<ColumnsType<any>>([
  {
    key: 'executeState',
    dataIndex: 'executeState',
    title: '执行结果',
    align: 'center',
    width: 100,
  },
  ...expandColumnsBefore,
  {
    key: 'assertionState',
    dataIndex: 'assertionState',
    title: '断言结果',
    align: 'center',
    width: 100,
  },
  {
    key: 'exceptionMsg',
    dataIndex: 'exceptionMsg',
    title: '异常信息',
    align: 'center',
    width: 100,
  },
  {
    key: 'expendTime',
    dataIndex: 'expendTime',
    title: '耗时',
    align: 'center',
    width: 80,
  },
  ...expandColumnsAfter,
])
const dataSource = computed<(Omit<IExexuteList<T>, 'step'> & T)[]>(() => {
  if (!executeInfo.value?.list || executeInfo.value.list.length <= 0) return []

  const list = executeInfo.value.list

  return list.map((item: any) => {
    // 后端返回的字段名是 apiCaseStep（API用例）或 uiCaseStep（UI用例），前端统一使用 step
    const step = item.step || item.apiCaseStep || item.uiCaseStep
    return {
      ...objectOmit(item, ['step', 'apiCaseStep', 'uiCaseStep']),
      ...step,
    }
  })
})

watchImmediate(executeId, () => executeId.value !== -1 && fetchGetExecuteInfo())

function handleModalCancel() {
  executeId.value = -1
  visibleModel.value = false
}

function setModalDetails(title: string, content: string) {
  modalDetails.title = title
  modalDetails.content = content
  modalDetails.visible = true
}

function handleModalDetailsCancel() {
  modalDetails.title = ''
  modalDetails.content = ''
  modalDetails.visible = false
}

defineExpose({
  setModalDetails,
})
</script>

<template>
  <div>
    <Modal
      v-model:open="modalDetails.visible"
      :title="modalDetails.title"
      width="50%"
      @ok="handleModalDetailsCancel"
      @cancel="handleModalDetailsCancel"
    >
      <pre>{{ modalDetails.content }}</pre>
    </Modal>
    <Modal
      v-model:open="visibleModel"
      :footer="null"
      title="执行结果"
      width="70%"
      @cancel="handleModalCancel"
    >
      <div
        v-if="loadingWithFetchExexuteInfo"
        flex="~ items-center justify-center"
        text="20"
      >
        <LoadingOutlined />
      </div>
      <div v-else>
        <ExecuteResult :model-value="executeInfo" :base-name="baseName" />

        <Table
          :pagination="false"
          :loading="loadingWithFetchExexuteInfo"
          :columns="columns"
          :data-source="dataSource"
        >
          <template #bodyCell="{ column, record, index, text, value }">
            <template
              v-if="
                ['executeState', 'assertionState'].includes(
                  column.key?.toString() ?? '',
                )
              "
            >
              <ExecuteState :model-value="record[column.key!]" />
            </template>

            <template v-else-if="column.key === 'exceptionMsg'">
              <span v-if="record[column.key!] == null">无</span>
              <div v-else>
                <Button
                  type="primary"
                  size="small"
                  @click="
                    setModalDetails(
                      column.title as string,
                      record[column.key].toString(),
                    )
                  "
                >
                  查看详情
                </Button>
              </div>
            </template>

            <template v-else-if="column.key === 'expendTime'">
              <div>{{ record[column.key!] ?? 0 }}ms</div>
            </template>

            <template v-else-if="value">
              <p truncate>{{ value }}</p>
            </template>

            <template v-else-if="value == null || value === ''"> - </template>

            <slot
              name="bodyCell"
              :column="column"
              :record="record"
              :text="text"
              :index="index"
              :value="value"
            />
          </template>
        </Table>
      </div>
    </Modal>
  </div>
</template>
