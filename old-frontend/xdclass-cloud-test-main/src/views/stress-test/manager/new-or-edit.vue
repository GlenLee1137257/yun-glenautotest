<script lang="ts" setup>
import {
  Button,
  Form,
  Input,
  Select,
  Switch,
  Tooltip,
  message,
} from 'ant-design-vue'
import { type AfterFetchContext, objectOmit } from '@vueuse/core'
import {
  type IStressCase,
  type IStressCaseAssertion,
  type IStressCaseRelation,
  type IStressCaseThreadGroupConfig,
  defaultWithIStressCase,
  defaultWithIStressCaseAssertion,
  defaultWithIStressCaseRelation,
  defaultWithIStressCaseThreadGroupConfig,
} from '~/types/apis/stress-case'
import type { IDict } from '~/types/apis/dict'
import type { ComponentExposed } from 'vue-component-type-helpers'
import type NewOrEditBodyVue from '~/components/NewOrEdit/NewOrEditBody.vue'
import type { IBasic } from '~/types/apis/basic'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type RequestConfigVue from '~/components/NewOrEdit/RequestConfig.vue'

const formModelExpand = reactive<{
  relation: boolean
  assertion: boolean
  relationData: IStressCaseRelation[]
  assertionData: IStressCaseAssertion[]
  threadGroupConfig: IStressCaseThreadGroupConfig
}>({
  relation: false,
  assertion: false,
  relationData: [],
  assertionData: [],
  threadGroupConfig: { ...defaultWithIStressCaseThreadGroupConfig },
})

const router = useRouter()
const formModel = ref<IStressCase>({ ...defaultWithIStressCase })
const bodyRef = ref<ComponentExposed<typeof NewOrEditBodyVue>>()
const requestConfigRef = ref<ComponentExposed<typeof RequestConfigVue>>()

const relationColumns: ColumnsType = [
  {
    title: '名称',
    dataIndex: 'name',
    key: 'name',
    align: 'center',
  },
  {
    title: '文件类型',
    dataIndex: 'sourceType',
    key: 'sourceType',
    align: 'center',
  },
  {
    title: '分隔符',
    dataIndex: 'delimiter',
    key: 'delimiter',
    align: 'center',
  },
  {
    title: '是否忽略首行',
    dataIndex: 'ignoreFirstLine',
    key: 'ignoreFirstLine',
    align: 'center',
  },
  {
    title: '循环读取',
    dataIndex: 'recycle',
    key: 'recycle',
    align: 'center',
  },
  {
    title: '变量名称 (逗号分割)',
    dataIndex: 'variableNames',
    key: 'variableNames',
    align: 'center',
  },
  {
    title: '文件上传',
    dataIndex: 'fileUpload',
    key: 'fileUpload',
    align: 'center',
  },
  {
    title: '操作',
    dataIndex: 'operator',
    align: 'center',
    key: 'operator',
  },
]

const assertionColumns: ColumnsType = [
  {
    title: '断言名称',
    dataIndex: 'name',
    key: 'name',
    align: 'center',
  },
  {
    title: '断言操作',
    dataIndex: 'action',
    key: 'action',
    align: 'center',
  },
  {
    title: '断言来源',
    dataIndex: 'from',
    key: 'from',
    align: 'center',
  },
  {
    title: '断言值',
    dataIndex: 'value',
    key: 'value',
    align: 'center',
  },
  {
    title: '操作',
    dataIndex: 'operator',
    align: 'center',
    key: 'operator',
  },
]

const { data: fetchDictListData } = useCustomFetch<Record<string, IDict[]>>(
  '/engine-service/api/v1/dict/list?category=stress_assert_action,stress_assert_from,stress_source_type',
  {
    afterFetch(ctx: AfterFetchContext<IBasic<Record<string, IDict[]>>>) {
      if (ctx.data && ctx.data.code === 0) {
        return {
          data: ctx.data.data,
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

const { post: fetchCreateStressCase } = useCustomFetch(
  '/engine-service/api/v1/stress_case/save',
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success('保存成功')
        router.back()
      }
      return ctx
    },
  },
)

const { put: fetchUpdateStressCase } = useCustomFetch(
  '/engine-service/api/v1/stress_case/update',
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success('更新成功')
        router.back()
      }
      return ctx
    },
  },
)

function handleAddRelation() {
  formModelExpand.relationData.push({ ...defaultWithIStressCaseRelation })
}

