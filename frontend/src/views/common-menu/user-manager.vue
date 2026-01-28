<script lang="ts" setup>
import {
  Button,
  Dropdown,
  Input,
  Menu,
  Modal,
  Popconfirm,
  Table,
  message,
} from 'ant-design-vue'
import dayjs from 'dayjs'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { AfterFetchContext } from '@vueuse/core'
import type {
  IAccountPower,
  IPermissionList,
  IRole,
  IUser,
} from '~/types/apis/user'
import type { IBasic, IBasicWithPage } from '~/types/apis/basic'

const pageConfig = reactive<{
  page: number
  size: number
  totalSize: number
  username: string
}>({
  page: 1,
  size: 6,
  totalSize: 0,
  username: '',
})
//
const permissionStore = usePermissionStore()

//查看权限按钮
const selectPower = ref<boolean>(false)
const findPowerCode = () => {
  const foundRoles = permissionStore.roles.roleList?.filter((role) =>
    role.permissionList.some(
      (permission) => permission.code === 'PROJECT_AUTH',
    ),
  )

  if (foundRoles && foundRoles.length > 0) {
    selectPower.value = false
  } else {
    selectPower.value = true
  }
}
findPowerCode()
//状态权限按钮
const selectState = ref<boolean>(false)
const findStateCode = () => {
  const hasProjectAuthOrReadWrite = permissionStore.roles.roleList?.some(
    (role) =>
      role.permissionList.some(
        (permission) =>
          permission.code === 'PROJECT_AUTH' ||
          permission.code === 'PROJECT_READ_WRITE',
      ),
  )

  if (hasProjectAuthOrReadWrite) {
    selectState.value = false
  } else {
    selectState.value = true
  }
}
findStateCode()

const { post, data, isFetching } = useCustomFetch<IUser[]>(
  '/account-service/api/v1/account/page',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IUser>>) => {
      if (ctx.data && ctx.data.code === 0) {
        pageConfig.totalSize = ctx.data.data.total_record
        return {
          data: ctx.data.data.current_data,
          response: ctx.response,
        }
      }
      return {
        data: [],
        response: ctx.response,
      }
    },
  },
)
async function reFetch() {
  await nextTick()
  post(toRaw(pageConfig)).execute()
}

const handleSearch = () => {
  reFetch()
}

const { get, data: roleList } = useCustomFetch<IRole[]>(
  '/account-service/api/permit/v1/role/list',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasic<IRole[]>>) => {
      if (ctx.data && ctx.data.code === 0) {
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
  },
)
async function roleListFetch() {
  await nextTick()
  get().execute()
}

//查找某个账号的用户名和权限
const accountId = ref(0)
const url = computed(() => {
  return `/account-service/api/permit/v1/role/findRoleByAccountId?accountId=${accountId.value}`
})

//查找某个账号的角色和权限
const { get: getAccountPower, data: AccountPower } =
  useCustomFetch<IAccountPower | null>(url, {
    immediate: false,
    initialData: null,
    afterFetch: (ctx: AfterFetchContext<IBasic<IAccountPower>>) => {
      if (ctx.data && ctx.data.code === 0) {
        return {
          data: ctx.data.data,
          response: ctx.response,
        }
      }
      return {
        data: null,
        response: ctx.response,
      }
    },
  })
async function accountPowerFetch() {
  await nextTick()
  // get().execute()
  get()
}
onMounted(() => {
  reFetch()
  roleListFetch()
  accountPowerFetch()
})

// 删除某个账号的角色和权限（注意：后端接口实际为 delRoleByAccountId）
const { post: executeDeleteRole } = useCustomFetch<IAccountPower>(
  '/account-service/api/permit/v1/role/delRoleByAccountId',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasic<IAccountPower>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '删除成功！')
      }
      return ctx
    },
  },
)

async function deleteRole(AccountPowerId: number, roleId: number) {
  await executeDeleteRole({
    accountId: AccountPowerId,
    roleId,
  }).execute()
  reFetch()
  await getAccountPower().execute()
}

//新增某个账号的角色和权限
const { post: executeAddRole } = useCustomFetch<IAccountPower>(
  '/account-service/api/permit/v1/role/addRoleByAccountId',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasic<IAccountPower>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '新增成功！')
      }
      return ctx
    },
  },
)

async function addRole(AccountPowerId: number, roleId: number) {
  await executeAddRole({
    accountId: AccountPowerId,
    roleId,
  }).execute()
  reFetch()
  await getAccountPower().execute()
}

//查看用户权限
const open = ref<boolean>(false)
const handleEditIndex = async (id: number) => {
  open.value = true
  accountId.value = id
  await getAccountPower().execute()
}
const handleOk = () => {
  open.value = false
}

//删除用户
const { post: executeDeleteReport } = useCustomFetch<IUser[]>(
  '/account-service/api/v1/account/del',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IUser>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '删除成功！')
      }
      return ctx
    },
  },
)

async function handleDelete(id: number) {
  await executeDeleteReport({
    id,
  }).execute()
  reFetch()
}

