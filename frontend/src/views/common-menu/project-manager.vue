<script lang="ts" setup>
import type { ColumnsType } from 'ant-design-vue/es/table'

const columns: ColumnsType = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id',
    align: 'center',
  },
  {
    title: '项目管理员',
    dataIndex: 'projectAdminName',
    key: 'projectAdminName',
    align: 'center',
  },
  {
    title: '名称',
    dataIndex: 'name',
    key: 'name',
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
const { fetchGetProjectDatas } = useGlobalConfigStore()
const { config, loadingWithGetProjectDatas } = storeToRefs(
  useGlobalConfigStore(),
)
</script>

<template>
  <SimplyTableModal
    v-model:data-source="config.projectListDataProxy"
    base-name="project"
    localize-name="项目"
    :columns="columns"
    :loading-with-get-data-source="loadingWithGetProjectDatas"
    :custom-fields="['projectAdmin', 'projectAdminName', 'id', 'projectId']"
    @refresh-data="fetchGetProjectDatas"
  />
</template>