function handleAddAssertion() {
  formModelExpand.assertionData.push({ ...defaultWithIStressCaseAssertion })
}

function handleSave() {
  if (formModel.value.stressSourceType.toUpperCase() === 'SIMPLE') {
    const { body, header, query } = requestConfigRef.value?.serialize() ?? {}
    formModel.value.body = body ?? ''
    formModel.value.query = query ?? ''
    formModel.value.header = header ?? ''

    formModel.value.threadGroupConfig = objectSerializer<
      IStressCaseThreadGroupConfig,
      false
    >(formModelExpand.threadGroupConfig)

    if (formModelExpand.assertion) {
      formModel.value.assertion = objectSerializer<
        IStressCaseAssertion[],
        false
      >(formModelExpand.assertionData)
    }

    if (formModelExpand.relation) {
      formModel.value.relation = objectSerializer<IStressCaseRelation[], false>(
        formModelExpand.relationData,
      )
    }
  }

  if (!bodyRef.value?.isEditState) {
    fetchCreateStressCase(objectOmit(formModel.value, ['id'])).execute()
  } else {
    fetchUpdateStressCase(formModel.value).execute()
  }
}

async function deserialize() {
  await nextTick()
  if (formModel.value.stressSourceType.toUpperCase() === 'SIMPLE') {
    formModelExpand.threadGroupConfig = objectDeserializer<
      IStressCaseThreadGroupConfig,
      false
    >(formModel.value.threadGroupConfig, false)

    if (formModel.value.assertion) {
      formModelExpand.assertion = true
      formModelExpand.assertionData = objectDeserializer<
        IStressCaseAssertion[],
        false
      >(formModel.value.assertion, false)
    }

    if (formModel.value.relation) {
      formModelExpand.relation = true
      formModelExpand.relationData = objectDeserializer<
        IStressCaseRelation[],
        false
      >(formModel.value.relation, false)
    }

    requestConfigRef.value?.deserialize({
      rest: '[]',
      body: formModel.value.body,
      query: formModel.value.query,
      header: formModel.value.header,
      bodyType: formModel.value.bodyType,
    })
  }
}
</script>

