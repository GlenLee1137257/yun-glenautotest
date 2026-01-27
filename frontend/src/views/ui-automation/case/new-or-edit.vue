<script lang="ts" setup>
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import { Button, Cascader, Form, Input, InputNumber, message, Modal, Radio, Select, Switch, Table } from 'ant-design-vue'
import { EyeOutlined, EyeInvisibleOutlined } from '@ant-design/icons-vue'
import { objectOmit } from '@vueuse/core'
import {
  defaultWithIUICaseStep,
  defaultWithIUIConstantSelectOptions,
  defualtWithIUICase,
} from '~/types/apis/ui-case'
import { useCustomFetch } from '~/composables/custom-fetch'
import type {
  CascaderProps,
  ShowSearchType,
} from 'ant-design-vue/es/vc-cascader'
import type { IBasic } from '~/types/apis/basic'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { IOperation } from '~/types/apis/ui'
import type { IUIElement } from '~/types/apis/ui'
import type { IUICaseStep } from '~/types/apis/ui-case'
import type { AfterFetchContext } from '@vueuse/core/index.cjs'

// eslint-disable-next-line no-console
console.log('[UI元素库] UI用例 new-or-edit.vue 组件脚本已加载')

type ResponseType = Record<
  | 'ui_location_type'
  | 'browser'
  | 'mouse'
  | 'keyboard'
  | 'wait'
  | 'assertion'
  | 'browser_type'
  | 'img',
  IOperation[]
>

