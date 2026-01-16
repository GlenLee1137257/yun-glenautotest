<script lang="ts" setup>
import dayjs from 'dayjs'
import {
  Button,
  DatePicker,
  Divider,
  Dropdown,
  Form,
  Input,
  Menu,
  Modal,
  Popconfirm,
  Table,
  message,
} from 'ant-design-vue'
import { type AfterFetchContext, objectOmit } from '@vueuse/core'
import type { IBasicWithPage } from '~/types/apis/basic'
import type { ITimePlan } from '~/types/apis/time-plan'
import type { ColumnsType } from 'ant-design-vue/es/table'

const searchParams = reactive<{
  page: number
  size: number
  projectId: number | undefined
  name: string | undefined
  totalSize: number
}>({
  page: 1,
  size: 8,
  projectId: undefined,
  name: undefined,
  totalSize: 0,
})

const testTypeList = reactive<Array<{
  id: number
  type: string
}>>([
  {
    id: 1,
    type: 'STRESS',
  },
  {
    id: 2,
    type: 'API',
  },
  {
    id: 1,
    type: 'UI',
  },
])

const columns: ColumnsType = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id',
    align: 'center',
  },
  {
    title: '名称',
    dataIndex: 'name',
    key: 'name',
    align: 'center',
  },
  {
    title: '用例类型',
    dataIndex: 'testType',
    key: 'testType',
    align: 'center',
  },
  {
    title: '用例 ID',
    dataIndex: 'caseId',
    key: 'caseId',
    align: 'center',
  },
  {
    title: '执行时间',
    dataIndex: 'executeTime',
    key: 'executeTime',
    align: 'center',
  },
  {
    title: '状态',
    dataIndex: 'isDisabled',
    key: 'isDisabled',
    align: 'center',
  },
  {
    key: 'operator',
    dataIndex: 'operator',
    title: '操作',
    align: 'center',
  },
]

const globalConfigStore = useGlobalConfigStore()

const {
  post: executeGetTestPage,
  data: dataSource,
  isFetching,
} = useCustomFetch<ITimePlan[]>('/engine-service/api/v1/plan_job/page', {
  immediate: false,
  initialData: [],
  afterFetch: (ctx: AfterFetchContext<IBasicWithPage<ITimePlan[]>>) => {
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

async function reFetch() {
  await nextTick()
  executeGetTestPage(toRaw(searchParams)).execute()
}

//删除
const { post: executeDeleteReport } = useCustomFetch<ITimePlan[]>(
  '/engine-service/api/v1/plan_job/del',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<ITimePlan>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '删除成功！')
      }
      return ctx
    },
  },
)

async function handleDelete(record: ITimePlan) {
  await executeDeleteReport({
    id: record.id,
    projectId: record.projectId,
  }).execute()
  reFetch()
}

//编辑
const openUpdate = ref<boolean>(false)
const oneUpdateValue = reactive<ITimePlan>({
  id: 0,
  projectId: 0,
  executeTime: '',
  gmtModified: '',
  gmtCreate: '',
  name: '',
  caseId: 0,
  testType: '',
  isDisabled: 0,
})
const handleSelectUpdateTypeList = (type: string) => {
  oneUpdateValue.testType = type
}

const toggleDisabledStatus = () => {
  oneUpdateValue.isDisabled = oneUpdateValue.isDisabled === 0 ? 1 : 0
}
function formatToCustomFormat(dateString: string) {
  return dayjs(dateString).format('YYYY-MM-DD HH:mm:ss')
}

const handleOpenUpdate = (updateValue: ITimePlan) => {
  const { executeTime, ...rest } = updateValue
  oneUpdateValue.executeTime = executeTime
    ? formatToCustomFormat(executeTime)
    : ''
  Object.assign(oneUpdateValue, rest)
  openUpdate.value = true
}
const { post: handleUpdateValue } = useCustomFetch<ITimePlan[]>(
  '/engine-service/api/v1/plan_job/update',
  {
    immediate: false,
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<ITimePlan>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '修改成功！')
        reFetch()
      }
      return ctx
    },
  },
)