<template>
  <div>
    <NewOrEditBody
      ref="bodyRef"
      v-model:form-model="formModel"
      @deserialize="deserialize"
    >
      <Form :modal="formModel" layout="vertical" mx-40>
        <Form.Item label="选择压测类型：">
          <Select v-model:value="formModel.stressSourceType">
            <Select.Option
              v-for="item in fetchDictListData?.stress_source_type"
              :key="item.id"
              :value="item.value.toUpperCase()"
            >
              <Tooltip :title="item.remark">
                {{ item.name }}
              </Tooltip>
            </Select.Option>
          </Select>
        </Form.Item>

        <Form.Item label="用例名称：">
          <Input v-model:value="formModel.name" />
        </Form.Item>

        <Form.Item label="用例描述：">
          <Input v-model:value="formModel.description" />
        </Form.Item>

        <FormItemEnvironment
          v-if="formModel.stressSourceType.toUpperCase() !== 'JMX'"
          v-model:environmentId="formModel.environmentId"
          label-name="选择环境："
        />

        <Form.Item
          v-if="formModel.stressSourceType.toUpperCase() === 'JMX'"
          label="上传 JMX 脚本："
        >
          <UploadFile
            :show-url="formModel.jmxUrl"
            @change="
              $event.file.response &&
                (formModel.jmxUrl = $event.file.response.data)
            "
          >
            <Button>{{ !!formModel.jmxUrl ? '已上传' : '未上传' }}</Button>
          </UploadFile>
        </Form.Item>

        <template v-if="formModel.stressSourceType.toUpperCase() === 'SIMPLE'">
          <Form.Item label="线程组配置：">
            <div b="~ solid #333 op-75" mx-8 rounded p="x-4 t-6">
              <Form
                :modal="formModelExpand.threadGroupConfig"
                size="small"
                layout="vertical"
                grid="~ cols-4 gap-4"
              >
                <Form.Item label="线程组名称：">
                  <Input
                    v-model:value="
                      formModelExpand.threadGroupConfig.threadGroupName
                    "
                  />
                </Form.Item>
                <Form.Item label="并发数量：">
                  <Input
                    v-model:value="formModelExpand.threadGroupConfig.numThreads"
                    type="number"
                  />
                </Form.Item>
                <Form.Item label="启动时间（秒）：">
                  <Input
                    v-model:value="formModelExpand.threadGroupConfig.rampUp"
                    type="number"
                  />
                </Form.Item>
                <Form.Item label="循环次数：">
                  <Input
                    v-model:value="formModelExpand.threadGroupConfig.loopCount"
                    type="number"
                  />
                </Form.Item>
                <Form.Item label="是否开启调度器：">
                  <Switch
                    v-model:checked="
                      formModelExpand.threadGroupConfig.schedulerEnabled
                    "
                  />
                </Form.Item>
                <Form.Item label="持续时间（秒）：">
                  <Input
                    v-model:value="formModelExpand.threadGroupConfig.duration"
                    :disabled="
                      !formModelExpand.threadGroupConfig.schedulerEnabled
                    "
                    type="number"
                  />
                </Form.Item>
                <Form.Item label="启动延迟（秒）：">
                  <Input
                    v-model:value="formModelExpand.threadGroupConfig.delay"
                    :disabled="
                      !formModelExpand.threadGroupConfig.schedulerEnabled
                    "
                    type="number"
                  />
                </Form.Item>
              </Form>
            </div>
          </Form.Item>
          <Form.Item label="采样器配置：">
            <div b="~ solid #333 op-75" mx-8 rounded p="x-4 t-6">
              <div flex="~ col" gap-4>
                <span w-55px>路径</span>
                <Input v-model:value="formModel.path" />
              </div>
              <br />

              <FormItemMethod v-model:method="formModel.method" />
              <br />
              <div>
                <RequestConfig
                  ref="requestConfigRef"
                  v-model:bodyType="formModel.bodyType"
                  is-stress-test
                  key-name="key"
                />
              </div>
            </div>
          </Form.Item>
          <Form.Item label="开启断言：">
            <Switch v-model:checked="formModelExpand.assertion" />
          </Form.Item>
          <EditableTable
            v-if="formModelExpand.assertion"
            v-model:data-source-proxy="formModelExpand.assertionData"
            :columns="assertionColumns"
            :custom-fields="['action', 'from']"
            @add-data="handleAddAssertion"
          >
            <template #bodyCell="{ column, record, isEdit, value }">
              <span
                v-if="
                  !isEdit &&
                  ['action', 'from'].includes(column.key?.toString() ?? '')
                "
                >{{ value }}</span
              >

              <template v-if="column.key === 'action' && isEdit">
                <Select v-model:value="record[column.key!]">
                  <Select.Option
                    v-for="item in fetchDictListData?.stress_assert_action"
                    :key="item.id"
                    :value="item.value"
                  >
                    <Tooltip :title="item.remark">
                      {{ item.name }}
                    </Tooltip>
                  </Select.Option>
                </Select>
              </template>

              <template v-if="column.key === 'from' && isEdit">
                <Select v-model:value="record[column.key!]">
                  <Select.Option
                    v-for="item in fetchDictListData?.stress_assert_from"
                    :key="item.id"
                    :value="item.value"
                  >
                    <Tooltip :title="item.remark">
                      {{ item.name }}
                    </Tooltip>
                  </Select.Option>
                </Select>
              </template>
            </template>
          </EditableTable>
        </template>

        <Form.Item label="开启参数化：">
          <Switch v-model:checked="formModelExpand.relation" />
        </Form.Item>

        <template v-if="formModelExpand.relation">
          <EditableTable
            v-model:data-source-proxy="formModelExpand.relationData"
            :columns="relationColumns"
            :custom-fields="[
              'ignoreFirstLine',
              'recycle',
              'fileUpload',
              'sourceType',
            ]"
            @add-data="handleAddRelation"
          >
            <template
              #bodyCell="{ column, isEdit, record, currentEditableInstance }"
            >
              <template v-if="column.key === 'fileUpload'">
                <UploadFile
                  v-if="isEdit"
                  :show-url="record?.['remoteFilePath']"
                  @change="
                    $event.file.response &&
                      (currentEditableInstance.remoteFilePath =
                        $event.file.response.data)
                  "
                >
                  <Button type="link">{{
                    !!record?.['remoteFilePath'] ? '已上传' : '上传文件'
                  }}</Button>
                </UploadFile>
                <span v-else>{{
                  !!record?.['remoteFilePath'] ? '已上传' : '未上传'
                }}</span>
              </template>
            </template>
          </EditableTable>
        </template>
      </Form>
    </NewOrEditBody>
    <NewOrEditFooter name="接口" @save="handleSave" />
  </div>
</template>