const { data } = useCustomFetch<ResponseType>(
  '/engine-service/api/v1/dict/list?category=ui_location_type,browser,mouse,keyboard,wait,assertion,img,browser_type',
  {
    initialData: {},
    afterFetch(ctx: AfterFetchContext<IBasic<ResponseType>>) {
      if (ctx.data && ctx.data.code === 0) {
        return {
          data: ctx.data.data,
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

const currentSelectedOptions = ref<string[]>([])
const isInitializingCascader = ref(false) // 标记 Cascader 是否正在初始化，防止初始化时意外触发 change 事件

// 元素库选择相关
const elementSelectModalVisible = ref(false)
const currentLocationField = ref<string>('') // 当前正在编辑的定位字段（locationExpress 或 targetLocationExpress）
const elementList = ref<IUIElement[]>([])
const selectedModuleId = ref<number>(-1)
const elementModules = ref<any[]>([])
const globalConfigStore = useGlobalConfigStore()

// 获取元素模块列表
const fetchElementModulesUrl = computed(() => {
  return handleParams('/engine-service/api/v1/ui_element_module/list', {
    projectId: globalConfigStore.config.projectId,
  })
})
const { execute: fetchElementModules, isFetching: loadingElementModules } = useCustomFetch<any[]>(
  fetchElementModulesUrl,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic<any[]>>) {
      if (ctx.data && ctx.data.code === 0) {
        elementModules.value = ctx.data.data || []
        if (elementModules.value.length > 0 && selectedModuleId.value === -1) {
          selectedModuleId.value = elementModules.value[0].id
          fetchElementList()
        }
      }
      return ctx
    },
  },
)

// 获取元素列表
const fetchElementListUrl = computed(() => {
  return handleParams('/engine-service/api/v1/ui_element_module/find', {
    projectId: globalConfigStore.config.projectId,
    moduleId: selectedModuleId.value,
  })
})
const { execute: fetchElementList, isFetching: loadingElementList } = useCustomFetch<any>(
  fetchElementListUrl,
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
      if (ctx.data && ctx.data.code === 0) {
        elementList.value = ctx.data.data?.list || []
      }
      return ctx
    },
  },
)

// 元素列表表格列
const elementColumns: ColumnsType<IUIElement> = [
  { title: '名称', dataIndex: 'name', key: 'name', width: 150 },
  { title: '定位类型', dataIndex: 'locationType', key: 'locationType', width: 120 },
  { title: '定位表达式', dataIndex: 'locationExpress', key: 'locationExpress', width: 200 },
  { title: '描述', dataIndex: 'description', key: 'description' },
  { title: '操作', key: 'operation', width: 100, align: 'center' },
]

// 打开元素选择模态框
function openElementSelectModal(field: string, step: IUICaseStep) {
  currentLocationField.value = field
  currentEditingStep.value = step
  elementSelectModalVisible.value = true
  if (elementModules.value.length === 0) {
    fetchElementModules()
  } else {
    fetchElementList()
  }
}

// 当前正在编辑的步骤引用（通过模板slot传递）
const currentEditingStep = ref<IUICaseStep | null>(null)

// 选择元素（关联模式：保存元素ID并启用元素库模式）
function handleSelectElement(element: IUIElement) {
  if (!currentEditingStep.value) return
  
  // 立即将选择的元素添加到 elementLibraryMap，这样用户能立即看到绿色提示
  elementLibraryMap.value.set(element.id, element)
  
  // 根据字段名保存元素ID和填充定位信息（作为备用）
  if (currentLocationField.value === 'locationExpress') {
    // 保存元素ID（关联）
    currentEditingStep.value.elementId = element.id
    // 自动启用"从元素库选择"模式
    currentEditingStep.value.useElementLibrary = true
    // 同时保存定位信息作为备用（元素被删除时使用）
    currentEditingStep.value.locationType = element.locationType
    currentEditingStep.value.locationExpress = element.locationExpress
    if (element.elementWait) {
      currentEditingStep.value.elementWait = element.elementWait
    }
  } else if (currentLocationField.value === 'targetLocationExpress') {
    // 保存目标元素ID（关联）
    currentEditingStep.value.targetElementId = element.id
    // 自动启用"从元素库选择"模式
    currentEditingStep.value.useTargetElementLibrary = true
    // 同时保存定位信息作为备用（元素被删除时使用）
    currentEditingStep.value.targetLocationType = element.locationType
    currentEditingStep.value.targetLocationExpress = element.locationExpress
    if (element.elementWait) {
      currentEditingStep.value.targetElementWait = element.elementWait
    }
  }
  
  elementSelectModalVisible.value = false
  currentLocationField.value = ''
}

// 监听模块切换
watch(selectedModuleId, () => {
  if (selectedModuleId.value !== -1) {
    fetchElementList()
  }
})

// NewOrEditSteps 组件引用
const stepsComponentRef = ref<any>(null)

// 批量查询元素库（用于显示最新定位信息）
const elementLibraryMap = ref<Map<number, IUIElement>>(new Map())
const { post: fetchElementsByIds } = useCustomFetch('/engine-service/api/v1/ui_element/findByIds', {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<Record<number, IUIElement>>>) {
    if (ctx.data && ctx.data.code === 0) {
      // 转换为 Map 以便快速查找
      elementLibraryMap.value = new Map(Object.entries(ctx.data.data).map(([key, value]) => [Number(key), value]))
    }
    return ctx
  },
})

// 从步骤列表中提取所有关联的元素ID并查询元素库
function loadElementLibraryData(stepList: IUICaseStep[]) {
  const elementIds = new Set<number>()
  // 调试日志：观察步骤里的 elementId / targetElementId 是否正确
  // 注意：调试完成后可以删掉这些 console.log
  // eslint-disable-next-line no-console
  console.log(
    '[UI元素库] loadElementLibraryData stepList:',
    stepList.map((step) => ({
      id: step.id,
      num: step.num,
      name: step.name,
      elementId: step.elementId,
      targetElementId: step.targetElementId,
    })),
  )

  stepList.forEach((step) => {
    if (step.elementId) elementIds.add(step.elementId)
    if (step.targetElementId) elementIds.add(step.targetElementId)
  })

  if (elementIds.size > 0) {
    // eslint-disable-next-line no-console
    console.log('[UI元素库] 将要查询的元素ID列表:', Array.from(elementIds))
    // 注意：发送对象而不是数组，这样 beforeFetch 会自动添加 projectId 到 body
    fetchElementsByIds({ elementIds: Array.from(elementIds) }).execute()
  } else {
    // eslint-disable-next-line no-console
    console.log('[UI元素库] 当前步骤列表中没有任何 elementId/targetElementId，不发起 findByIds 请求')
  }
}

