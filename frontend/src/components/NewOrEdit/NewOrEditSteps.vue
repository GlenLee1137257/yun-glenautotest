<script
  lang="ts"
  setup
  generic="
    T extends {
      id: number
      stepList: Record<string, any>[]
    },
    C extends object
  "
>
import dayjs from 'dayjs'
import { Button, Modal, Popconfirm, Table, message } from 'ant-design-vue'
import { type AfterFetchContext, objectOmit } from '@vueuse/core'
import type { IBasic, StepItem } from '~/types/apis/basic'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type NewOrEditBodyVue from './NewOrEditBody.vue'
import type { ComponentExposed } from 'vue-component-type-helpers'
import type { IDict } from '~/types/apis/dict'
import { useGlobalConfigStore } from '~/stores/global-config.store'

const props = withDefaults(
  defineProps<{
    localizedName: string
    baseApiName: string
    columns: ColumnsType<any>
    defaultConstantSelectOptions: C
    defaultWithStepInstance: T
    defaultWithStepItem: StepItem<T>
    info?: 'ui' | 'api'
  }>(),
  {
    info: 'api',
  },
)

const { info, baseApiName, defaultWithStepItem, defaultWithStepInstance } =
  toRefs(props)

const route = useRoute()
const router = useRouter()
const globalConfigStore = useGlobalConfigStore()
const [createModalVisible, toggleCreateModalVisible] = useToggle(false)

const controlStepState = ref<'new' | 'edit' | 'default'>('default')
const isEditState = computed(() => route.fullPath.includes('is-edit=true'))

const stepSlotRef = ref<{ serialize: () => void }>()
function setStepSlotRef(ref: { serialize: () => void }) {
  stepSlotRef.value = ref
}

const formModel = ref<T>({ ...defaultWithStepInstance.value, stepList: [] })
const bodyRef = ref<ComponentExposed<typeof NewOrEditBodyVue>>()

const selectedStepNum = ref(-1)
const selectedStep = computed<StepItem<T>>(() => {
  return formModel.value.stepList?.length > 0
    ? (formModel.value.stepList[
        selectedStepNum.value <= 0 ? 0 : selectedStepNum.value
      ] as StepItem<T>)
    : defaultWithStepItem.value
})

const constantSelectOptions = reactive<C>({
  ...props.defaultConstantSelectOptions,
})

// 表格分页状态，用于计算全局排序序号
const tablePagination = reactive({
  current: 1,
  pageSize: 10,
  showSizeChanger: false,
})

const { post: fetchCreateApiCase } = useCustomFetch(
  `/engine-service/api/v1/${baseApiName.value}/save`,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '保存成功！')
      }
      return ctx
    },
  },
)

const { post: fetchUpdateApiCase } = useCustomFetch(
  `/engine-service/api/v1/${baseApiName.value}/update`,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '更新成功！')
      }
      return ctx
    },
  },
)

const fetchGetApiCaseUrl = computed(
  () =>
    `/engine-service/api/v1/${baseApiName.value}/find?id=${
      formModel.value.id === -1 ? route.query.id : formModel.value.id
    }`,
)
const { isFetching, execute: fetchGetApiCase } = useCustomFetch(
  fetchGetApiCaseUrl,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
      if (ctx.data && ctx.data.code === 0) {
        formModel.value = {
          ...formModel.value,
          ...ctx.data.data,
          stepList: ctx.data.data.list,
        }
        formModel.value.stepList = formModel.value.stepList.map((item) => ({
          ...defaultWithStepItem.value,
          ...item,
          caseId: formModel.value.id,
        }))
      }
      return ctx
    },
  },
)

const { post: fetchDeleteApiCaseStep } = useCustomFetch(
  `/engine-service/api/v1/${baseApiName.value}_step/delete`,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '删除成功！')
      }
      return ctx
    },
  },
)

const { post: fetchUpdateApiCaseStep } = useCustomFetch(
  `/engine-service/api/v1/${baseApiName.value}_step/update`,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '更新成功！')
      }
      return ctx
    },
  },
)

const { post: fetchCreateApiCaseStep } = useCustomFetch(
  `/engine-service/api/v1/${baseApiName.value}_step/save`,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '保存成功！')
      }
      return ctx
    },
  },
)

