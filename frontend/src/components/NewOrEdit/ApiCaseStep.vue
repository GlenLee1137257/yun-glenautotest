<script lang="ts" setup>
import { Form, Input, InputNumber, Select, TabPane, Tooltip, Switch, Button, Modal, message, Table } from 'ant-design-vue'
import { QuestionCircleOutlined } from '@ant-design/icons-vue'
import type { ColumnsType } from 'ant-design-vue/es/table'
import {
  type IApiCaseStep,
  type IApiCaseStepAssertion,
  type IApiCaseStepRelation,
  type IApiConstantSelectOptions,
  defaultWithIApiCaseStepAssertion,
  defaultWithIApiCaseStepRelation,
} from '~/types/apis/api-case'
import type { IApi } from '~/types/apis/api'
import type RequestConfigVue from './RequestConfig.vue'
import type { ComponentExposed } from 'vue-component-type-helpers'

const props = defineProps<{
  apiConstantSelectOptions: IApiConstantSelectOptions
}>()
const selectedStep = defineModel<IApiCaseStep>('selectedStep', {
  required: true,
})

const globalConfigStore = useGlobalConfigStore()

// 接口选择器相关
const apiSelectorVisible = ref(false)
const apiModules = ref<any[]>([])
const apiList = ref<IApi[]>([])
const selectedApiName = ref('')
const selectedModuleId = ref<number>(-1)

// 获取模块列表
const { execute: fetchApiModules } = useCustomFetch<any[]>(
  '/engine-service/api/v1/api_module/list',
  {
    immediate: false,
    afterFetch(ctx) {
      if (ctx.data && ctx.data.code === 0) {
        apiModules.value = ctx.data.data
        // 默认选择第一个模块
        if (ctx.data.data.length > 0 && selectedModuleId.value === -1) {
          selectedModuleId.value = ctx.data.data[0].id
        }
        return { data: ctx.data.data, response: ctx.response }
      }
      return ctx
    },
  },
)

// 打开接口选择器
function openApiSelector() {
  fetchApiModules({ query: { projectId: String(globalConfigStore.config.projectId) } })
  apiSelectorVisible.value = true
}

// 监听模块切换，更新接口列表
watch(selectedModuleId, () => {
  if (selectedModuleId.value !== -1) {
    const module = apiModules.value.find(m => m.id === selectedModuleId.value)
    apiList.value = module?.list || []
  }
})

// 接口列表表格列
const apiColumns: ColumnsType<IApi> = [
  { title: '名称', dataIndex: 'name', key: 'name', width: 150 },
  { title: '请求方法', dataIndex: 'method', key: 'method', width: 100 },
  { title: '接口地址', dataIndex: 'path', key: 'path', width: 200 },
  { title: '描述', dataIndex: 'description', key: 'description' },
  { title: '操作', key: 'operation', width: 100, align: 'center' },
]

// 选择接口
function selectApi(api: IApi) {
  selectedStep.value.apiId = api.id
  selectedStep.value.method = api.method
  selectedStep.value.path = api.path
  selectedStep.value.environmentId = api.environmentId
  selectedStep.value.query = api.query
  selectedStep.value.header = api.header
  selectedStep.value.body = api.body
  selectedStep.value.bodyType = api.bodyType
  selectedApiName.value = api.name
  
  // 反序列化请求配置
  requestConfigRef.value!.deserialize({
    query: api.query,
    header: api.header,
    rest: api.rest,
    body: api.body,
    bodyType: api.bodyType,
  })
  
  apiSelectorVisible.value = false
  message.success(`已选择接口: ${api.name}`)
}

// 监听 useApiLibrary 变化
watch(() => selectedStep.value.useApiLibrary, (newVal) => {
  if (!newVal) {
    // 关闭接口库时，清空 apiId
    selectedStep.value.apiId = null
    selectedApiName.value = ''
  }
})

const requestConfigRef = ref<ComponentExposed<typeof RequestConfigVue>>()

// 根据字典类别和value值获取对应的中文名称
function getDictName(category: keyof IApiConstantSelectOptions, value: string): string {
  const dictList = props.apiConstantSelectOptions[category]
  const dictItem = dictList?.find((item) => item.value === value)
  return dictItem?.name ?? value
}

const columnsWithAssertion: ColumnsType<any> = [
  { title: '断言来源', dataIndex: 'from', key: 'from', width: 120 },
  { title: '断言类型', dataIndex: 'type', key: 'type', width: 120 },
  { title: '断言动作', dataIndex: 'action', key: 'action', width: 120 },
  { title: '关联表达式', dataIndex: 'express', key: 'express', width: 220 },
  { title: '预期值', dataIndex: 'value', key: 'value', width: 160 },
  { title: '说明', dataIndex: 'remark', key: 'remark', width: 200 },
  { title: '操作', dataIndex: 'operator', key: 'operator', width: 180 },
]
const dataSourceWithAssertion = ref<IApiCaseStepAssertion[]>([])