// 手动刷新元素库信息
function refreshElementLibrary() {
  const stepList = stepsComponentRef.value?.formModel?.stepList
  if (stepList && stepList.length > 0) {
    loadElementLibraryData(stepList)
    message.success('元素库信息已刷新')
  }
}

// 获取元素的实际定位信息（根据 useElementLibrary 标志决定）
function getElementLocation(step: IUICaseStep, field: 'element' | 'targetElement') {
  const useLibrary = field === 'element' ? step.useElementLibrary : step.useTargetElementLibrary
  const elementId = field === 'element' ? step.elementId : step.targetElementId
  const backupType = field === 'element' ? step.locationType : step.targetLocationType
  const backupExpress = field === 'element' ? step.locationExpress : step.targetLocationExpress
  
  // 逻辑：
  // 1. 如果未勾选"从元素库选择"，使用手动输入的定位信息（普通显示）
  // 2. 如果勾选了"从元素库选择" + 元素库信息存在 → 自动同步定位信息（绿色标识）
  // 3. 如果勾选了"从元素库选择" + 元素库信息不存在 → 使用备用定位信息（黄色标识）
  
  if (!useLibrary) {
    // 未勾选"从元素库选择"，使用手动输入的定位信息
    return {
      type: backupType,
      express: backupExpress,
      source: 'manual' as const,
    }
  }
  
  // 勾选了"从元素库选择"
  if (elementId) {
    const element = elementLibraryMap.value.get(elementId)
    if (element) {
      // 元素库信息存在，自动同步（绿色标识）
      return {
        type: element.locationType,
        express: element.locationExpress,
        source: 'library' as const,
        elementName: element.name,
      }
    } else {
      // 元素库信息不存在（已删除），使用备用（黄色标识）
      return {
        type: backupType,
        express: backupExpress,
        source: 'deleted' as const,
        elementName: '元素已删除',
      }
    }
  }
  
  // 勾选了但没有 elementId（理论上不应该出现）
  return {
    type: backupType,
    express: backupExpress,
    source: 'manual' as const,
  }
}

// 监听步骤列表变化，自动查询元素库
watch(
  () => stepsComponentRef.value?.formModel?.stepList,
  (newStepList) => {
    // eslint-disable-next-line no-console
    console.log('[UI元素库] watch stepList 触发, newStepList:', newStepList)
    if (newStepList && newStepList.length > 0) {
      loadElementLibraryData(newStepList)
    }
  },
  { deep: true, immediate: true }
)

// 定期刷新元素库信息（解决修改元素库后列表不同步的问题）
let refreshTimer: NodeJS.Timeout | null = null
onMounted(() => {
  // 每5秒刷新一次元素库信息
  refreshTimer = setInterval(() => {
    const stepList = stepsComponentRef.value?.formModel?.stepList
    // eslint-disable-next-line no-console
    console.log('[UI元素库] 定时刷新，当前 stepList:', stepList)
    if (stepList && stepList.length > 0) {
      loadElementLibraryData(stepList)
    }
  }, 5000)
})

onUnmounted(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
  }
})

// 创建操作类型的中英文映射表
const operationTypeMap = computed(() => {
  const map: Record<string, string> = {}
  if (data.value) {
    // 遍历所有分类（browser, mouse, keyboard, wait, assertion, img等）
    Object.values(data.value).forEach((categoryItems) => {
      if (Array.isArray(categoryItems)) {
        categoryItems.forEach((item: IOperation) => {
          if (item.value && item.name) {
            map[item.value] = item.name
          }
        })
      }
    })
  }
  return map
})

