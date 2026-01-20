<script lang="ts" setup>
import { Form, Input, Select, TabPane, Tooltip } from 'ant-design-vue'
import { QuestionCircleOutlined } from '@ant-design/icons-vue'
import {
  type IApiCaseStep,
  type IApiCaseStepAssertion,
  type IApiCaseStepRelation,
  type IApiConstantSelectOptions,
  defaultWithIApiCaseStepAssertion,
  defaultWithIApiCaseStepRelation,
} from '~/types/apis/api-case'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type RequestConfigVue from './RequestConfig.vue'
import type { ComponentExposed } from 'vue-component-type-helpers'

const props = defineProps<{
  apiConstantSelectOptions: IApiConstantSelectOptions
}>()
const selectedStep = defineModel<IApiCaseStep>('selectedStep', {
  required: true,
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
      <Form.Item label="用例阶段描述：">
        <Input.TextArea
          v-model:value="selectedStep.description"
          placeholder="请输入名称"
        />
      </Form.Item>
      <FormItemMethod v-model:method="selectedStep.method" />
      <Form.Item label="接口地址：">
        <Input v-model:value="selectedStep.path" placeholder="请输入接口地址" />
      </Form.Item>

      <FormItemLevel v-model:level="selectedStep.level" />

      <FormItemEnvironment
        v-model:environment-id="selectedStep.environmentId"
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
</template>
