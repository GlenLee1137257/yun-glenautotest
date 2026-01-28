<script lang="ts" setup>
import { Button, message } from 'ant-design-vue'
import { handleParams } from '../../../utils/internal'
import type { IBasic } from '~/types/apis/basic'
import type { AfterFetchContext } from '@vueuse/core'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { IModule } from '~/types/apis/module'
import type { IStressCase } from '~/types/apis/stress-case'

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
    title: '描述',
    dataIndex: 'description',
    key: 'description',
    align: 'center',
  },
  {
    title: '压力源类型',
    dataIndex: 'stressSourceType',
    key: 'stressSourceType',
    align: 'center',
  },
  {
    title: '创建时间',
    dataIndex: 'gmtCreate',
    key: 'gmtCreate',
    align: 'center',
  },
  {
    title: '修改时间',
    dataIndex: 'gmtModified',
    key: 'gmtModified',
    align: 'center',
  },
  {
    title: '操作',
    dataIndex: 'operation',
    key: 'operation',
    align: 'center',
  },
]

const router = useRouter()
const { config } = storeToRefs(useGlobalConfigStore())
const { selectedModuleId } = storeToRefs(useTemporaryStore())

const fetchFindTableDataSourceUrl = computed(() => {
  return handleParams('/engine-service/api/v1/stress_case_module/find', {
    moduleId: selectedModuleId.value,
  })
})
const { execute, data, isFetching } = useCustomFetch<IStressCase[]>(
  fetchFindTableDataSourceUrl,
  {
    immediate: false,
    initialData: [],
    afterFetch(ctx: AfterFetchContext<IBasic<IModule<IStressCase>>>) {
      if (ctx.data && ctx.data.code === 0) {
        return {
          data: ctx.data.data.list,
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

const fetchExecuteStressCaseUrlId = ref<number>()
const fetchExecuteStressCaseUrl = computed(() => {
  return handleParams('/engine-service/api/v1/stress_case/execute', {
    id: fetchExecuteStressCaseUrlId.value,
  })
})
const {
  execute: fetchExecuteStressCase,
  isFetching: isFetchingExecuteStressCase,
} = useCustomFetch(fetchExecuteStressCaseUrl, {
  immediate: false,
  afterFetch(ctx) {
    if (ctx.data && ctx.data.code === 0) {
      message.success('执行成功')
    }
    return ctx
  },
})

function handleExecute(record: IStressCase) {
  fetchExecuteStressCaseUrlId.value = record.id
  fetchExecuteStressCase()
  setTimeout(() => {
    router.push(
      handleParams('/report/stress', {
        projectId: record.projectId,
        caseId: record.id,
        type: 'STRESS ',
      }),
    )
  }, 200)
}

watch(selectedModuleId, () => {
  if (config.value.projectId) execute()
})
</script>

<template>
  <TableModal
    :loading="isFetching"
    base-name="stress_case"
    localized-name="用例"
    :columns="columns"
    :enable-batch-execution="true"
    not-fetch-default-data
    :another-table-data-source="data!"
    :loading-with-another-table-data-source="isFetching"
    @fetch-data-source="execute()"
  >
    <template #operation="{ record }">
      <Button
        :disabled="isFetchingExecuteStressCase"
        type="link"
        @click="handleExecute(record)"
        >执行</Button
      >
    </template>
  </TableModal>
</template>
