<script
  lang="ts"
  setup
  generic="
    T extends {
      id: number
    }
  "
>
import { Button, Input, Modal, Popconfirm, Table, message } from 'ant-design-vue'
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
    enableBatchExecution?: boolean
  }>(),
  {
    showEditor: false,
    notFetchDefaultData: false,
    loadingWithAnotherTableDataSource: false,
    anotherTableDataSource: () => [],
    enableBatchExecution: false,
  },
)

const emits = defineEmits<{
  (e: 'fetchDataSource'): void
}>()

const { baseName, columns, notFetchDefaultData } = toRefs(props)

const globalConfigStore = useGlobalConfigStore()
const temporaryStore = useTemporaryStore()
const { selectedModuleId, modules } = storeToRefs(temporaryStore)
const { setModules, setSelectedModuleId, setEditState } = temporaryStore

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
      // 更新用例信息缓存（用于批量执行确认弹窗）
      const currentModule = modules.value.find(m => m.id === selectedModuleId.value)
      const moduleName = currentModule?.name || '未知模块'
      
      ctx.data.data.list.forEach((item: any) => {
        caseInfoCache.value.set(item.id, {
          id: item.id,
          name: item.name || '未命名用例',
          moduleId: selectedModuleId.value,
          moduleName,
        })
      })
      
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

// ==================== 批量执行功能 ====================

// 批量选择相关状态（需要在watchImmediate之前声明）
const selectedRowKeys = ref<number[]>([])
const batchExecuting = ref(false)

// 用例信息缓存（用于批量执行确认弹窗）
const caseInfoCache = ref<Map<number, { id: number; name: string; moduleId: number; moduleName: string }>>(new Map())

// 批量执行确认弹窗
const showBatchConfirmModal = ref(false)
const batchConfirmData = ref<{
  modules: Array<{
    moduleId: number
    moduleName: string
    cases: Array<{ id: number; name: string }>
  }>
}>({ modules: [] })

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
    // 清空批量选择
    selectedRowKeys.value = []
    // 重新获取新项目的模块列表
    await fetchApiModules()
    // 重置标记
    isProjectSwitching.value = false
  },
)

// 表格行选择配置
const rowSelection = computed(() => {
  if (!props.enableBatchExecution) return undefined
  
  return {
    selectedRowKeys: selectedRowKeys.value,
    onChange: (keys: number[]) => {
      // 支持跨模块选择：合并当前表格的选择和其他模块的选择
      const currentTableIds = tableDataSource.value.map(item => item.id)
      
      // 保留其他模块（不在当前表格中）的选择
      const otherModuleSelections = selectedRowKeys.value.filter(id => !currentTableIds.includes(id))
      
      // 合并：其他模块的选择 + 当前表格的新选择
      selectedRowKeys.value = [...otherModuleSelections, ...keys] as number[]
    },
    getCheckboxProps: (record: T) => ({
      id: String(record.id), // 转换为字符串以满足ACheckbox的类型要求
    }),
  }
})

// 批量执行用例 - 显示确认弹窗
function handleBatchExecute() {
  if (selectedRowKeys.value.length === 0) {
    message.warning('请先选择要执行的用例')
    return
  }

  // 从缓存中获取选中用例的信息，按模块分组
  const moduleMap = new Map<number, { moduleId: number; moduleName: string; cases: Array<{ id: number; name: string }> }>()
  
  selectedRowKeys.value.forEach(id => {
    const caseInfo = caseInfoCache.value.get(id)
    if (caseInfo) {
      if (!moduleMap.has(caseInfo.moduleId)) {
        moduleMap.set(caseInfo.moduleId, {
          moduleId: caseInfo.moduleId,
          moduleName: caseInfo.moduleName,
          cases: [],
        })
      }
      moduleMap.get(caseInfo.moduleId)!.cases.push({
        id: caseInfo.id,
        name: caseInfo.name,
      })
    }
  })
  
  batchConfirmData.value = {
    modules: Array.from(moduleMap.values()),
  }
  
  showBatchConfirmModal.value = true
}