//更新用户
const { post: handleEnabled } = useCustomFetch<IUser[]>(
  '/account-service/api/v1/account/update',
  {
    immediate: false,
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IUser>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '更新成功！')
        reFetch()
      }
      return ctx
    },
  },
)

const tableValue: ColumnsType = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id',
    align: 'center',
  },
  {
    title: '账号',
    dataIndex: 'account',
    key: 'account',
    align: 'center',
  },
  {
    title: '用户名',
    dataIndex: 'username',
    key: 'username',
    align: 'center',
  },
  {
    title: '状态',
    dataIndex: 'isDisabled',
    key: 'isDisabled',
    align: 'center',
  },
  {
    title: '注册时间',
    dataIndex: 'gmtCreate',
    key: 'gmtCreate',
    align: 'center',
  },
  {
    title: '操作',
    dataIndex: 'operator',
    key: 'operator',
    align: 'center',
  },
]
</script>

<template>
  <div class="search-wrapped">
    <span class="search-account">用户名或者账号: </span>
    <div class="search-value">
      <Input v-model:value="pageConfig.username" @input="handleSearch" />
    </div>
  </div>
  <Table
    :columns="tableValue"
    :data-source="data!"
    :loading="isFetching"
    :pagination="{
      showLessItems: true,
      current: pageConfig.page,
      pageSize: pageConfig.size,
      total: pageConfig.totalSize,
      onChange(page, pageSize) {
        pageConfig.page = page
        pageConfig.size = pageSize
        reFetch()
      },
    }"
  >
    <template #bodyCell="{ column, record }">
      <template v-if="column.key === 'isDisabled'">
        <span>{{ record.isDisabled ? '禁用' : '激活' }}&nbsp;&nbsp;</span>
        <Button
          type="primary"
          size="small"
          :disabled="selectState"
          @click="
            handleEnabled({
              id: record.id,
              enabled: !record.isDisabled,
            }).execute()
          "
          >{{ record.isDisabled ? '激活' : '禁用' }}</Button
        >
      </template>
      <template
        v-if="['gmtCreate', 'gmtModified'].includes(column.key!.toString())"
      >
        {{
          dayjs(record[column.key as string]).format('YYYY-MM-DD - HH:mm:ss')
        }}
      </template>
      <template v-else-if="column.key === 'operator'">
        <Button
          type="link"
          :disabled="selectPower"
          @click="handleEditIndex(record.id)"
          >查看权限</Button
        >
        <Popconfirm title="是否要删除此行？" @confirm="handleDelete(record.id)">
          <Button type="link">删除</Button>
        </Popconfirm>
      </template>
    </template>
  </Table>
  <Modal v-model:open="open" @ok="handleOk" width="800px">
    <div style="margin-bottom: 20px">
      <div style="font-weight: bold; margin-bottom: 10px; font-size: 16px">角色列表</div>
        <div
          v-for="role in AccountPower?.roleList"
          :key="role.id"
        style="display: flex; justify-content: space-between; align-items: center; padding: 8px 12px; background-color: #f5f5f5; border-radius: 4px; margin-bottom: 8px"
        >
        <span style="font-weight: 500">{{ role.name }}</span>
          <Button
            type="primary"
            size="small"
          danger
            @click="deleteRole(AccountPower!.id, role.id)"
            >删除</Button
          >
        </div>
      </div>
    
    <div style="margin-bottom: 20px">
      <div style="font-weight: bold; margin-bottom: 10px; font-size: 16px">权限列表（按角色分组）</div>
        <div
          v-for="role in AccountPower?.roleList"
          :key="role.id"
        style="margin-bottom: 16px; padding: 12px; border: 1px solid #e8e8e8; border-radius: 4px"
      >
        <div style="font-weight: 500; color: #1890ff; margin-bottom: 8px">{{ role.name }}</div>
        <div style="display: flex; flex-wrap: wrap; gap: 8px">
          <span
            v-for="item in role.permissionList"
            :key="item.id"
            style="display: inline-block; padding: 4px 12px; background-color: #e6f7ff; border: 1px solid #91d5ff; border-radius: 4px; font-size: 12px"
          >
            {{ item.name }}
          </span>
        </div>
      </div>
    </div>
    <div style="display: flex; justify-content: center">
      <Dropdown>
        <Button type="primary">新增角色</Button>
        <template #overlay>
          <Menu>
            <Menu.Item v-for="item in roleList" :key="item.id">
              <Button
                type="text"
                size="small"
                @click="addRole(AccountPower!.id, item.id)"
              >
                {{ item.name }}
              </Button>
            </Menu.Item>
          </Menu>
        </template>
      </Dropdown>
    </div>
  </Modal>
</template>

<style lang="scss" scoped>
.search-wrapped {
  margin-bottom: 20px;

  .search-account {
    font-weight: bolder;
  }

  .search-value {
    width: 300px;
    display: inline-block;
    margin-left: 10px;
  }
}
</style>
