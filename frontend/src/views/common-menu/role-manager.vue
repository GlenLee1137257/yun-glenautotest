<script lang="ts" setup>
import {
  Button,
  Divider,
  Dropdown,
  Input,
  Menu,
  Modal,
  Popconfirm,
  Table,
  message,
} from 'ant-design-vue'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { AfterFetchContext } from '@vueuse/core'
import type { IPermissionList, IPerson, IRole } from '~/types/apis/role'
import type { IBasic, IBasicWithPage } from '~/types/apis/basic'

const tableValue: ColumnsType = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id',
    align: 'center',
  },
  {
    title: '名称',
    dataIndex: 'name',
    key: 'name',
    align: 'center',
  },
  {
    title: '编码',
    dataIndex: 'code',
    key: 'code',
    align: 'center',
  },
  {
    title: '操作',
    dataIndex: 'operator',
    key: 'operator',
    align: 'center',
  },
]

//查看全部角色列表
const {
  get,
  data: roleList,
  isFetching,
} = useCustomFetch<IRole[]>('/account-service/api/permit/v1/role/list', {
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
})
async function roleListFetch() {
  await nextTick()
  get().execute()
}

onMounted(() => {
  roleListFetch()
  rolePowerFetch()
})

//删除角色
const { post: executeDeleteReport } = useCustomFetch<IRole[]>(
  '/account-service/api/permit/v1/role/delete',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IRole>>) => {
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
  roleListFetch()
}

//新增角色对话框
const addRole = reactive<{
  name: string
  code: string
  description: string
}>({
  name: '',
  code: '',
  description: '',
})

const openAdd = ref<boolean>(false)

const AddPersonModal = () => {
  openAdd.value = true
}

const handleAdd = () => {
  openAdd.value = false
  handleAddPerson()
}
//新增角色
const { post: executeAddRole } = useCustomFetch<IPerson>(
  '/account-service/api/permit/v1/role/add',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasic<IPerson>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '新增成功！')
      }
      return ctx
    },
  },
)

async function handleAddPerson() {
  await executeAddRole(addRole).execute()
  roleListFetch()
  // await getAccountPower().execute();
}

//编辑权限对话框
const open = ref<boolean>(false)
const handleOk = () => {
  open.value = false
}

//查找角色和权限
const roleValue = reactive<IRole>({
  id: 0,
  name: '',
  code: null,
  description: '',
  permissionList: [],
})

//查找角色和权限
const { get: getRolePower, data: rolePower } = useCustomFetch<IPerson[]>(
  '/account-service/api/permit/v1/permission/list',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasic<IPerson[]>>) => {
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
async function rolePowerFetch() {
  await nextTick()
  getRolePower().execute()
}

const handleEditRole = (role: IRole) => {
  open.value = true
  roleValue.id = role.id
  roleValue.name = role.name
  roleValue.code = role.code
  roleValue.description = role.description
  roleValue.permissionList = role.permissionList.map((permission: IPermissionList) => ({
    ...permission,
  }))
}

//删除权限
const { post: executeDeleteRole } = useCustomFetch<IRole[]>(
  '/account-service/api/permit/v1/role/delPermission',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IRole>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '删除成功！')
      }
      return ctx
    },
  },
)

async function handleDeleteRole(roleId: number, permissionId: number) {
  await executeDeleteRole({
    roleId,
    permissionId,
  }).execute()
  //获取 roleList 最新数据
  await roleListFetch()

  watch(
    () => roleList.value,
    () => {
      //拿到已经改变的数据
      if (roleList.value) {
        const updatedRecord = roleList.value.find((role) => role.id === roleId)
        if (updatedRecord) {
          handleEditRole(updatedRecord)
        }
      }
    },
    { deep: true },
  )
}

//新增权限
const { post: executeAddRolePower } = useCustomFetch<IRole[]>(
  '/account-service/api/permit/v1/role/addPermission',
  {
    immediate: false,
    initialData: [],
    afterFetch: (ctx: AfterFetchContext<IBasicWithPage<IRole>>) => {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '新增成功！')
      }
      return ctx
    },
  },
)

async function handleAddRole(roleId: number, permissionId: number) {
  await executeAddRolePower({
    roleId,
    permissionId,
  }).execute()
  await roleListFetch()

  watch(
    () => roleList.value,
    () => {
      if (roleList.value) {
        const updatedRecord = roleList.value.find((role) => role.id === roleId)
        if (updatedRecord) {
          handleEditRole(updatedRecord)
        }
      }
    },
    { deep: true },
  )
}
</script>