// 确认批量执行
async function confirmBatchExecute() {
  try {
    batchExecuting.value = true
    showBatchConfirmModal.value = false
    
    const { data, error } = await useCustomFetch(
      `/engine-service/api/v1/${baseName.value}/batch_execute`,
      {
        method: 'POST',
      },
    )
    .post({
      projectId: globalConfigStore.config.projectId,
      caseIds: selectedRowKeys.value,
    })

    console.log('批量执行响应 - data.value:', data.value)

    if (error.value) {
      console.error('批量执行请求失败 - error:', error.value)
      message.error('批量执行请求失败')
      return
    }

    const responseData = data.value
    
    if (responseData && responseData.code === 0) {
      const summary = responseData.data
      const successRate = summary.total > 0 
        ? Math.round((summary.success / summary.total) * 100) 
        : 0
      
      message.success({
        content: `批量执行完成！总数：${summary.total}，成功：${summary.success}，失败：${summary.fail}，成功率 ${successRate}%`,
        duration: 5,
      })
      
      console.log('批量执行详细结果:', summary)
      
      // 清空选择
      selectedRowKeys.value = []
    } else {
      console.error('批量执行失败 - responseData:', responseData)
      message.error(responseData?.msg || '批量执行失败')
    }
  } catch (error) {
    message.error('批量执行异常')
    console.error('批量执行捕获异常:', error)
  } finally {
    batchExecuting.value = false
  }
}

// 按模块执行用例
async function handleExecuteByModule() {
  if (selectedModuleId.value === -1) {
    message.warning('请先选择模块')
    return
  }

  // 确保已选择项目，否则后端会因为缺少 projectId 报系统异常
  const projectId = globalConfigStore.config.projectId
  if (projectId === null || projectId === undefined) {
    message.error('请先选择项目后再执行当前模块')
    return
  }

  try {
    batchExecuting.value = true
    
    // 不要使用.json()，useCustomFetch的afterFetch已经解析过JSON了
    const { data, error } = await useCustomFetch(
      handleParams(`/engine-service/api/v1/${baseName.value}/execute_by_module`, {
        moduleId: selectedModuleId.value,
        projectId,
      }),
      {
        method: 'POST',
      },
    )
    .post()

    console.log('按模块执行响应 - data.value:', data.value)

    if (error.value) {
      console.error('按模块执行请求失败 - error:', error.value)
      message.error('按模块执行请求失败')
      return
    }

    const responseData = data.value

    if (responseData && responseData.code === 0) {
      const summary = responseData.data
      const successRate = summary.total > 0 
        ? Math.round((summary.success / summary.total) * 100) 
        : 0
      
      message.success({
        content: `模块执行完成！总数：${summary.total}，成功：${summary.success}，失败：${summary.fail}，成功率 ${successRate}%`,
        duration: 5,
      })
      
      // 显示详细结果
      console.log('模块执行详细结果:', summary)
    } else {
      console.error('模块执行失败 - responseData:', responseData)
      message.error(responseData?.msg || '模块执行失败')
    }
  } catch (error) {
    message.error('模块执行异常')
    console.error('模块执行捕获异常:', error)
  } finally {
    batchExecuting.value = false
  }
}

// 清空选择
function handleClearSelection() {
  selectedRowKeys.value = []
}

