<script lang="ts" setup generic="T extends object">
import { Button } from 'ant-design-vue'
import type { IExexute } from '~/types/apis/execute'
const { baseName } = defineProps<{
  baseName: string
  modelValue: IExexute<T> | null
}>()
</script>

<template>
  <div my flex="~ items-center justify-center" space-x-4>
    <div flex>
      <span>执行结果：</span>
      <ExecuteState :model-value="modelValue?.executeState" />
    </div>

    <div flex>
      <span>执行步骤：</span>
      <span>{{ modelValue?.quantity }}</span>
    </div>

    <div flex>
      <span>成功步骤：</span>
      <span>{{ modelValue?.passQuantity }}</span>
    </div>

    <div flex>
      <span>失败步骤：</span>
      <span>{{ modelValue?.failQuantity }}</span>
    </div>

    <div flex>
      <span>执行时间：</span>
      <span
        >{{ (modelValue?.endTime ?? 0) - (modelValue?.startTime ?? 0) }}ms</span
      >
    </div>

    <RouterLink :to="`/report/${baseName === 'api' ? 'interface' : baseName}/`">
      <Button type="primary" size="small">测试报告入口</Button>
    </RouterLink>
  </div>
</template>