// 元素定位类型的排序顺序
const locationTypeOrder = [
  'ID',              // id定位
  'NAME',            // 名称定位
  'CSS_SELECTOR',    // CSS选择器定位
  'XPATH',           // xpath定位
  'CLASS_NAME',      // 类名定位
  'TAG_NAME',        // 标签名称定位
  'LINK_TEXT',       // 链接文本内容定位
  'PARTIAL_LINK_TEXT', // 全部链接文本内容定位
]

// 浏览器操作类型的排序顺序
const browserOperationOrder = [
  'BROWSER_OPEN',              // 打开窗口
  'BROWSER_CLOSE',             // 关闭窗口
  'BROWSER_MAXIMIZE',          // 最大化窗口
  'BROWSER_RESIZE',            // 设置窗口大小
  'BROWSER_FORWARD',           // 浏览器前进
  'BROWSER_BACK',              // 浏览器后退
  'BROWSER_REFRESH',           // 浏览器刷新
  'BROWSER_SWITCH_BY_HANDLER', // 通过句柄切换窗口
  'BROWSER_SWITCH_BY_INDEX',   // 通过索引切换窗口
]

// 排序后的元素定位类型选项
const sortedLocationTypeOptions = computed(() => {
  if (!data.value?.ui_location_type) {
    return []
  }
  
  const locationTypes = data.value.ui_location_type.map((item) => ({
    label: item.value, // 使用英文值作为显示文本
    value: item.value,
  }))
  
  // 按照指定顺序排序
  return locationTypes.sort((a, b) => {
    const indexA = locationTypeOrder.indexOf(a.value)
    const indexB = locationTypeOrder.indexOf(b.value)
    
    // 如果找不到，放到最后
    if (indexA === -1 && indexB === -1) return 0
    if (indexA === -1) return 1
    if (indexB === -1) return -1
    
    return indexA - indexB
  })
})

// 列定义
const columns: ColumnsType<any> = [
  {
    title: '排序',
    dataIndex: 'num',
    key: 'num',
    fixed: 'left',
    align: 'center',
    width: 80,
  },
  {
    title: '名称',
    dataIndex: 'name',
    key: 'name',
    fixed: 'left',
    align: 'center',
    width: 150,
  },
  {
    title: '操作类型',
    dataIndex: 'operationType',
    key: 'operationType',
    align: 'center',
    width: 150,
    customRender: ({ text }: { text: string }) => {
      return operationTypeMap.value[text] || text
    },
  },
  {
    title: '定位类型',
    dataIndex: 'locationType',
    key: 'locationType',
    align: 'center',
    width: 150,
    customRender: ({ record }: { record: IUICaseStep }) => {
      const location = getElementLocation(record, 'element')
      return location.type
    },
  },
  {
    title: '定位表达式',
    dataIndex: 'locationExpress',
    key: 'locationExpress',
    align: 'center',
    width: 200,
    customRender: ({ record }: { record: IUICaseStep }) => {
      const location = getElementLocation(record, 'element')
      let badge = ''
      if (location.source === 'library') {
        badge = `🟢 ${location.express}`
      } else if (location.source === 'deleted') {
        badge = `🟡 ${location.express}`
      } else {
        return location.express
      }
      return badge
    },
  },
  {
    title: '元素等待时间',
    dataIndex: 'elementWait',
    key: 'elementWait',
    align: 'center',
    width: 150,
  },

  {
    title: '值',
    dataIndex: 'value',
    key: 'value',
    align: 'center',
    width: 200,
  },
  {
    title: '预期键',
    dataIndex: 'expectKey',
    key: 'expectKey',
    align: 'center',
    width: 120,
  },
  {
    title: '预期值',
    dataIndex: 'expectValue',
    key: 'expectValue',
    align: 'center',
    width: 120,
  },
  {
    title: '描述',
    dataIndex: 'description',
    key: 'description',
    align: 'center',
    width: 150,
  },
  {
    title: '失败是否继续',
    dataIndex: 'isContinue',
    key: 'isContinue',
    align: 'center',
    width: 150,
  },
  {
    title: '是否截图',
    dataIndex: 'isScreenshot',
    key: 'isScreenshot',
    align: 'center',
    width: 100,
  },
  {
    title: '目标定位类型',
    dataIndex: 'targetLocationType',
    key: 'targetLocationType',
    align: 'center',
    width: 140,
    customRender: ({ record }: { record: IUICaseStep }) => {
      const location = getElementLocation(record, 'targetElement')
      return location.type || '-'
    },
  },
  {
    title: '目标定位表达式',
    dataIndex: 'targetLocationExpress',
    key: 'targetLocationExpress',
    align: 'center',
    width: 200,
    customRender: ({ record }: { record: IUICaseStep }) => {
      const location = getElementLocation(record, 'targetElement')
      if (!location.express) return '-'
      
      let badge = ''
      if (location.source === 'library') {
        badge = `🟢 ${location.express}`
      } else if (location.source === 'deleted') {
        badge = `🟡 ${location.express}`
      } else {
        return location.express
      }
      return badge
    },
  },
  {
    title: '目标元素等待时间',
    dataIndex: 'targetElementWait',
    key: 'targetElementWait',
    align: 'center',
    width: 140,
  },
  {
    title: '操作',
    key: 'operation',
    dataIndex: 'operation',
    width: 180,
    fixed: 'right',
    align: 'center',
  },
]

