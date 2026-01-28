<script lang="ts" setup>
import { Form, Input, Switch, message } from 'ant-design-vue'
import {
  type IApiCaseStep,
  defaultWithIApiCase,
  defaultWithIApiCaseStep,
  defaultWithIApiConstantSelectOptions,
} from '~/types/apis/api-case'
import type { IApi } from '~/types/apis/api'
import ApiCaseStep from '~/components/NewOrEdit/ApiCaseStep.vue'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { ComponentExposed } from 'vue-component-type-helpers'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'

const globalConfigStore = useGlobalConfigStore()

// 接口库同步相关（参考 UI 自动化的元素库实现）
const apiLibraryMap = ref<Map<number, IApi>>(new Map())

// 批量查询接口库
const { post: fetchApisByIds } = useCustomFetch('/engine-service/api/v1/api/findByIds', {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<Record<number, IApi>>>) {
    if (ctx.data && ctx.data.code === 0) {
      // 转换为 Map 以便快速查找
      apiLibraryMap.value = new Map(Object.entries(ctx.data.data).map(([key, value]) => [Number(key), value]))
    }
    return ctx
  },
})

// 从步骤列表中提取所有关联的接口ID并查询接口库
function loadApiLibraryData(stepList: IApiCaseStep[]) {
  const apiIds = new Set<number>()
  
  stepList.forEach((step) => {
    if (step.apiId && step.useApiLibrary) {
      apiIds.add(step.apiId)
    }
  })

  if (apiIds.size > 0) {
    fetchApisByIds({ apiIds: Array.from(apiIds) }).execute()
  }
}

// 获取接口的实际信息（根据 useApiLibrary 标志决定）
function getApiInfo(step: IApiCaseStep) {
  if (!step.useApiLibrary || !step.apiId) {
    // 未启用接口库，使用手动配置的信息
    return {
      path: step.path,
      method: step.method,
      source: 'manual' as const,
    }
  }
  
  // 启用了接口库
  const api = apiLibraryMap.value.get(step.apiId)
  if (api) {
    // 接口库信息存在，使用最新信息
    return {
      path: api.path,
      method: api.method,
      source: 'library' as const,
      apiName: api.name,
    }
  } else {
    // 接口库信息不存在（已删除），使用备用信息
    return {
      path: step.path,
      method: step.method,
      source: 'deleted' as const,
    }
  }
}

// NewOrEditSteps 组件引用
const stepsComponentRef = ref<any>(null)

// 监听步骤列表变化，自动查询接口库
watch(
  () => stepsComponentRef.value?.formModel?.stepList,
  (newStepList) => {
    if (newStepList && newStepList.length > 0) {
      loadApiLibraryData(newStepList)
    }
  },
  { deep: true, immediate: true }
)

// 定期刷新接口库信息
let refreshTimer: NodeJS.Timeout | null = null
onMounted(() => {
  refreshTimer = setInterval(() => {
    const stepList = stepsComponentRef.value?.formModel?.stepList
    if (stepList && stepList.length > 0) {
      loadApiLibraryData(stepList)
    }
  }, 5000)
})

onUnmounted(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
  }
})

const columns: ColumnsType<IApiCaseStep> = [
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
    align: 'center',
    width: 150,
  },
  {
    title: '描述',
    dataIndex: 'description',
    key: 'description',
    align: 'center',
    width: 200,
  },
  { 
    title: '路径', 
    dataIndex: 'path', 
    key: 'path', 
    align: 'center',
    width: 200,
    customRender: ({ record }: { record: IApiCaseStep }) => {
      const apiInfo = getApiInfo(record)
      if (!apiInfo.path) return '-'
      
      if (apiInfo.source === 'library') {
        return `🟢 ${apiInfo.path}`
      } else if (apiInfo.source === 'deleted') {
        return `🟡 ${apiInfo.path}`
      } else {
        return apiInfo.path
      }
    },
  },
  { 
    title: '等级', 
    dataIndex: 'level', 
    key: 'level', 
    align: 'center',
    width: 80,
  },
  {
    title: '环境 ID',
    dataIndex: 'environmentId',
    key: 'environmentId',
    align: 'center',
    width: 100,
  },
  { 
    title: '请求类型', 
    dataIndex: 'method', 
    key: 'method', 
    align: 'center',
    width: 100,
    customRender: ({ record }: { record: IApiCaseStep }) => {
      const apiInfo = getApiInfo(record)
      return apiInfo.method || '-'
    },
  },
  {
    title: '创建时间',
    dataIndex: 'gmtCreate',
    key: 'gmtCreate',
    width: 180,
    align: 'center',
  },
  {
    title: '修改时间',
    dataIndex: 'gmtModified',
    key: 'gmtModified',
    width: 180,
    align: 'center',
  },
  {
    title: '操作',
    dataIndex: 'operation',
    key: 'operation',
    fixed: 'right',
    width: 170,
    align: 'center',
  },
]
</script>

<template>
  <NewOrEditSteps
    ref="stepsComponentRef"
    info="api"
    localized-name="接口用例"
    base-api-name="api_case"
    :columns="columns"
    :default-with-step-item="defaultWithIApiCaseStep"
    :default-with-step-instance="defaultWithIApiCase"
    :default-constant-select-options="defaultWithIApiConstantSelectOptions"
  >
    <template #body-content="{ formModel }">
      <Form
        :modal="formModel"
        layout="horizontal"
        class="grid grid-cols-3 gap-4"
      >
        <Form.Item label="用例名称">
          <Input v-model:value="formModel.name" placeholder="请输入用例名称" />
        </Form.Item>

        <!-- <Form.Item label="是否同步 Session">
          <Switch v-model:checked="formModel.isSyncSession" />
        </Form.Item>

        <Form.Item label="是否同步 Cookie">
          <Switch v-model:checked="formModel.isSyncCookie" />
        </Form.Item> -->

        <FormItemModules v-model:module-id="formModel.moduleId" />

        <FormItemLevel v-model:level="formModel.level" />

        <Form.Item label="用例描述">
          <Input.TextArea
            v-model:value="formModel.description"
            placeholder="请输入用例描述"
          />
        </Form.Item>
      </Form>
    </template>

    <template
      #model-content="{ selectedStep, setStepSlotRef, constantSelectOptions }"
    >
      <ApiCaseStep
        :ref="
          (el) => setStepSlotRef(el as ComponentExposed<typeof ApiCaseStep>)
        "
        :api-constant-select-options="constantSelectOptions"
        :selected-step="selectedStep as IApiCaseStep"
      />
    </template>
  </NewOrEditSteps>
</template>
