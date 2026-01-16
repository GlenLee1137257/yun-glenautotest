<script lang="ts" setup>
import { Button } from 'ant-design-vue'
import type { ComponentExposed } from 'vue-component-type-helpers'
import type { IApiCaseExecuteList } from '~/types/apis/execute'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type ExecuteModalVue from '~/components/Execute/ExecuteModal.vue'

const columns = reactive<ColumnsType<any>>([
  {
    key: 'id',
    title: 'ID',
    dataIndex: 'id',
  },
  {
    key: 'name',
    title: '接口名称',
    dataIndex: 'name',
  },
  {
    key: 'description',
    title: '接口描述',
    dataIndex: 'description',
  },
  {
    key: 'level',
    title: '等级',
    dataIndex: 'level',
  },

  {
    key: 'moduleId',
    title: '模块Id',
    dataIndex: 'moduleId',
  },
  {
    key: 'gmtCreate',
    title: '创建时间',
    dataIndex: 'gmtCreate',
  },
  {
    key: 'gmtModified',
    title: '更新时间',
    dataIndex: 'gmtModified',
  },
  {
    key: 'operation',
    title: '操作',
    dataIndex: 'operation',
  },
])

const executeModalRef = ref<ComponentExposed<typeof ExecuteModalVue>>()

const visibleModel = ref(false)
const executeId = ref<number>(-1)
const executeModalColumnsBefore: ColumnsType<any> = [
  {
    key: 'name',
    title: '接口名称',
    dataIndex: 'name',
    align: 'center',
  },
  {
    key: 'path',
    title: '接口地址',
    dataIndex: 'path',
    align: 'center',
  },
  {
    key: 'description',
    title: '步骤描述',
    dataIndex: 'description',
    align: 'center',
  },
]

const executeModalColumnsAfter: ColumnsType<any> = [
  {
    key: 'response',
    title: '接口响应',
    dataIndex: 'response',
    align: 'center',
  },
]

function handleExecute(id: number) {
  executeId.value = id
  visibleModel.value = true
}

function handleClickForOpenResponseModal(
  content: [
    IApiCaseExecuteList['responseHeader'],
    IApiCaseExecuteList['responseBody'],
  ],
) {
  let resultContent = ''
  const [header, body] = content

  function appendContent(content: string, space: boolean = true) {
    resultContent += `${space ? '  ' : ''}${content}\n`
  }

  appendContent('请求头：', false)
  header.forEach((item) => {
    appendContent(`${item.name}: ${item.value}`)
  })
  appendContent('请求体: ', false)
  if (body === '') appendContent('空')
  else
    for (const line of JSON.stringify(JSON.parse(body), null, 2).split('\n'))
      appendContent(line)

  executeModalRef.value?.setModalDetails('接口响应', resultContent.trim())
}
</script>

<template>
  <ExecuteModal
    ref="executeModalRef"
    v-model:execute-id="executeId"
    v-model:visible-model="visibleModel"
    :expand-columns-after="executeModalColumnsAfter"
    :expand-columns-before="executeModalColumnsBefore"
    base-name="api"
  >
    <template #bodyCell="{ record, column }">
      <template v-if="column.key === 'response'">
        <Button
          @click="
            handleClickForOpenResponseModal([
              record.responseHeader,
              record.responseBody,
            ])
          "
        >
          查看详情
        </Button>
      </template>
    </template>
  </ExecuteModal>

  <TableModal base-name="api_case" localized-name="接口用例" :columns="columns">
    <template #bodyCell="{ column, record }">
      <span
        v-if="
          ['isSyncSession', 'isSyncCookie'].includes(column.key!.toString())
        "
      >
        {{ record.isSyncSession ? '是' : '否' }}
      </span>
    </template>
    <template #operation="{ record }">
      <Button type="link" @click="handleExecute(record.id)">执行</Button>
    </template>
  </TableModal>
</template>