<template>
  <Table :columns="tableValue" :data-source="roleList!" :loading="isFetching">
    <template #bodyCell="{ column, record }">
      <template v-if="column.key === 'operator'">
        <Button type="link" @click="handleEditRole(record as IRole)">编辑权限</Button>
        <Popconfirm title="是否要删除此行？" @confirm="handleDelete((record as IRole).id)">
          <Button type="link">删除</Button>
        </Popconfirm>
      </template>
    </template>
  </Table>
  <div flex items-center>
    <Button type="link" @click="AddPersonModal">+ 新增角色</Button>
  </div>
  <Modal v-model:open="openAdd" @ok="handleAdd">
    <div class="input-wrapped">
      <div style="display: flex; align-items: center">
        <span>名称：</span>
        <Input v-model:value="addRole.name" style="width: 200px" />
      </div>
      <div style="display: flex; align-items: center">
        <span>编码：</span>
        <Input v-model:value="addRole.code" style="width: 200px" />
      </div>
      <div style="display: flex; align-items: center">
        <span>描述：</span>
        <Input v-model:value="addRole.description" style="width: 200px" />
      </div>
    </div>
  </Modal>
  <Modal v-model:open="open" @ok="handleOk" width="900px" :footer="null">
    <div style="padding: 20px">
      <!-- 角色信息 -->
      <div style="margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid #e8e8e8">
        <div style="display: flex; align-items: center; gap: 12px">
          <span style="font-size: 16px; font-weight: bold; color: #1890ff">{{ roleValue.name }}</span>
          <span style="color: #8c8c8c; font-size: 14px">（{{ roleValue.permissionList.length }} 个权限）</span>
        </div>
        <div v-if="roleValue.description" style="margin-top: 8px; color: #666; font-size: 13px">
          {{ roleValue.description }}
        </div>
      </div>

      <!-- 权限列表标题 -->
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px">
        <div style="font-weight: bold; font-size: 15px">权限列表</div>
      <Dropdown>
          <Button type="primary" size="small">+ 新增权限</Button>
        <template #overlay>
            <Menu style="max-height: 400px; overflow-y: auto">
            <Menu.Item v-for="item in rolePower" :key="item.id">
              <Button
                type="text"
                size="small"
                @click="handleAddRole(roleValue.id, item.id)"
                  style="width: 100%; text-align: left"
              >
                {{ item.name }}
              </Button>
            </Menu.Item>
          </Menu>
        </template>
      </Dropdown>
      </div>

      <!-- 权限标签列表 - 采用卡片式布局 -->
      <div 
        style="
          display: flex; 
          flex-wrap: wrap; 
          gap: 12px; 
          max-height: 500px; 
          overflow-y: auto; 
          padding: 16px; 
          background-color: #fafafa; 
          border-radius: 8px;
          border: 1px solid #e8e8e8;
        "
      >
        <div
          v-for="permission in roleValue.permissionList"
          :key="permission.id"
          style="
            display: flex; 
            align-items: center; 
            gap: 8px; 
            padding: 8px 16px; 
            background-color: #ffffff; 
            border: 1px solid #d9d9d9; 
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: all 0.3s;
          "
          class="permission-tag"
        >
          <span style="font-size: 13px; color: #333">{{ permission.name }}</span>
          <Button
            type="text"
            size="small"
            danger
            @click="handleDeleteRole(roleValue.id, permission.id)"
            style="padding: 0 4px; height: 24px; font-size: 12px"
          >
            移除
          </Button>
        </div>
        <div 
          v-if="roleValue.permissionList.length === 0"
          style="
            width: 100%; 
            text-align: center; 
            padding: 40px; 
            color: #999; 
            font-size: 14px;
          "
        >
          暂无权限，请点击上方"新增权限"按钮添加
        </div>
      </div>
    </div>
  </Modal>
</template>

<style lang="scss" scoped>
.input-wrapped {
  height: 120px;
  width: 400px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
}

.permission-tag {
  &:hover {
    border-color: #1890ff !important;
    box-shadow: 0 4px 8px rgba(24, 144, 255, 0.15) !important;
    transform: translateY(-2px);
  }
}
</style>