const columnsWithRelation: ColumnsType<any> = [
  { title: '关联来源', dataIndex: 'from', key: 'from', width: 150 },
  { title: '关联类型', dataIndex: 'type', key: 'type' },
  { title: '关联表达式', dataIndex: 'express', key: 'express' },
  { title: '关联变量名', dataIndex: 'name', key: 'name' },
  { title: '操作', dataIndex: 'operator', key: 'operator', width: 200 },
]
const dataSourceWithRelation = ref<IApiCaseStepRelation[]>([])

async function deserialize() {
  await nextTick()

  dataSourceWithRelation.value = objectDeserializer(
    selectedStep.value.relation,
    true,
  )
  dataSourceWithAssertion.value = objectDeserializer(
    selectedStep.value.assertion,
    true,
  )
  requestConfigRef.value!.deserialize({
    query: selectedStep.value.query,
    header: selectedStep.value.header,
    rest: selectedStep.value.rest,
    body: selectedStep.value.body,
    bodyType: selectedStep.value.bodyType,
  })
}

function serialize() {
  selectedStep.value.relation = objectSerializer(dataSourceWithRelation.value)
  selectedStep.value.assertion = objectSerializer(dataSourceWithAssertion.value)
  const { body, header, query, rest } = requestConfigRef.value!.serialize()
  selectedStep.value.body = body
  selectedStep.value.rest = rest
  selectedStep.value.query = query
  selectedStep.value.header = header
}

watch(
  selectedStep,
  async () => {
    await deserialize()
  },
  { deep: true, immediate: true },
)

defineExpose({ serialize })
</script>

