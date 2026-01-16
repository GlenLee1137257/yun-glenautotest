<script lang="ts" setup>
import { Upload } from 'ant-design-vue'

defineProps<{
  showUrl?: string
}>()

const url = computed(() => `${baseUrl}/engine-service/api/v1/file/upload`)

const globalConfigStore = useGlobalConfigStore()
const headers = computed(() => ({
  token: globalConfigStore.loginToken,
}))
</script>

<template>
  <div mx-auto w-full flex flex-col text-center space-y-2>
    <span v-show="showUrl">{{ showUrl }}</span>

    <Upload
      :headers="headers"
      v-bind="$attrs"
      name="file"
      :action="url"
      :max-count="1"
      :show-upload-list="false"
    >
      <slot />
    </Upload>
  </div>
</template>
