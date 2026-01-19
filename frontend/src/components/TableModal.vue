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
          // 项目切换后，总是使用新项目的第一个模块
          const moduleId = ctx.data.data[0].id
          // 如果正在切换项目，或者当前选中的模块ID不在新项目中，或者为-1，则设置为第一个模块
          const isModuleInNewProject = ctx.data.data.some(
            (item) => item.id === selectedModuleId.value,
          )
          if (
            isProjectSwitching.value ||
            selectedModuleId.value === -1 ||
            !isModuleInNewProject
          ) {
            setSelectedModuleId(moduleId)
          }
          setModules(ctx.data.data)
        } else {
          // 新项目没有模块，重置为-1并清空模块列表
          setSelectedModuleId(-1)
          setModules([])
          // 清空表格数据
          if (!notFetchDefaultData.value && tableDataSource.value) {
            tableDataSource.value = []
          }
        }
        // 只有在有模块数据时才获取接口列表
        if (ctx.data && ctx.data.data.length > 0) {
          !notFetchDefaultData.value
            ? await fetchGetTableDataSource()
            : emits('fetchDataSource')
        }
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
  try {
    await fetchDeleteApi({ 
      id,
      projectId: globalConfigStore.config.projectId 
    }).execute()
    // 删除成功后，先从本地数据源移除该项（立即更新UI）
    const index = tableDataSource.value.findIndex(item => item.id === id)
    if (index > -1) {
      tableDataSource.value.splice(index, 1)
    }
    // 等待删除操作完成，然后强制刷新数据（避免缓存问题）
    await nextTick()
    if (!notFetchDefaultData.value) {
      // 先清空数据源，强制刷新
      tableDataSource.value = []
      await nextTick()
      await fetchGetTableDataSource()
    } else {
      emits('fetchDataSource')
    }
  } catch (error) {
    console.error('删除失败:', error)
  }
}

watch(selectedModuleId, () => {
  !notFetchDefaultData.value
    ? fetchGetTableDataSource()
    : emits('fetchDataSource')
})

// 用于标记是否正在切换项目
const isProjectSwitching = ref(false)

watchImmediate(
  () => globalConfigStore.config.projectId,
  async () => {
    // 项目切换时，标记正在切换项目
    isProjectSwitching.value = true
    // 重置选中的模块ID，清空模块列表和表格数据
    setSelectedModuleId(-1)
    setModules([])
    // 清空表格数据
    if (!notFetchDefaultData.value && tableDataSource.value) {
      tableDataSource.value = []
    }
    // 重新获取新项目的模块列表
    await fetchApiModules()
    // 重置标记
    isProjectSwitching.value = false
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
