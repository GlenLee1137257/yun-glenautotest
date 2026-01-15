<script lang="ts" setup>
import { Button, Divider } from 'ant-design-vue'
defineProps<{
  name: string
}>()

defineEmits<{
  (e: 'save'): void
}>()

const router = useRouter()
</script>

<template>
  <div>
    <div flex="~ col items-center justify-center">
      <!-- <span text-8>编辑/新增{{ name }}</span> -->
      <Divider />
      <div space-x-4>
        <Button @click="router.back()">返回</Button>
        <Button type="primary" @click="$emit('save')">保存</Button>
      </div>
    </div>
    <slot />
  </div>
</template>