// 注意：不再监听模块切换来清空选择，支持跨模块批量执行
// 项目切换时会自动清空选择（在 watchImmediate projectId 中已处理）
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

      <!-- 批量操作工具栏 -->
      <div 
        v-if="enableBatchExecution" 
        class="batch-toolbar"
        mb-2
      >
        <div flex items-center justify-between px-4 py-3>
          <div flex items-center space-x-3>
            <span class="text-gray-600">
              已选择 
              <span class="font-semibold text-blue-600">
                {{ selectedRowKeys.length }}
              </span> 
              个用例
              <span v-if="selectedRowKeys.length > 0" class="text-gray-400 text-xs ml-1">
                （支持跨模块）
              </span>
            </span>
            <Button
              v-if="selectedRowKeys.length > 0"
              size="small"
              @click="handleClearSelection"
            >
              清空选择
            </Button>
          </div>
          <div flex space-x-2>
            <Button 
              type="primary" 
              :disabled="selectedRowKeys.length === 0"
              :loading="batchExecuting"
              @click="handleBatchExecute"
            >
              批量执行选中用例
            </Button>
            <Button 
              :loading="batchExecuting"
              :disabled="selectedModuleId === -1"
              @click="handleExecuteByModule"
            >
              执行当前模块全部
            </Button>
          </div>
        </div>
      </div>

      <Table
        :row-selection="rowSelection"
        :columns="columns"
        :loading="
          !notFetchDefaultData
            ? loadingWithGetTableDataSource!
            : loadingWithAnotherTableDataSource
        "
        :data-source="
          !notFetchDefaultData ? tableDataSource! : anotherTableDataSource
        "
        :row-key="(record: T) => record.id"
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

    <!-- 批量执行确认弹窗 -->
    <Modal
      v-model:open="showBatchConfirmModal"
      title="批量执行确认"
      width="700px"
      @ok="confirmBatchExecute"
      @cancel="showBatchConfirmModal = false"
    >
      <div class="batch-confirm-content">
        <div class="confirm-summary">
          <div class="summary-item">
            <span class="label">总用例数：</span>
            <span class="value text-blue-600 font-bold">{{ selectedRowKeys.length }}</span>
          </div>
          <div class="summary-item">
            <span class="label">涉及模块：</span>
            <span class="value text-green-600 font-bold">{{ batchConfirmData.modules.length }}</span>
          </div>
        </div>

        <div class="modules-list">
          <div
            v-for="module in batchConfirmData.modules"
            :key="module.moduleId"
            class="module-item"
          >
            <div class="module-header">
              <span class="module-name">📁 {{ module.moduleName }}</span>
              <span class="case-count">{{ module.cases.length }} 个用例</span>
            </div>
            <div class="cases-list">
              <div
                v-for="(caseItem, index) in module.cases"
                :key="caseItem.id"
                class="case-item"
              >
                <span class="case-index">{{ index + 1 }}.</span>
                <span class="case-name">{{ caseItem.name }}</span>
              </div>
            </div>
          </div>
        </div>

        <div class="confirm-tip">
          <span class="tip-icon">💡</span>
          <span class="tip-text">确认后将按顺序执行以上用例</span>
        </div>
      </div>
    </Modal>
  </div>
</template>

<style scoped>
.batch-toolbar {
  background: linear-gradient(135deg, #f5f7fa 0%, #f0f2f5 100%);
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  transition: all 0.3s ease;
}

.batch-toolbar:hover {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

/* 批量执行确认弹窗样式 */
.batch-confirm-content {
  padding: 16px 0;
}

.confirm-summary {
  display: flex;
  gap: 32px;
  padding: 16px;
  background: #f5f7fa;
  border-radius: 8px;
  margin-bottom: 20px;
}

.summary-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.summary-item .label {
  color: #666;
  font-size: 14px;
}

.summary-item .value {
  font-size: 20px;
}

.modules-list {
  max-height: 400px;
  overflow-y: auto;
  padding-right: 8px;
}

.module-item {
  margin-bottom: 20px;
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  overflow: hidden;
}

.module-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: linear-gradient(135deg, #1890ff15 0%, #1890ff08 100%);
  border-bottom: 1px solid #e8e8e8;
}

.module-name {
  font-weight: 600;
  color: #1890ff;
  font-size: 15px;
}

.case-count {
  color: #999;
  font-size: 13px;
}

.cases-list {
  padding: 12px 16px;
  background: #fff;
}

.case-item {
  display: flex;
  align-items: flex-start;
  padding: 8px 0;
  border-bottom: 1px dashed #f0f0f0;
}

.case-item:last-child {
  border-bottom: none;
}

.case-index {
  color: #999;
  font-size: 13px;
  margin-right: 8px;
  min-width: 24px;
}

.case-name {
  color: #333;
  font-size: 14px;
  line-height: 1.5;
}

.confirm-tip {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  background: #fff7e6;
  border: 1px solid #ffd591;
  border-radius: 6px;
  margin-top: 16px;
}

.tip-icon {
  font-size: 18px;
}

.tip-text {
  color: #d46b08;
  font-size: 13px;
}

/* 滚动条样式 */
.modules-list::-webkit-scrollbar {
  width: 6px;
}

.modules-list::-webkit-scrollbar-thumb {
  background: #d9d9d9;
  border-radius: 3px;
}

.modules-list::-webkit-scrollbar-thumb:hover {
  background: #bfbfbf;
}
</style>
