<script lang="ts" setup generic="T extends Record<string, string | number>">
import { message } from 'ant-design-vue'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { ProjectTableNeeds } from '~/types/apis/project'

const props = withDefaults(
  defineProps<{
    baseName: string
    localizeName: string
    columns: ColumnsType<ProjectTableNeeds>
    loadingWithGetDataSource: boolean
    customFields?: string[]
  }>(),
  {
    customFields: () => [],
  },
)

const globalConfig = useGlobalConfigStore()
const dataSource = defineModel<T[]>('dataSource', { required: true })

const { baseName } = toRefs(props)

const emits = defineEmits<{
  (e: 'refreshData'): void
}>()

const { post: fetchUpdateProject } = useCustomFetch(
  `/engine-service/api/v1/${baseName.value}/update`,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '保存成功')
      }
      return ctx
    },
  },
)

const { post: fetchCreateProject } = useCustomFetch(
  `/engine-service/api/v1/${baseName.value}/save`,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '创建成功')
      }
      return ctx
    },
  },
)

const { post: fetchDeleteProject } = useCustomFetch(
  `/engine-service/api/v1/${baseName.value}/del`,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '删除成功')
      }
      return ctx
    },
  },
)

async function handleSave(instance: T, isNew?: boolean) {
  if (isNew) {
    await fetchCreateProject(instance).execute()
  } else {
    await fetchUpdateProject(instance).execute()
  }
  emits('refreshData')
}

function handleCreate() {
  dataSource.value.push({
    // eslint-disable-next-line unicorn/prefer-at
    id: Number(dataSource.value?.[dataSource.value.length - 1]?.id ?? 0) + 1,
    projectId: globalConfig.config.projectId,
  } as any)
}

async function handleDelete(instance: T) {
  await fetchDeleteProject({ id: instance.id }).execute()
  emits('refreshData')
}
</script>

<template>
  <div>
    <h1 my>{{ localizeName }}管理:</h1>
    <EditableTable
      v-model:data-source-proxy="dataSource"
      :loading="loadingWithGetDataSource"
      :custom-fields="customFields"
      :columns="columns"
      @save="handleSave"
      @add-data="handleCreate"
      @delete="handleDelete"
    />
  </div>
</template>
