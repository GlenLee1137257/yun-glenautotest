<script lang="ts" setup>
import { Cascader, Form, Input, Select, Switch } from 'ant-design-vue'
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
import type { AfterFetchContext } from '@vueuse/core/index.cjs'

const columns: ColumnsType<any> = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id',
    fixed: 'left',
    align: 'center',
    width: 60,
  },
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
    .map(([key, value]) => ({
      value: key,
      label: value?.[0]?.categoryName ?? '',
      children: value.map((item) => ({
        value: item.value,
        label: item.name,
      })),
    })) as CascaderProps['options']
})

const currentSelectedValue = computed(() => {
  const category =
    data.value?.[currentSelectedOptions.value?.[0] as keyof ResponseType]
  if (!category) {
    return []
  }
  const selected = category.find(
    (item) => item.value === currentSelectedOptions.value?.[1],
  )
  return selected
    ? objectDeserializer<{ name: string; field: string }>(selected.extend, true)
    : []
})

function initOperationType(type: string | undefined) {
  if (!type) return

  const found = cascaderOptions.value?.find(
    (item) => item.children?.find((child) => child.value === type) != null,
  )

  if (!found) return

  currentSelectedOptions.value = [
    found.value as string,
    found.children!.find((child) => child.value === type)!.value as string,
  ]
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

    <template #model-content="{ selectedStep }">
      <Form :model="selectedStep" layout="vertical">
        <Form.Item label="名称">
          <Input v-model:value="selectedStep.name" />
        </Form.Item>

        <Form.Item label="操作类型">
          <Cascader
            v-model:value="currentSelectedOptions"
            :options="cascaderOptions"
            placeholder="请选择操作类型"
            :show-search="{ filter }"
            :display-render="({ labels }) => labels[labels.length - 1]"
            @vue:mounted="() => initOperationType(selectedStep.operationType)"
            @change="
              (value) => {
                value[value.length - 1] &&
                  (selectedStep.operationType = value[
                    value.length - 1
                  ] as string)
              }
            "
          />
        </Form.Item>

        <Form.Item
          v-for="(item, index) in currentSelectedValue"
          :key="index"
          :label="item.name"
        >
          <div v-if="item.field.toLowerCase().includes('locationtype')">
            <!-- @vue-expect-error -->
            <Select
              v-model:value="/* @ts-ignore */ selectedStep[item.field]"
              :options="
                data?.ui_location_type.map((item) => ({
                  label: item.name,
                  value: item.value,
                }))
              "
            />
          </div>
          <Input
            v-else
            v-model:value="/* @ts-ignore */ selectedStep[item.field]"
            :placeholder="`请输入${item.name}`"
          />
        </Form.Item>

        <div flex="~ justify-around">
          <Form.Item label="是否截图">
            <Switch v-model:checked="selectedStep.isScreenshot" />
          </Form.Item>

          <Form.Item label="失败是否继续">
            <Switch v-model:checked="selectedStep.isContinue" />
          </Form.Item>
        </div>
      </Form>
    </template>
  </NewOrEditSteps>
</template>
