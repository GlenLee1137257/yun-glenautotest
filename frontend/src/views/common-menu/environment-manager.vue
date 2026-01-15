<script lang="ts" setup>
import { type AfterFetchContext, objectOmit } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'
import type {
  EnvironmentTableNeeds,
  IEnvironment,
} from '~/types/apis/environment'
import type { ColumnsType } from 'ant-design-vue/es/table'

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
    title: '协议',
    dataIndex: 'protocol',
    key: 'protocol',
    align: 'center',
  },
  {
    title: '域名',
    dataIndex: 'domain',
    key: 'domain',
    align: 'center',
  },
  {
    title: '端口',
    dataIndex: 'port',
    key: 'port',
    align: 'center',
  },
  {
    title: '描述',
    dataIndex: 'description',
    key: 'description',
    align: 'center',
  },
  {
    title: '操作',
    dataIndex: 'operator',
    key: 'operator',
    align: 'center',
  },
]

const { config } = storeToRefs(useGlobalConfigStore())

const dataProxy = ref<EnvironmentTableNeeds[]>([])
const { execute, isFetching } = useCustomFetch(
  '/engine-service/api/v1/env/list',
  {
    immediate: false,
    initialData: [],
    afterFetch(ctx: AfterFetchContext<IBasic<IEnvironment[]>>) {
      if (ctx.data && ctx.data.code === 0) {
        dataProxy.value = ctx.data.data.map((item) =>
          objectOmit(item, [
            'createAccountId',
            'updateAccountId',
            'gmtCreate',
            'gmtModified',
          ]),
        )
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

watchImmediate(
  () => config.value.projectId,
  () => execute(),
)
</script>

<template>
  <SimplyTableModal
    v-model:data-source="dataProxy"
    base-name="env"
    localize-name="环境"
    :columns="columns"
    :loading-with-get-data-source="isFetching"
    :custom-fields="['projectId', 'id']"
    @refresh-data="execute"
  />
</template>