const handleUpdate = async () => {
  await handleUpdateValue(toRaw(oneUpdateValue)).execute()
  openUpdate.value = false
}

//新增
const openAdd = ref<boolean>(false)
const oneAddValue = reactive<ITimePlan>({
  id: 0,
  projectId: 0,
  executeTime: '',
  gmtModified: '',
  gmtCreate: '',
  name: '',
  caseId: 0,
  testType: '',
  isDisabled: 1,
})

const handleSelectTypeList = (type: string) => {
  oneAddValue.testType = type
}
const cancelClick = () => {
  oneAddValue.id = 0
  oneAddValue.projectId = 0
  oneAddValue.executeTime = ''
  oneAddValue.gmtModified = ''
  oneAddValue.gmtCreate = ''
  oneAddValue.name = ''
  oneAddValue.caseId = 0
  oneAddValue.testType = ''
  oneAddValue.isDisabled = 1
}

const AddTestPlan = () => {
  openAdd.value = true
}
const toggleADDDisabledStatus = () => {
  oneAddValue.isDisabled = oneAddValue.isDisabled === 0 ? 1 : 0
}
const { post: handleAddValue } = useCustomFetch<ITimePlan[]>(
  '/engine-service/api/v1/plan_job/save',
  {
    immediate: false,
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<ITimePlan>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '新增成功！')
        reFetch()
      }
      return ctx
    },
  },
)

const handleAdd = async () => {
  await handleAddValue(toRaw(oneAddValue)).execute()
  oneAddValue.id = 0
  oneAddValue.projectId = 0
  oneAddValue.executeTime = ''
  oneAddValue.gmtModified = ''
  oneAddValue.gmtCreate = ''
  oneAddValue.name = ''
  oneAddValue.caseId = 0
  oneAddValue.testType = ''
  oneAddValue.isDisabled = 1
  openAdd.value = false
}

watchImmediate(
  () => globalConfigStore.config.projectId,
  () => {
    if (globalConfigStore.config.projectId === -1) {
      return
    }
    searchParams.page = 1
    searchParams.projectId = globalConfigStore.config.projectId
    // reFetch()
  },
)
onMounted(() => {
  reFetch()
})
</script>

