<script lang="ts" setup generic="T extends object">
import {
  Button,
  Input,
  Popconfirm,
  Switch,
  Table,
  message,
} from 'ant-design-vue'

type StateType = 'new' | 'editable' | 'saved' | 'default'

const props = withDefaults(
  defineProps<{
    request?: boolean
    customFields?: string[]
  }>(),
  {
    customFields: () => [],
  },
)

const { customFields } = toRefs(props)

const emits = defineEmits<{
  (e: 'addData'): void
  (e: 'save', value: T, isNew: boolean): void
  (e: 'delete', value: T): void
}>()
const dataSourceProxy = defineModel<T[]>('dataSourceProxy', { required: true })

const editIndex = ref<number>(-1)
const currentState = ref<StateType>('default')
// 保存编辑前的原始数据，用于取消时还原
const originalData = ref<T | null>(null)

const customFieldsWithDefault = computed(() => [
  ...customFields.value,
  'operator',
])

const currentEditableInstance = computed(() => {
  return dataSourceProxy.value[editIndex.value]
})

function handleEditIndex(index: number, isNew: boolean = false) {
  currentState.value = isNew ? 'new' : 'editable'
  editIndex.value = index
  // 如果是编辑现有数据（不是新增），保存原始数据的深拷贝
  if (!isNew && dataSourceProxy.value[index]) {
    originalData.value = simplyObjectDeepClone(dataSourceProxy.value[index])
  } else {
    originalData.value = null
  }
}

function getCurrentEditableInstance() {
  if (!currentEditableInstance.value) {
    return currentEditableInstance.value
  }
  return simplyObjectDeepClone(currentEditableInstance.value)
}

function handleDeleteIndex(index: number) {
  emits('delete', simplyObjectDeepClone(dataSourceProxy.value[index]))
  dataSourceProxy.value.splice(index, 1)
}

function handleSaved() {
  // 检查当前编辑实例是否存在
  if (!currentEditableInstance.value) {
    message.error('当前没有可保存的数据')
    return
  }

  // 检查必填字段 - 修改验证逻辑
  // 1. 如果当前实例有 'from' 字段（断言或关联变量），进行业务逻辑验证
  // 2. 如果没有 'from' 字段，则验证所有非自定义字段不为空
  const hasFromField = 'from' in currentEditableInstance.value
  
  if (hasFromField) {
    // 对于断言和关联变量：
    // - 当 from === 'RESPONSE_CODE' 时，express 可以为空
    // - 其他情况下，value 必填，express 根据业务判断
    const record = currentEditableInstance.value as Record<string, unknown>
    const from = record['from']
    const value = record['value']
    const name = record['name']
    
    // 断言场景：value 必填
    // 关联变量场景：name 必填
    if (value !== undefined && !value) {
      message.warning('请填写预期值')
      return
    }
    if (name !== undefined && !name) {
      message.warning('请填写变量名')
      return
    }
    
    // 当 from 不是 RESPONSE_CODE 时，express 应该填写（但不强制）
    // 这里不做强制验证，因为某些场景下 express 可能确实为空
  } else {
    // 对于没有 from 字段的普通表格，验证所有非自定义字段不为空
    // 注意：需要同时检查对象中存在的字段和可能缺失的字段
    const record = currentEditableInstance.value as Record<string, unknown>
    const fieldsToCheck = Object.entries(record)
      .filter(([key]) => !customFields.value.includes(key))
    
    // 检查是否有空字段（排除 0 和 false，因为它们是有效值）
    // 空字符串、null、undefined 都被视为空值
    const emptyFields = fieldsToCheck.filter(([, value]) => {
      // 检查是否为空：null、undefined、空字符串都视为空
      if (value === null || value === undefined || value === '') {
        return true
      }
      // 0 和 false 是有效值，不算空
      if (value === 0 || value === false) {
        return false
      }
      // 其他情况视为非空
      return false
    })
    
    if (emptyFields.length > 0) {
      message.warning('请填写完整信息')
      return
    }
  }

  const clonedInstance = getCurrentEditableInstance()
  if (!clonedInstance) {
    message.error('数据克隆失败，无法保存')
    return
  }

  emits('save', clonedInstance, currentState.value === 'new')

  currentState.value = 'saved'
  editIndex.value = -1
}

function handleCancel() {
  if (currentState.value === 'new') {
    // 新增模式：直接删除新添加的行
    dataSourceProxy.value.pop()
  } else if (currentState.value === 'editable' && originalData.value !== null) {
    // 编辑模式：还原原始数据
    const index = editIndex.value
    if (index >= 0 && index < dataSourceProxy.value.length) {
      // 直接替换整个对象，确保响应式更新
      dataSourceProxy.value[index] = simplyObjectDeepClone(originalData.value)
    }
  }
  editIndex.value = -1
  currentState.value = 'default'
  originalData.value = null
}

function handleAddData() {
  if (['editable', 'new'].includes(currentState.value ?? '')) {
    message.warn('清先保存现在编辑的实例')
    return
  }
  emits('addData')

  handleEditIndex(dataSourceProxy.value.length - 1, true)
}

/**
 * 截断文本，超过指定长度显示省略号
 * @param text 要截断的文本
 * @param maxLength 最大长度，默认60
 * @returns 截断后的文本
 */
function truncateText(text: string | number | undefined | null, maxLength: number = 60): string {
  if (text === null || text === undefined) {
    return ''
  }
  const textStr = String(text)
  if (textStr.length <= maxLength) {
    return textStr
  }
  return textStr.substring(0, maxLength) + '...'
}
</script>

<template>
  <div>
    <Table v-bind="$attrs" :data-source="dataSourceProxy">
      <template #bodyCell="{ index, column, record, text, value }">
        <!-- Boolean 类型显示 Switch -->
        <template
          v-if="typeof record[column.key?.toString() ?? ''] === 'boolean'"
        >
          <Switch v-model:checked="record[column.key!]" />
        </template>

        <!-- 编辑状态显示 Input -->
        <template
          v-else-if="
            editIndex === index &&
            !customFieldsWithDefault.includes(column.key?.toString() ?? '')
          "
        >
          <Input v-model:value="record[column.key!]" />
        </template>

        <!-- 非编辑状态显示截断文本 -->
        <template
          v-else-if="
            editIndex !== index &&
            !customFieldsWithDefault.includes(column.key?.toString() ?? '')
          "
        >
          <span :title="String(record[column.key!] ?? '')">
            {{ truncateText(record[column.key!]) }}
          </span>
        </template>

        <slot
          name="bodyCell"
          :column="column"
          :index="index"
          :record="record"
          :text="text"
          :value="value"
          :is-edit="editIndex === index"
          :current-editable-instance="currentEditableInstance"
        />

        <template v-if="column.key === 'operator'">
          <div v-show="editIndex !== index">
            <Button type="link" @click="handleEditIndex(index)">编辑</Button>
            <Popconfirm
              title="是否要删除此行？"
              @confirm="handleDeleteIndex(index)"
            >
              <Button type="link">删除</Button>
            </Popconfirm>
          </div>
          <div v-show="editIndex === index">
            <Button type="link" @click="handleSaved">保存</Button>
            <Button type="link" @click="handleCancel">取消</Button>
          </div>
        </template>
      </template>
    </Table>
    <div flex items-center>
      <Button type="link" @click="handleAddData">+ 新增</Button>
    </div>
  </div>
</template>
