<script lang="ts" setup>
import { Select, Tooltip } from 'ant-design-vue'

const route = useRoute()
const { modifyConfig, fetchGetProjectDatas } = useGlobalConfigStore()
const { loadingWithGetProjectDatas, config } = storeToRefs(
  useGlobalConfigStore(),
)

const disabled = computed(() => route.fullPath.includes('new-or-edit'))

//请求权限
const permissionStore = usePermissionStore()

// 优化初始化顺序：先获取项目列表，再获取用户角色信息
async function initializeData() {
  try {
    // 1. 先获取项目列表（这会设置 projectId）
    await fetchGetProjectDatas()
    // 2. 再获取用户角色信息（此时 projectId 已经设置好了）
    await permissionStore.fetchUserRole()
  } catch (error) {
    console.error('初始化数据失败:', error)
  }
}

// 组件挂载时初始化
initializeData()
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
