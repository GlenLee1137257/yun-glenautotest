<script lang="ts" setup>
import type { ColumnsType } from 'ant-design-vue/es/table/Table'


const props = defineProps<{
  keyName: string
  keyTitle: string
  valueName: string
  valueTitle: string
}>()

const { keyName, keyTitle, valueName, valueTitle } = toRefs(props)

const dataSource = defineModel<object[]>('dataSource', {
  required: true,
})

const coloums = reactive<ColumnsType<any>>([
  {
    align: 'center',
    key: keyName.value,
    title: keyTitle.value,
    dataIndex: keyName.value,
  },
  {
    align: 'center',
    key: valueName.value,
    title: valueTitle.value,
    dataIndex: valueName.value,
  },
  {
    align: 'center',
    key: 'operator',
    dataIndex: 'operator',
    title: '操作',
  },
])

function handleAddData() {
  dataSource.value.push({
    [keyName.value]: '',
    [valueName.value]: '',
  })
}
</script>

<template>

  <EditableTable
    v-model:data-source-proxy="dataSource"
    :columns="coloums"
    @add-data="handleAddData"
  />
</template>
