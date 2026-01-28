<script lang="ts" setup>
import { Form, Select, Tooltip } from 'ant-design-vue'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'
import type { IEnvironment } from '~/types/apis/environment'

defineProps<{ labelName?: string; disabled?: boolean }>()

const environmentId = defineModel<number>('environmentId', { required: true })

const { isFetching: loadingWithGetEnvironments, data: environments } =
  useCustomFetch<IEnvironment[]>(`/engine-service/api/v1/env/list`, {
    afterFetch(ctx: AfterFetchContext<IBasic<IEnvironment[]>>) {
      if (ctx.data && ctx.data.code === 0) {
        if (environmentId.value === -1) {
          environmentId.value = ctx.data.data[0].id
        }
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
  })
</script>

<template>
  <Form.Item :label="labelName ? labelName : '环境选择'">
    <Select 
      v-model:value="environmentId" 
      :loading="loadingWithGetEnvironments"
      :disabled="disabled"
    >
      <Select.Option
        v-for="{ id, name, description } in environments"
        :key="id"
        :value="id"
      >
        <Tooltip :title="description">{{ name }}</Tooltip>
      </Select.Option>
    </Select>
  </Form.Item>
</template>