<template>
  <div>
    <div flex="~ justify-between">
      <div flex="~ justify-between" style="width: 300px">
        <Form.Item label="名称">
          <Input
            v-model:value="searchParams.name"
            placeholder="无"
            style="width: 180px"
            @keyup.enter="reFetch()"
          />
        </Form.Item>
        <Form.Item>
          <Button type="primary" @click="reFetch()"> 搜索 </Button>
        </Form.Item>
      </div>
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
        <template v-if="column.key === 'executeTime'">
          {{ dayjs(record[column.key]).format('YYYY-MM-DD - HH:mm:ss') }}
        </template>

        <template v-if="column.key === 'isDisabled'">
          <span>{{ record.isDisabled ? '禁用' : '启用' }}</span>
        </template>

        <template v-if="column.key === 'operator'">
          <Button type="link" @click="handleOpenUpdate(record as ITimePlan)">
            编辑
          </Button>
          <Popconfirm
            title="你确定要删除这个用例吗？（此操作不可逆！）"
            @confirm="handleDelete(record as ITimePlan)"
          >
            <Button type="link" danger>删除</Button>
          </Popconfirm>
        </template>
      </template>
    </Table>
    <div flex items-center>
      <Button type="link" @click="AddTestPlan">+ 新增计划</Button>
    </div>
    <!-- 编辑 -->
    <Modal v-model:open="openUpdate" title="编辑用例" @ok="handleUpdate">
      <div style="">
        <Form
          layout="inline"
          :label-col="{ span: 8 }"
          :wrapper-col="{ span: 16 }"
          autocomplete="off"
          style="
            display: flex;
            height: 200px;
            flex-direction: column;
            justify-content: space-around;
          "
        >
          <Form.Item label="名称：">
            <Input
              v-model:value="oneUpdateValue.name"
              placeholder=""
              style="width: 200px"
            />
          </Form.Item>
          <Form.Item label="用例ID：">
            <Input
              v-model:value="oneUpdateValue.caseId"
              placeholder=""
              style="width: 200px"
            />
          </Form.Item>
          <Form.Item label="执行时间：">
            <DatePicker
              v-model:value="oneUpdateValue.executeTime"
              show-time
              value-format="YYYY-MM-DD HH:mm:ss"
              type="date"
            />
          </Form.Item>
          <Form.Item label="状态：">
            <span
              >{{
                !oneUpdateValue.isDisabled ? '禁用' : '激活'
              }}&nbsp;&nbsp;</span
            >
            <Button type="primary" size="small" @click="toggleDisabledStatus">{{
              oneUpdateValue.isDisabled ? '禁用' : '启用'
            }}</Button>
          </Form.Item>
          <Form.Item label="用例类型：">
            <Dropdown>
              <Button type="link">
                {{
                  oneUpdateValue.testType
                    ? oneUpdateValue.testType
                    : '请选择用例类型'
                }}
              </Button>
              <template #overlay>
                <Menu>
                  <Menu.Item v-for="item in testTypeList" :key="item.id">
                    <Button
                      type="text"
                      size="small"
                      @click="handleSelectUpdateTypeList(item.type)"
                    >
                      {{ item.type }}
                    </Button>
                  </Menu.Item>
                </Menu>
              </template>
            </Dropdown>
          </Form.Item>
        </Form>
      </div>
    </Modal>
    <!-- 新增 -->
    <Modal
      v-model:open="openAdd"
      title="新增用例"
      @ok="handleAdd"
      @cancel="cancelClick"
    >
      <div style="">
        <Form
          layout="inline"
          :label-col="{ span: 8 }"
          :wrapper-col="{ span: 16 }"
          autocomplete="off"
          style="
            display: flex;
            height: 200px;
            flex-direction: column;
            justify-content: space-around;
          "
        >
          <Form.Item label="名称：">
            <Input
              v-model:value="oneAddValue.name"
              placeholder=""
              style="width: 200px"
            />
          </Form.Item>
          <Form.Item label="用例ID：">
            <Input
              v-model:value="oneAddValue.caseId"
              placeholder=""
              style="width: 200px"
            />
          </Form.Item>
          <Form.Item label="执行时间：">
            <DatePicker
              v-model:value="oneAddValue.executeTime"
              show-time
              value-format="YYYY-MM-DD HH:mm:ss"
              type="date"
            />
          </Form.Item>
          <Form.Item label="状态：">
            <span
              >{{ !oneAddValue.isDisabled ? '禁用' : '激活' }}&nbsp;&nbsp;</span
            >
            <Button
              type="primary"
              size="small"
              @click="toggleADDDisabledStatus"
              >{{ oneAddValue.isDisabled ? '禁用' : '启用' }}</Button
            >
          </Form.Item>
          <Form.Item label="用例类型：">
            <Dropdown>
              <Button type="link">
                {{
                  oneAddValue.testType ? oneAddValue.testType : '请选择用例类型'
                }}
              </Button>
              <template #overlay>
                <Menu>
                  <Menu.Item v-for="item in testTypeList" :key="item.id">
                    <Button
                      type="text"
                      size="small"
                      @click="handleSelectTypeList(item.type)"
                    >
                      {{ item.type }}
                    </Button>
                  </Menu.Item>
                </Menu>
              </template>
            </Dropdown>
          </Form.Item>
        </Form>
      </div>
    </Modal>
  </div>
</template>
