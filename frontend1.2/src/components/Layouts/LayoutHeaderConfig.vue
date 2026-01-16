<script lang="ts" setup>
import { Select, Tooltip } from 'ant-design-vue'

const route = useRoute()
const { modifyConfig, fetchGetProjectDatas } = useGlobalConfigStore()
const { loadingWithGetProjectDatas, config } = storeToRefs(
  useGlobalConfigStore(),
)

const disabled = computed(() => route.fullPath.includes('new-or-edit'))

fetchGetProjectDatas()

//请求权限
const permissionStore = usePermissionStore()
permissionStore.fetchUserRole()
</script>

<template>
  <div flex space-x-4>
    <div>
      <span>选择项目：</span>
      <Select
        :disabled="disabled"
        :value="config.projectId"
        :loading="loadingWithGetProjectDatas"
        @update:value="modifyConfig({ projectId: $event as number })"
      >
        <Select.Option
          v-for="{ id, name, description } in config.projectDatas"
          :key="id"
          :value="id"
        >
          <Tooltip :title="description">{{ name }}</Tooltip>
        </Select.Option>
      </Select>
    </div>
  </div>
</template>
