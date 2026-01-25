<script lang="ts" setup>
import { computed, nextTick, ref, watch } from 'vue'
import { Cascader, Form, Input, InputNumber, Radio, Select, Switch } from 'ant-design-vue'
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
import type { IUICaseStep } from '~/types/apis/ui-case'
import type { AfterFetchContext } from '@vueuse/core/index.cjs'

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
  },
  {
    title: '定位表达式',
    dataIndex: 'locationExpress',
    key: 'locationExpress',
    align: 'center',
    width: 150,
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
  },
  {
    title: '目标定位表达式',
    dataIndex: 'targetLocationExpress',
    key: 'targetLocationExpress',
    align: 'center',
    width: 140,
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
</template>
