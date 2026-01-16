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
}

function getCurrentEditableInstance() {
  return !currentEditableInstance.value
    ? currentEditableInstance.value
    : simplyObjectDeepClone(currentEditableInstance.value)
}

function handleDeleteIndex(index: number) {
  emits('delete', simplyObjectDeepClone(dataSourceProxy.value[index]))
  dataSourceProxy.value.splice(index, 1)
}

function handleSaved() {
  if (
    Object.entries(currentEditableInstance.value)
      .filter(([key]) => !customFields.value.includes(key))
      .some(([, value]) => !value)
  ) {
    message.warning('请填写完整信息')
    return
  }
  emits('save', getCurrentEditableInstance(), currentState.value === 'new')

  currentState.value = 'saved'
  editIndex.value = -1
}

function handleCancel() {
  if (currentState.value === 'new') {
    dataSourceProxy.value.pop()
  }
  editIndex.value = -1
  currentState.value = 'default'
}

function handleAddData() {
  if (['editable', 'new'].includes(currentState.value ?? '')) {
    message.warn('清先保存现在编辑的实例')
    return
  }
  emits('addData')

  handleEditIndex(dataSourceProxy.value.length - 1, true)
}
</script>

<template>
  <div>
    <Table v-bind="$attrs" :data-source="dataSourceProxy">
      <template #bodyCell="{ index, column, record, text, value }">
        <template
          v-if="
            editIndex === index &&
            !customFieldsWithDefault.includes(column.key?.toString() ?? '')
          "
        >
          <Input v-model:value="record[column.key!]" />
        </template>

        <template
          v-if="typeof record[column.key?.toString() ?? ''] === 'boolean'"
        >
          <Switch v-model:checked="record[column.key!]" />
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