const url = computed(() => {
  const _url = '/engine-service/api/v1/dict/list'
  if (info.value === 'api') {
    return handleParams(_url, {
      category:
        'api_relation_from,api_relation_type,api_assertion_from,api_assertion_type,api_assertion_action',
    })
  } else {
    return handleParams(_url, {
      category: 'ui_location_type',
    })
  }
})
const { execute } = useCustomFetch(url, {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<Record<string, IDict[]>>>) {
    if (ctx.data && ctx.data.code === 0) {
      for (const [key, value] of Object.entries(ctx.data.data)) {
        // @ts-expect-error
        constantSelectOptions[key] = value
      }
    }
    return ctx
  },
})

function handleTableChange(pagination: any) {
  tablePagination.current = pagination.current
  tablePagination.pageSize = pagination.pageSize
}

function handleAdd() {
  if (isEditState.value) {
    controlStepState.value = 'new'
  }
  formModel.value.stepList.push({
    ...defaultWithStepItem.value,
    projectId: globalConfigStore.config.projectId,
    caseId: formModel.value.id,
    num: formModel.value.stepList.length + 1, // 从1开始
  })
  selectedStepNum.value = formModel.value.stepList.length - 1
  toggleCreateModalVisible()
}

function handleEdit(step: StepItem<T>) {
  if (isEditState.value) {
    controlStepState.value = 'edit'
  }

  // 根据 id 或 num 从完整 stepList 中找到真正的索引，避免分页导致 index 错乱
  const index = formModel.value.stepList.findIndex((item: any) => {
    // 已保存到后端的步骤优先使用 id 匹配
    if (step.id && step.id !== -1 && item.id === step.id) return true
    // 新建但未保存到后端的步骤使用 num 匹配
    return item.num === step.num
  })

  selectedStepNum.value = index > -1 ? index : 0
  toggleCreateModalVisible()
}

async function handleDelete(step: StepItem<T>) {
  if (isEditState.value) {
    // 编辑模式：根据步骤 id 删除，避免受分页影响
    await fetchDeleteApiCaseStep({
      id: step.id,
      projectId: step.projectId || globalConfigStore.config.projectId, // 优先使用步骤自己的 projectId
    }).execute()
    await fetchGetApiCase()
    
    // 删除后，检查当前页是否有效，如果当前页超出范围，自动调整到最后一页
    const totalPages = Math.ceil((formModel.value.stepList?.length || 0) / tablePagination.pageSize)
    if (tablePagination.current > totalPages && totalPages > 0) {
      tablePagination.current = totalPages
    } else if (totalPages === 0) {
      tablePagination.current = 1
    }
    return
  }

  // 新增模式：本地删除，根据 num 删除对应步骤
  formModel.value.stepList = formModel.value.stepList.filter(
    (item) => item.num !== step.num,
  )
  // 重新整理本地步骤的 num 序号（从1开始）
  formModel.value.stepList?.forEach((item, index) => (item.num = index + 1))
  
  // 删除后，检查当前页是否有效，如果当前页超出范围，自动调整到最后一页
  const totalPages = Math.ceil((formModel.value.stepList?.length || 0) / tablePagination.pageSize)
  if (tablePagination.current > totalPages && totalPages > 0) {
    tablePagination.current = totalPages
  } else if (totalPages === 0) {
    tablePagination.current = 1
  }
}

async function handleOk() {
  stepSlotRef.value?.serialize()
  if (isEditState.value) {
    if (controlStepState.value === 'new') {
      await fetchCreateApiCaseStep(
        objectOmit(selectedStep.value, ['id']),
      ).execute()
      // 新增后重新获取数据
      await fetchGetApiCase()
    } else {
      await fetchUpdateApiCaseStep(selectedStep.value).execute()
      // 更新后同步更新本地 formModel 中的对应步骤数据
      const stepIndex = formModel.value.stepList.findIndex(
        (step) => step.id === selectedStep.value.id
      )
      if (stepIndex !== -1) {
        // 更新本地数据，确保序列化后的数据（包括断言和关联变量）被保存
        formModel.value.stepList[stepIndex] = {
          ...formModel.value.stepList[stepIndex],
          ...selectedStep.value,
        }
      }
    }
    // 恢复默认的 StepState
    controlStepState.value = 'default'
  }
  toggleCreateModalVisible()

  selectedStepNum.value = -1
}