<template>
  <div my-6>
    <Form :model="selectedStep">
      <Form.Item label="用例阶段名称：">
        <Input v-model:value="selectedStep.name" placeholder="请输入名称" />
      </Form.Item>
      <Form.Item label="排序：">
        <InputNumber 
          v-model:value="selectedStep.num" 
          :min="1" 
          placeholder="请输入排序号（从1开始）"
          style="width: 100%"
        />
        <div class="text-xs text-gray-500 mt-1">
          排序号可以相同，相同时按修改时间排序（修改时间越新的越先执行）
        </div>
      </Form.Item>
      <Form.Item label="用例阶段描述：">
        <Input.TextArea
          v-model:value="selectedStep.description"
          placeholder="请输入名称"
        />
      </Form.Item>

      <!-- 接口库选择开关 -->
      <Form.Item label="使用接口库：">
        <div flex="~ items-center gap-2">
          <Switch
            v-model:checked="selectedStep.useApiLibrary"
            checked-children="从接口库选择"
            un-checked-children="手动配置"
          />
          <Button
            v-if="selectedStep.useApiLibrary"
            type="primary"
            size="small"
            @click="openApiSelector"
          >
            选择接口
          </Button>
          <span v-if="selectedApiName" class="text-sm text-gray-500">
            已选择: {{ selectedApiName }}
          </span>
        </div>
        <div class="text-xs text-gray-500 mt-1">
          开启后，接口信息会自动同步接口库中的最新配置；关闭后，使用手动配置的接口信息
        </div>
      </Form.Item>

      <FormItemMethod 
        v-model:method="selectedStep.method" 
        :disabled="selectedStep.useApiLibrary"
      />
      <Form.Item label="接口地址：">
        <Input 
          v-model:value="selectedStep.path" 
          placeholder="请输入接口地址"
          :disabled="selectedStep.useApiLibrary"
        />
      </Form.Item>

      <FormItemLevel v-model:level="selectedStep.level" />

      <FormItemEnvironment
        v-model:environment-id="selectedStep.environmentId"
        :disabled="selectedStep.useApiLibrary"
      />
    </Form>

    <RequestConfig
      ref="requestConfigRef"
      v-model:body-type="selectedStep.bodyType"
    >
      <template #foot>
        <TabPane key="relation">
          <template #tab>
            <span flex="~ items-center gap-1">
              关联变量
              <Tooltip
                title="从上一步或当前响应中提取字段，保存为变量；后续步骤可在路径、查询参数、请求体、断言预期值中通过 {{变量名}} 使用。"
              >
                <QuestionCircleOutlined style="color: #999" />
              </Tooltip>
            </span>
          </template>
          <EditableTable
            v-model:data-source-proxy="dataSourceWithRelation"
            :custom-fields="['from', 'type']"
            :columns="columnsWithRelation"
            @add-data="
              dataSourceWithRelation.push({
                ...defaultWithIApiCaseStepRelation,
              })
            "
          >
            <template #bodyCell="{ column, isEdit, currentEditableInstance, record }">
              <!-- 编辑状态：显示下拉选择框 -->
              <template v-if="isEdit && column.key === 'from'">
                <Select
                  v-model:value="currentEditableInstance[column.key!]"
                  style="width: 100%"
                >
                  <Select.Option
                    v-for="item in apiConstantSelectOptions.api_relation_from"
                    :key="item.id"
                    :value="item.value"
                  >
                    <Tooltip :title="item.remark">
                      {{ item.name }}
                    </Tooltip>
                  </Select.Option>
                </Select>
              </template>

              <template v-else-if="!isEdit && column.key === 'from'">
                <!-- 非编辑状态：显示中文名称 -->
                <span>{{ getDictName('api_relation_from', record.from) }}</span>
              </template>

              <template v-if="isEdit && column.key === 'type'">
                <Select v-model:value="currentEditableInstance[column.key!]">
                  <Select.Option
                    v-for="item in apiConstantSelectOptions.api_relation_type"
                    :key="item.id"
                    :value="item.value"
                  >
                    <Tooltip :title="item.remark">
                      {{ item.name }}
                    </Tooltip>
                  </Select.Option>
                </Select>
              </template>

              <template v-else-if="!isEdit && column.key === 'type'">
                <!-- 非编辑状态：显示中文名称 -->
                <span>{{ getDictName('api_relation_type', record.type) }}</span>
              </template>
            </template>
          </EditableTable>
        </TabPane>
        <TabPane key="assertion" tab="断言">
          <EditableTable
            v-model:data-source-proxy="dataSourceWithAssertion"
            :custom-fields="['from', 'type', 'action']"
            :columns="columnsWithAssertion"
            @add-data="
              dataSourceWithAssertion.push({
                ...defaultWithIApiCaseStepAssertion,
              })
            "
          >
            <template #bodyCell="{ column, isEdit, currentEditableInstance, record }">
              <!-- 编辑状态：显示下拉选择框 -->
              <template v-if="isEdit && column.key === 'from'">
                <Select v-model:value="currentEditableInstance[column.key!]">
                  <Select.Option
                    v-for="item in apiConstantSelectOptions.api_assertion_from"
                    :key="item.id"
                    :value="item.value"
                  >
                    <Tooltip :title="item.remark">
                      {{ item.name }}
                    </Tooltip>
                  </Select.Option>
                </Select>
              </template>

              <template v-else-if="!isEdit && column.key === 'from'">
                <!-- 非编辑状态：显示中文名称 -->
                <span>{{ getDictName('api_assertion_from', record.from) }}</span>
              </template>

              <template v-if="isEdit && column.key === 'type'">
                <Select v-model:value="currentEditableInstance[column.key!]">
                  <Select.Option
                    v-for="item in apiConstantSelectOptions.api_assertion_type"
                    :key="item.id"
                    :value="item.value"
                  >
                    <Tooltip :title="item.remark">
                      {{ item.name }}
                    </Tooltip>
                  </Select.Option>
                </Select>
              </template>

              <template v-else-if="!isEdit && column.key === 'type'">
                <!-- 非编辑状态：显示中文名称 -->
                <span>{{ getDictName('api_assertion_type', record.type) }}</span>
              </template>

              <template v-if="isEdit && column.key === 'action'">
                <Select
                  v-model:value="currentEditableInstance[column.key!]"
                  style="width: 100%"
                >
                  <Select.Option
                    v-for="item in apiConstantSelectOptions.api_assertion_action"
                    :key="item.id"
                    :value="item.value"
                  >
                    <Tooltip :title="item.remark">
                      {{ item.name }}
                    </Tooltip>
                  </Select.Option>
                </Select>
              </template>

              <template v-else-if="!isEdit && column.key === 'action'">
                <!-- 非编辑状态：显示中文名称 -->
                <span>{{ getDictName('api_assertion_action', record.action) }}</span>
              </template>
            </template>
          </EditableTable>
        </TabPane>
      </template>
    </RequestConfig>
  </div>

  <!-- 接口选择器 Modal -->
  <Modal
    v-model:open="apiSelectorVisible"
    title="从接口库选择"
    width="900px"
    :footer="null"
  >
    <div class="mb-4">
      <span class="mr-2">选择模块：</span>
      <Select
        v-model:value="selectedModuleId"
        style="width: 300px"
        placeholder="请选择模块"
      >
        <Select.Option
          v-for="module in apiModules"
          :key="module.id"
          :value="module.id"
        >
          {{ module.name }} ({{ module.list?.length || 0 }}个接口)
        </Select.Option>
      </Select>
    </div>

    <Table
      :columns="apiColumns"
      :data-source="apiList"
      :pagination="{ pageSize: 10 }"
      row-key="id"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'method'">
          <span class="text-xs px-2 py-1 rounded font-semibold" :class="{
            'bg-green-100 text-green-700': record.method === 'GET',
            'bg-blue-100 text-blue-700': record.method === 'POST',
            'bg-yellow-100 text-yellow-700': record.method === 'PUT',
            'bg-red-100 text-red-700': record.method === 'DELETE',
            'bg-purple-100 text-purple-700': record.method === 'PATCH',
            'bg-gray-100 text-gray-700': !['GET', 'POST', 'PUT', 'DELETE', 'PATCH'].includes(record.method),
          }">
            {{ record.method }}
          </span>
        </template>
        <template v-if="column.key === 'operation'">
          <Button type="link" @click="selectApi(record)">选择</Button>
        </template>
      </template>
    </Table>
  </Modal>
</template>