const filter: ShowSearchType['filter'] = (inputValue, path) => {
  return path.some((option) =>
    option.label.toLowerCase().includes(inputValue.toLowerCase()),
  )
}
const cascaderOptions = computed(() => {
  if (!data.value) {
    return []
  }

  return Object.entries(
    objectOmit(data.value, ['ui_location_type', 'browser_type']),
  )
    .filter(([, value]) => value.length > 0)
    .map(([key, value]) => {
      let children = value.map((item) => ({
        value: item.value,
        label: item.name,
      }))
      
      // 如果是浏览器操作类型，按照指定顺序排序
      if (key === 'browser') {
        children = children.sort((a, b) => {
          const indexA = browserOperationOrder.indexOf(a.value)
          const indexB = browserOperationOrder.indexOf(b.value)
          
          // 如果找不到，放到最后
          if (indexA === -1 && indexB === -1) return 0
          if (indexA === -1) return 1
          if (indexB === -1) return -1
          
          return indexA - indexB
        })
      }
      
      return {
        value: key,
        label: value?.[0]?.categoryName ?? '',
        children,
      }
    }) as CascaderProps['options']
})

const currentSelectedValue = computed(() => {
  const category =
    data.value?.[currentSelectedOptions.value?.[0] as keyof ResponseType]
  if (!category || !currentSelectedOptions.value?.[1]) {
    return []
  }
  const selected = category.find(
    (item) => item.value === currentSelectedOptions.value?.[1],
  )
  if (!selected || !selected.extend) {
    return []
  }
  try {
    const result = objectDeserializer<{ name: string; field: string }>(selected.extend, true)
    return Array.isArray(result) ? result : []
  } catch (e) {
    return []
  }
})

function initOperationType(type: string | undefined) {
  isInitializingCascader.value = true // 标记开始初始化
  
  if (!type) {
    currentSelectedOptions.value = []
    // 延迟重置标志，确保 Cascader 的内部更新完成
    nextTick(() => {
      isInitializingCascader.value = false
    })
    return
  }

  const found = cascaderOptions.value?.find(
    (item) => item.children?.find((child) => child.value === type) != null,
  )

  if (!found) {
    currentSelectedOptions.value = []
    nextTick(() => {
      isInitializingCascader.value = false
    })
    return
  }

  currentSelectedOptions.value = [
    found.value as string,
    found.children!.find((child) => child.value === type)!.value as string,
  ]
  
  // 延迟重置标志，确保 Cascader 的内部更新完成
  nextTick(() => {
    isInitializingCascader.value = false
  })
}

