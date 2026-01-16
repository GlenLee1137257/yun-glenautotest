<script
  lang="ts"
  setup
  generic="
    T extends {
      id: number
    }
  "
>
import { Button, Input, Popconfirm, Table, message } from 'ant-design-vue'
import dayjs from 'dayjs'
import type { AfterFetchContext } from '@vueuse/core'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { IModule } from '~/types/apis/module'
import type { IBasic, IBasicWithPage } from '~/types/apis/basic'

const props = withDefaults(
  defineProps<{
    baseName: string
    localizedName: string
    columns: ColumnsType<any>
    notFetchDefaultData?: boolean
    loadingWithAnotherTableDataSource?: boolean
    anotherTableDataSource?: T[]
    showEditor?: boolean
  }>(),
  {
    showEditor: false,
    notFetchDefaultData: false,
    loadingWithAnotherTableDataSource: false,
    anotherTableDataSource: () => [],
  },
)

const emits = defineEmits<{
  (e: 'fetchDataSource'): void
}>()

const { baseName, columns, notFetchDefaultData } = toRefs(props)

const globalConfigStore = useGlobalConfigStore()
const { selectedModuleId } = storeToRefs(useTemporaryStore())
const { setModules, setSelectedModuleId, setEditState } = useTemporaryStore()

const { execute: fetchApiModules, isFetching: loadingWithGetApiModules } =
  useCustomFetch<IModule[]>(
    `/engine-service/api/v1/${baseName.value}_module/list`,
    {
      immediate: false,
      async afterFetch(ctx: AfterFetchContext<IBasic<IModule[]>>) {
        if (ctx.data && ctx.data.data.length > 0) {
          const moduleId = ctx.data.data[0].id
          if (
            selectedModuleId.value === -1 ||
            !ctx.data.data.some((item) => item.id === selectedModuleId.value)
          ) {
            setSelectedModuleId(moduleId)
          }
          setModules(ctx.data.data)
        } else {
          setSelectedModuleId(-1)
          setModules([])
        }
        !notFetchDefaultData.value
          ? await fetchGetTableDataSource()
          : emits('fetchDataSource')
        return ctx
      },
    },
  )

const fetchFindTableDataSourceUrl = computed(() => {
  return handleParams(`/engine-service/api/v1/${baseName.value}_module/find`, {
    moduleId: selectedModuleId.value,
  })
})
const {
  execute: fetchGetTableDataSource,
  data: tableDataSource,
  isFetching: loadingWithGetTableDataSource,
} = useCustomFetch<T[]>(fetchFindTableDataSourceUrl, {
  immediate: false,
  initialData: [],
  afterFetch(ctx: AfterFetchContext<IBasic<IModule<T>>>) {
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
})

// const tablePagination = reactive({
//   pageNum: 0,
//   pageSize: 10,
//   moduleId: -1,
// })
// const tableDataSourceUrl = computed(() => {
//   return handleParams(
//     `/engine-service/api/v1/${baseName.value}/find`,
//     tablePagination,
//   )
// })
// const {
//   data: tableDataSource,
//   execute: fetchGetTableDataSource,
//   isFetching: loadingWithGetTableDataSource,
// } = useCustomFetch<T[]>(tableDataSourceUrl, {
//   immediate: false,
//   initialData: [],
//   afterFetch(ctx: AfterFetchContext<IBasicWithPage<T>>) {
//     if (ctx.data && ctx.data.data.current_data.length > 0) {
//       return {
//         data: ctx.data.data.current_data,
//         response: ctx.response,
//       }
//     }
//     return {
//       data: [],
//       response: ctx.response,
//     }
//   },
// })

const { post: fetchDeleteApi } = useCustomFetch<T[]>(
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

const route = useRoute()
const router = useRouter()

function pushNewOrEdit(isEdit?: boolean, record?: T) {
  router.push(
    `${route.fullPath}/new-or-edit${isEdit ? '?is-edit=true' : ''}${
      record ? `&id=${record.id}` : ''
    }`,
  )
}

function handleEdit(record: T) {
  setEditState(record)
  pushNewOrEdit(true, record)
}

async function handleDelete(id: number) {
  await fetchDeleteApi({ id }).execute()
  !notFetchDefaultData.value
    ? fetchGetTableDataSource()
    : emits('fetchDataSource')
}

watch(selectedModuleId, () => {
  !notFetchDefaultData.value
    ? fetchGetTableDataSource()
    : emits('fetchDataSource')
})

watchImmediate(
  () => globalConfigStore.config.projectId,
  async () => {
    await fetchApiModules()
  },
)
</script>

<template>
  <div
    :class="[
      loadingWithGetApiModules &&
        'opacity-50 pointer-events-none cursor-not-allowed',
    ]"
  >
    <ModuleManager
      :base-name="baseName"
      :title="localizedName"
      :selected-module-id="selectedModuleId ?? -1"
      @refresh-modules="fetchApiModules()"
    />
    <div mt>
      <div mb flex items-center justify-between>
        <div space-x-2>
          <Button type="primary" @click="pushNewOrEdit()"
            >新增{{ localizedName }}</Button
          >
          <!-- <Button type="primary">导入{{ localizedName }}</Button> -->
        </div>
        <div flex space-x-2>
          <Input placeholder="请输入ID、名称、地址" />
          <Button>搜索</Button>
          <Button type="dashed">重置</Button>
        </div>
      </div>

      <Table
        :columns="columns"
        :loading="
          !notFetchDefaultData
            ? loadingWithGetTableDataSource!
            : loadingWithAnotherTableDataSource
        "
        :data-source="
          !notFetchDefaultData ? tableDataSource! : anotherTableDataSource
        "
      >
        <template #bodyCell="{ record, column, index, text, value }">
          <slot
            name="bodyCell"
            :record="record"
            :column="column"
            :index="index"
            :text="text"
            :value="value"
          />

          <template
            v-if="['gmtCreate', 'gmtModified'].includes(column.key!.toString())"
          >
            {{
              dayjs(record[column.key as string]).format(
                'YYYY-MM-DD - HH:mm:ss',
              )
            }}
          </template>

          <template v-if="column.key === 'operation'">
            <div>
              <Button
                v-if="!showEditor"
                type="link"
                @click="handleEdit(record as T)"
                >编辑</Button
              >
              <slot
                name="operation"
                :record="record as T"
                :column="column"
                :index="index"
                :text="text"
                :value="value"
              />
              <Popconfirm
                title="确认是否删除？"
                @confirm="handleDelete((record as T).id)"
              >
                <Button type="link">删除</Button>
              </Popconfirm>
            </div>
          </template>
        </template>
      </Table>
    </div>
  </div>
</template>
