<script lang="ts" setup>
import { PlusOutlined } from '@ant-design/icons-vue'

const props = defineProps<{
  title: string
  baseName: string
}>()

const emits = defineEmits<{
  (e: 'refreshModules'): void
}>()

const { baseName } = toRefs(props)

const { post: fetchCreateModule } = useCustomFetch(
  `/engine-service/api/v1/${baseName.value}_module/save`,
  { immediate: false },
)

const { selectedModuleId, modules } = storeToRefs(useTemporaryStore())

async function handleCreate() {
  await fetchCreateModule({ name: '默认模块' }).execute()
  emits('refreshModules')
}
</script>

<template>
  <div b="~ solid gray op-50" p="x t b-10" relative w-full rounded>
    <span text-4>{{ title }}模块</span>
    <div mt flex="~ wrap" gap-2>
      <ModuleButton
        v-for="item in modules"
        :id="item.id"
        :key="item.id"
        :title="item.name"
        :base-name="baseName"
        :selected="item.id === selectedModuleId"
        @refresh-modules="emits('refreshModules')"
      />
    </div>

    <div
      transition-base
      pointer-base
      class="absolute right-1 top-1 text-5 c-black"
      @click="handleCreate"
    >
      <PlusOutlined />
    </div>
  </div>
</template>