async function handleSave() {
  try {
    if (bodyRef.value?.isEditState) {
      // 编辑模式：只更新用例基本信息，步骤已通过 handleOk 单独保存
      const updateData = {
        ...objectOmit(formModel.value, ['stepList', 'createAccountId', 'updateAccountId', 'gmtCreate', 'gmtModified'] as any),
      }
      await fetchUpdateApiCase(updateData).execute()
    } else {
      // 新增模式：将 stepList 转换为 list，并移除不需要的字段
      // 确保 stepList 存在且为数组
      const stepList = formModel.value.stepList || []
      const saveData = {
        ...objectOmit(formModel.value, ['stepList', 'id', 'createAccountId', 'updateAccountId', 'gmtCreate', 'gmtModified'] as any),
        list: stepList.map((step) =>
          objectOmit(step, ['id', 'caseId', 'createAccountId', 'updateAccountId', 'gmtCreate', 'gmtModified'] as any)
        ),
      }
      await fetchCreateApiCase(saveData).execute()
    }
    
    // 等待请求完成后再返回
    router.back()
  } catch (error) {
    console.error('保存失败:', error)
    // 错误信息已在 afterFetch 中处理
  }
}

onMounted(async () => {
  try {
    await nextTick()
    if (isEditState.value) {
      fetchGetApiCase()
    }

    await execute()
  } catch (error) {
    console.error('初始化字典数据失败:', error)
  }
})
</script>

<template>
  <div>
    <NewOrEditBody ref="bodyRef" v-model:form-model="formModel">
      <slot name="body-content" :form-model="formModel" />

      <div
        space-y-4
        :class="[
          isFetching && 'opacity-50 pointer-events-none cursor-not-allowed',
        ]"
      >
        <Button type="primary" @click="handleAdd"> 新增操作 </Button>
        <Table
          :columns="columns"
          :data-source="formModel.stepList"
          :scroll="{ x: 1500, y: 820 }"
          :loading="isFetching"
          :pagination="tablePagination"
          @change="handleTableChange"
        >
          <template #bodyCell="{ column, record, index, text }">
            <template v-if="column.key!.toString() === 'operation'">
              <Button type="link" @click="handleEdit(record)">编辑</Button>
              <Popconfirm
                title="确认是否删除此行！（注意此操作不可逆！）"
                @confirm="handleDelete(record)"
              >
                <Button type="link">删除</Button>
              </Popconfirm>
            </template>
            <template
              v-else-if="typeof record[column.key!.toString()] === 'boolean'"
            >
              <span
                :class="[
                  !record[column.key!.toString()]
                    ? 'text-red-500'
                    : 'text-blue-500',
                ]"
              >
                {{ record[column.key!.toString()] ? '是' : '否' }}
              </span>
            </template>
            <template
              v-else-if="
                record[column.key!.toString()] == null &&
                column.key !== 'operation'
              "
            >
              <span> - </span>
            </template>
            <template v-else-if="column.customRender">
              <span>{{ column.customRender({ text, record, index, column }) }}</span>
            </template>
            <template
              v-else-if="
                ['gmtCreate', 'gmtModified'].includes(column.key!.toString())
              "
            >
              {{
                dayjs(record[column.key!.toString()]).format(
                  'YYYY-MM-DD - HH:mm:ss',
                )
              }}
            </template>
            <template v-else-if="column.key!.toString() === 'num'">
              <!-- 直接显示 num 字段（数据库已从1开始） -->
              {{ record.num }}
            </template>
            <template v-else>
              <p truncate :title="record[column.key!.toString()]">
                {{ record[column.key!.toString()] }}
              </p>
            </template>
          </template>
        </Table>

        <Modal v-model:open="createModalVisible" width="50%" @ok="handleOk">
          <slot
            name="model-content"
            :set-step-slot-ref="setStepSlotRef"
            :selected-step="selectedStep"
            :constant-select-options="constantSelectOptions"
          />
        </Modal>
      </div>
    </NewOrEditBody>
    <NewOrEditFooter :name="localizedName" @save="handleSave" />
  </div>
</template>
