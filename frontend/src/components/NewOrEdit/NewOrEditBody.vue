<script lang="ts" setup>
const formModel = defineModel<Record<string, any>>('formModel', {
  required: true,
})
const emits = defineEmits<{
  (e: 'deserialize'): void
}>()

const route = useRoute()
const router = useRouter()
const { setEditState } = useTemporaryStore()
const { selectedModuleId, editState } = storeToRefs(useTemporaryStore())

const isEditState = computed(() => route.fullPath.includes('is-edit=true'))

onMounted(() => {
  if (!selectedModuleId.value || selectedModuleId.value === -1) {
    // eslint-disable-next-line unicorn/prefer-at
    router.push(route.matched[route.matched.length - 2])
  }

  if (!editState.value != null) {
    formModel.value = {
      ...formModel.value,
      ...editState.value,
    }

    emits('deserialize')
    setEditState(null)
  }
  nextTick(() => {
    formModel.value.moduleId = selectedModuleId.value!
  })
})

defineExpose({
  isEditState,
})
</script>

<template>
  <slot />
</template>
