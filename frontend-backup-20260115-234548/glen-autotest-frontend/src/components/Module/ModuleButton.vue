<script lang="ts" setup>
import { Popconfirm } from 'ant-design-vue'
import { CloseOutlined } from '@ant-design/icons-vue'

const props = withDefaults(
  defineProps<{
    id: number
    title: string
    baseName: string
    selected?: boolean
  }>(),
  {
    selected: false,
  },
)

const emits = defineEmits<{
  (e: 'refreshModules'): void
}>()

const { id, selected, baseName, title } = toRefs(props)

const { setSelectedModuleId } = useTemporaryStore()
const globalConfig = useGlobalConfigStore()

const isEditState = ref()
const name = ref(title.value)
const nameRef = ref<HTMLSpanElement>()
const inputNameRef = ref<HTMLInputElement>()
const inputWidth = ref<number>(0)
const visibleCloseBtn = ref(false)

const selectedClass = computed(() => {
  return selected.value
    ? 'bg-#1677ff text-white b-white hover:bg-#4096ff active:bg-#0958d9'
    : 'bg-white text-black b-#d9d9d9 hover:b-#4096ff hover:text-#4096ff active:b-#0958d9 active:text-#0958d9'
})
const editSateClass = computed(() => {
  return isEditState.value && 'text-black!'
})

const { post: fetchUpdateModule } = useCustomFetch(
  `/engine-service/api/v1/${baseName.value}_module/update`,
  { immediate: false },
)
const { post: fetchDeleteModule } = useCustomFetch(
  `/engine-service/api/v1/${baseName.value}_module/del`,
  {
    immediate: false,
  },
)

function handleInputWidth() {
  inputWidth.value = nameRef.value?.offsetWidth || 1
}

function handleEditable() {
  isEditState.value = !isEditState.value
  nextTick(() => inputNameRef.value?.focus())
}

function handleSave() {
  if (!isEditState.value) return
  isEditState.value = false
  fetchUpdateModule({ id: id.value, name: name.value }).execute()
}

async function handleDelete() {
  await fetchDeleteModule({ 
    id: id.value, 
    projectId: globalConfig.config.projectId 
  }).execute()
  emits('refreshModules')
}

onMounted(() => nextTick(() => handleInputWidth()))
</script>

<template>
  <div
    relative
    @mouseenter="visibleCloseBtn = true"
    @mouseleave="visibleCloseBtn = false"
  >
    <button
      v-bind="$attrs"
      :class="[selectedClass, editSateClass]"
      p="y-2 x-5"
      b="1 solid"
      rounded="6px"
      relative
      min-h-38px
      cursor-pointer
      transition-base
      flex="~ items-center justify-center"
      :style="{ 'box-shadow': '0 2px 0 rgba(5, 145, 255, 0.1)' }"
      @click="setSelectedModuleId(id)"
      @dblclick="handleEditable"
    >
      <span ref="nameRef" :class="[isEditState ? 'invisible' : 'visible']">{{
        name
      }}</span>
      <div absolute b bg-op-50>
        <input
          v-show="isEditState"
          ref="inputNameRef"
          v-model="name"
          bg-transparent
          text-white
          :style="{ width: `${inputWidth}px` }"
          class="b-0 border-none p-0 outline-none"
          @blur="handleSave"
          @keyup.enter="handleSave"
          @input="handleInputWidth"
          @compositionend="handleInputWidth"
          @compositionupdate="handleInputWidth"
          @compositionstart="handleInputWidth"
        />
      </div>
    </button>
    <Popconfirm
      title="你确定要删除这个模块吗？（此操作不可逆！）"
      @confirm="handleDelete"
    >
      <div
        v-show="visibleCloseBtn"
        right="0.5"
        top="0.5"
        absolute
        z-2
        transition-base
        pointer-base
        hover:c-red-500
      >
        <CloseOutlined />
      </div>
    </Popconfirm>
  </div>
</template>