// 处理步骤类型切换的函数
const handleStepTypeChange = (selectedStep: IUICaseStep, newType: string) => {
  if (!selectedStep) return
  
  if (newType === 'LOCAL') {
    // 切换到本地步骤时，如果步骤有操作类型，重新初始化
    if (selectedStep.operationType) {
      nextTick(() => {
        initOperationType(selectedStep.operationType)
      })
    } else {
      // 如果没有操作类型，清空选择
      currentSelectedOptions.value = []
    }
  } else if (newType === 'REFER') {
    // 切换到引用步骤时，清空操作类型相关配置
    currentSelectedOptions.value = []
  }
}
</script>

<template>
  <NewOrEditSteps
    ref="stepsComponentRef"
    info="ui"
    localized-name="UI 用例"
    base-api-name="ui_case"
    :columns="columns"
    :default-with-step-item="defaultWithIUICaseStep"
    :default-with-step-instance="defualtWithIUICase"
    :default-constant-select-options="defaultWithIUIConstantSelectOptions"
  >
    <template #body-content="{ formModel }">
      <Form
        :modal="formModel"
        layout="horizontal"
        class="grid grid-cols-3 gap-4"
      >
        <Form.Item label="名称">
          <Input v-model:value="formModel.name" placeholder="请输入名称" />
        </Form.Item>

        <Form.Item label="浏览器">
          <Select v-model:value="formModel.browser">
            <Select.Option
              v-for="item in data?.browser_type"
              :key="item.id"
              :value="item.value"
            >
              {{ item.name }}
            </Select.Option>
          </Select>
        </Form.Item>

        <Form.Item label="显示浏览器窗口">
          <div class="flex items-center gap-2">
            <Switch 
              :checked="formModel.headlessMode === 0"
              @change="(checked: boolean) => formModel.headlessMode = checked ? 0 : 1"
              checked-children="显示"
              un-checked-children="隐藏"
            >
              <template #checkedChildren>
                <EyeOutlined />
              </template>
              <template #unCheckedChildren>
                <EyeInvisibleOutlined />
              </template>
            </Switch>
            <span class="text-sm text-gray-500">
              {{ formModel.headlessMode === 0 ? '执行时将显示浏览器窗口，可观察自动化过程' : '执行时浏览器在后台运行，速度更快' }}
            </span>
          </div>
        </Form.Item>

        <FormItemModules v-model:module-id="formModel.moduleId" />

        <FormItemLevel v-model:level="formModel.level" />

        <Form.Item label="描述">
          <Input.TextArea
            v-model:value="formModel.description"
            placeholder="请输入描述"
          />
        </Form.Item>
      </Form>
    </template>

    <template #model-content="{ selectedStep, formModel }">
      <Form 
        :model="selectedStep" 
        layout="vertical"
      >
        <Form.Item label="名称">
          <Input v-model:value="selectedStep.name" />
        </Form.Item>

        <Form.Item label="排序">
          <InputNumber 
            v-model:value="selectedStep.num" 
            :min="1" 
            placeholder="请输入排序号（从1开始）"
            style="width: 100%"
          />
          <div class="text-xs text-gray-500 mt-1">
            排序号可以相同，相同时按修改时间排序（修改时间越新的越先执行）
          </div>
        </Form.Item>

        <Form.Item label="步骤类型">
          <Radio.Group 
            v-model:value="selectedStep.stepType"
            @change="(e: any) => {
              handleStepTypeChange(selectedStep, e.target.value)
            }"
          >
            <Radio value="LOCAL">本地步骤</Radio>
            <Radio value="REFER">引用步骤</Radio>
          </Radio.Group>
        </Form.Item>

        <Form.Item v-if="selectedStep.stepType === 'REFER'" label="引用步骤">
          <Select
            v-model:value="selectedStep.referStepId"
            placeholder="选择要引用的步骤"
            show-search
            :filter-option="(input: string, option: any) => 
              option?.label?.toLowerCase().includes(input.toLowerCase())
            "
          >
            <Select.Option
              v-for="step in (formModel?.stepList || []).filter((s: IUICaseStep) => 
                s.id !== selectedStep.id && 
                (!s.stepType || s.stepType === 'LOCAL')
              )"
              :key="step.id"
              :value="step.id"
              :label="`步骤${step.num} - ${step.name}`"
            >
              步骤{{ step.num }} - {{ step.name }}
            </Select.Option>
          </Select>
        </Form.Item>

        <Form.Item v-if="selectedStep.stepType !== 'REFER'" label="操作类型">
          <Cascader
            :key="`cascader-${selectedStep.id || selectedStep.num || 'new'}-${selectedStep.operationType || 'empty'}`"
            v-model:value="currentSelectedOptions"
            :options="cascaderOptions"
            placeholder="请选择操作类型"
            :show-search="{ filter }"
            :display-render="({ labels }) => labels[labels.length - 1]"
            @vue:mounted="() => initOperationType(selectedStep.operationType)"
            @change="
              (value) => {
                // 防止初始化时意外修改 operationType
                if (isInitializingCascader) {
                  return
                }
                
                // 修复：当 value 是空数组时，清空 operationType；否则设置为选中的值
                if (!value || value.length === 0) {
                  selectedStep.operationType = ''
                } else {
                  selectedStep.operationType = value[value.length - 1] as string
                }
              }
            "
          />
        </Form.Item>

        <template v-if="selectedStep.stepType !== 'REFER'">
        <Form.Item
          v-for="(item, index) in currentSelectedValue"
            :key="`field-${item?.field || index}`"
          :label="item.name"
        >
          <div v-if="item.field.toLowerCase().includes('locationtype')">
            <!-- @vue-expect-error -->
            <Select
              v-model:value="/* @ts-ignore */ selectedStep[item.field]"
              :options="sortedLocationTypeOptions"
            />
          </div>
          <div v-else-if="item.field.toLowerCase().includes('locationexpress')">
            <!-- 从元素库选择开关 -->
            <div class="mb-2">
              <Switch
                :checked="item.field === 'locationExpress' ? selectedStep.useElementLibrary : selectedStep.useTargetElementLibrary"
                @change="(checked: boolean) => {
                  if (item.field === 'locationExpress') {
                    selectedStep.useElementLibrary = checked
                    // 取消勾选时，清除元素库关联
                    if (!checked) {
                      selectedStep.elementId = null
                    }
                  } else {
                    selectedStep.useTargetElementLibrary = checked
                    // 取消勾选时，清除元素库关联
                    if (!checked) {
                      selectedStep.targetElementId = null
                    }
                  }
                }"
                checked-children="从元素库选择"
                un-checked-children="手动输入"
                size="small"
              />
              <span class="ml-2 text-xs text-gray-500">
                {{ (item.field === 'locationExpress' ? selectedStep.useElementLibrary : selectedStep.useTargetElementLibrary) 
                  ? '启用后将自动同步元素库的最新定位信息' 
                  : '使用自定义定位信息' }}
              </span>
            </div>
            
            <div class="flex gap-2">
              <Input
                v-model:value="/* @ts-ignore */ selectedStep[item.field]"
                :placeholder="`请输入${item.name}`"
                :disabled="item.field === 'locationExpress' ? selectedStep.useElementLibrary : selectedStep.useTargetElementLibrary"
                class="flex-1"
              />
              <Button 
                v-if="item.field === 'locationExpress' ? selectedStep.useElementLibrary : selectedStep.useTargetElementLibrary"
                type="primary" 
                size="small"
                @click="openElementSelectModal(item.field, selectedStep)"
              >
                选择元素
              </Button>
            </div>
            <!-- 显示元素来源提示 -->
            <div v-if="item.field === 'locationExpress' && selectedStep.useElementLibrary && selectedStep.elementId" class="mt-1 text-xs text-gray-500">
              <span v-if="elementLibraryMap.get(selectedStep.elementId)" class="text-green-600">
                🟢 已关联元素库（{{ elementLibraryMap.get(selectedStep.elementId)?.name }}）- 将自动同步最新定位信息
              </span>
              <span v-else class="text-yellow-600">
                🟡 关联的元素已从库中删除 - 使用备用定位信息
              </span>
            </div>
            <div v-if="item.field === 'targetLocationExpress' && selectedStep.useTargetElementLibrary && selectedStep.targetElementId" class="mt-1 text-xs text-gray-500">
              <span v-if="elementLibraryMap.get(selectedStep.targetElementId)" class="text-green-600">
                🟢 已关联元素库（{{ elementLibraryMap.get(selectedStep.targetElementId)?.name }}）- 将自动同步最新定位信息
              </span>
              <span v-else class="text-yellow-600">
                🟡 关联的元素已从库中删除 - 使用备用定位信息
              </span>
            </div>
          </div>
          <Input
            v-else
            v-model:value="/* @ts-ignore */ selectedStep[item.field]"
            :placeholder="`请输入${item.name}`"
          />
        </Form.Item>
        </template>

        <div v-if="selectedStep.stepType !== 'REFER'" flex="~ justify-around">
          <Form.Item label="是否截图">
            <Switch v-model:checked="selectedStep.isScreenshot" />
          </Form.Item>

          <Form.Item label="失败是否继续">
            <Switch v-model:checked="selectedStep.isContinue" />
          </Form.Item>
        </div>
        
        <div v-if="selectedStep.stepType === 'REFER'" class="mt-4 p-4 bg-blue-50 rounded">
          <p class="text-sm text-gray-600">
            <strong>提示：</strong>引用步骤将使用被引用步骤的所有配置（操作类型、定位方式、值等），但可以自定义步骤名称。
          </p>
        </div>
      </Form>
    </template>
  </NewOrEditSteps>

  <!-- 元素库选择模态框 -->
  <Modal
    v-model:open="elementSelectModalVisible"
    title="从元素库选择"
    width="800px"
    :footer="null"
  >
    <div class="mb-4 p-3 bg-blue-50 rounded text-sm text-gray-700">
      <p class="font-semibold mb-1">💡 关联模式说明：</p>
      <p class="mb-1">• 选择元素后将<strong>关联</strong>元素库，元素库更新后用例会自动使用最新定位信息</p>
      <p class="mb-1">• 步骤列表中 <span class="text-green-600">🟢 绿色圆点</span> 表示来自元素库的定位信息（每5秒自动同步）</p>
      <p class="mb-1">• 步骤列表中 <span class="text-yellow-600">🟡 黄色圆点</span> 表示元素已从库中删除，使用备用定位信息</p>
      <p class="text-xs text-gray-600 mt-2">💡 提示：修改元素库后，步骤列表会在5秒内自动更新显示最新定位信息</p>
    </div>

    <div class="mb-4">
      <span class="mr-2">选择模块：</span>
      <Select
        v-model:value="selectedModuleId"
        style="width: 200px"
        placeholder="请选择模块"
      >
        <Select.Option
          v-for="module in elementModules"
          :key="module.id"
          :value="module.id"
        >
          {{ module.name }}
        </Select.Option>
      </Select>
    </div>
    <Table
      :columns="elementColumns"
      :data-source="elementList"
      :loading="loadingElementList"
      :pagination="{ pageSize: 10 }"
      row-key="id"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'operation'">
          <Button type="link" @click="handleSelectElement(record)">选择</Button>
        </template>
      </template>
    </Table>
  </Modal>
</template>
