<script lang="ts" setup>
import {
  Avatar,
  Badge,
  Breadcrumb,
  Button,
  type ItemType,
  Layout,
  LayoutContent,
  LayoutHeader,
  LayoutSider,
  Menu,
  Tooltip,
  message,
} from 'ant-design-vue'
import {
  ApartmentOutlined,
  AppstoreOutlined,
  CodeSandboxOutlined,
  HomeOutlined,
  MenuFoldOutlined,
  MenuOutlined,
  MenuUnfoldOutlined,
  ToolOutlined,
  UsbOutlined,
  UserOutlined,
} from '@ant-design/icons-vue'
import { getMetaTitleFromRoute } from '~/router'
import { ExexecuteList } from '../types/apis/execute'
import type { MenuInfo } from 'ant-design-vue/es/menu/src/interface'

const globalConfigStore = useGlobalConfigStore()
const permissionStore = usePermissionStore()
const route = useRoute()
const router = useRouter()

const openKeys = ref<string[]>([])
const selectedKeys = ref<string[]>([])
const breadcrumb = ref<[string, string][]>([])
const [collapsed, toggleCollapsed] = useToggle()

const items = reactive<ItemType[]>([
  {
    key: '/home',
    icon: () => h(HomeOutlined),
    title: '首页',
    label: '首页',
  },
  {
    key: 'common-menu',
    icon: () => h(MenuOutlined),
    title: '公共菜单',
    label: '公共菜单',
    children: [
      {
        key: '/common-menu/project-manager',
        title: '项目管理',
        label: '项目管理',
      },
      {
        key: '/common-menu/environment-manager',
        title: '环境管理',
        label: '环境管理',
      },
      {
        key: '/common-menu/user-manager',
        title: '用户管理',
        label: '用户管理',
      },
      {
        key: '/common-menu/role-manager',
        title: '角色管理',
        label: '角色管理',
      },
    ],
  },
  {
    key: 'interface-automation',
    icon: () => h(UsbOutlined),
    title: '接口自动化',
    label: '接口自动化',
    children: [
      {
        key: '/interface-automation/manager',
        title: '接口管理',
        label: '接口管理',
      },
      {
        key: '/interface-automation/case',
        title: '用例管理',
        label: '用例管理',
      },
    ],
  },
  {
    key: 'ui-automation',
    icon: () => h(AppstoreOutlined),
    title: 'UI自动化',
    label: 'UI自动化',
    children: [
      // {
      //   key: '/ui-automation/elements',
      //   title: '元素库管理',
      //   label: '元素库管理',
      // },
      {
        key: '/ui-automation/case',
        title: '用例管理',
        label: '用例管理',
      },
    ],
  },
  {
    key: 'stress-test',
    icon: () => h(ApartmentOutlined),
    title: '压测引擎',
    label: '压测引擎',
    children: [
      {
        key: '/stress-test/manager',
        title: '用例管理',
        label: '用例管理',
      },
    ],
  },
  {
    key: 'report',
    title: '测试报告',
    label: '测试报告',
    icon: () => h(CodeSandboxOutlined),
    children: [
      {
        key: '/report/stress',
        title: '压力测试',
        label: '压力测试',
      },
      {
        key: '/report/interface',
        title: '接口测试',
        label: '接口测试',
      },
      {
        key: '/report/ui',
        title: 'UI测试',
        label: 'UI测试',
      },
    ],
  },
  {
    key: 'test-plan',
    title: '测试计划',
    label: '测试计划',
    icon: () => h(ToolOutlined),
    children: [
      {
        key: '/test-plan/time-plan',
        title: '定时计划',
        label: '定时计划',
      },
    ],
  },
])

function handleMenuClick(info: MenuInfo) {
  router.push(info.key.toString())
}

watch(
  () => route,
  () => {
    if (route.fullPath !== '/') {
      openKeys.value = [route.fullPath.split('/')[1]]
    }
    if (route.fullPath === '/') {
      selectedKeys.value = ['/']
      breadcrumb.value = [['首页', '/']]
    } else {
      const arr = route.fullPath.split('/')
      selectedKeys.value = [`/${arr[1]}/${arr[2]?.replace(/\?.+/, '')}`]
      breadcrumb.value = getMetaTitleFromRoute(arr)
    }
  },
  {
    deep: true,
    immediate: true,
  },
)

//退出登录
const { get } = useCustomFetch(`/account-service/api/v1/account/logout`, {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
    if (ctx.data && ctx.data.code === 0) {
      message.success('退出成功')
      // 清除 Pinia 中的数据
      globalConfigStore.setLoginToken('')
      globalConfigStore.config.projectId = null as any
      globalConfigStore.config.projectDatas = null as any
      globalConfigStore.config.projectListDataProxy = null as any
      // 清除 localStorage 中的数据
      localStorage.clear()
      // 清除权限数据
      permissionStore.roles = '' as any
      // 跳转到首页
      router.push('/')
    } else if (ctx.data && ctx.data.code === 500) {
      // 处理 token 失效情况，例如跳转到登录页
      message.error('登录已失效，请重新登录')
      // 清除 Pinia 中的数据
      globalConfigStore.setLoginToken('')
      globalConfigStore.config.projectId = null as any
      globalConfigStore.config.projectDatas = null as any
      globalConfigStore.config.projectListDataProxy = null as any
      // 清除 localStorage 中的数据
      localStorage.clear()
      // 清除权限数据
      permissionStore.roles = '' as any
      router.push('/login') // 假设登录页路由为 '/login'
    } else {
      message.error('退出失败')
    }
    return ctx
  },
})

const logout = async () => {
  await nextTick()
  get().execute()
}
</script>

<template>
  <Layout min-h="100vh 100dvh!">
    <LayoutSider v-model:collapsed="collapsed" :trigger="null" collapsible>
      <h1
        cursor-pointer
        flex="~  justify-center"
        transition="opacity duration-300"
        class="my opacity-100 hover:opacity-65"
      >
        <RouterLink class="text-white!" to="/">
          {{ !collapsed ? '小滴自动化云测平台' : '云测' }}
        </RouterLink>
      </h1>
      <Menu
        v-model:selectedKeys="selectedKeys"
        v-model:open-keys="openKeys"
        theme="dark"
        mode="inline"
        :items="items"
        @click="handleMenuClick"
      />
    </LayoutSider>
    <Layout>
      <LayoutHeader
        style="background: #fff"
        p="x!"
        flex
        items-center
        justify-between
      >
        <div flex items-center>
          <div
            cursor-pointer
            px
            text-xl
            hover="text-blue"
            @click="() => toggleCollapsed()"
          >
            <menu-unfold-outlined v-if="collapsed" />
            <menu-fold-outlined v-else />
          </div>

          <Breadcrumb>
            <Breadcrumb.Item
              v-for="([title, path], index) in breadcrumb"
              :key="path"
            >
              <RouterLink
                v-if="path !== 'unreachable' && index !== breadcrumb.length - 1"
                :to="path"
              >
                {{ title }}
              </RouterLink>
              <span v-else>{{ title }}</span>
            </Breadcrumb.Item>
          </Breadcrumb>
        </div>

        <div flex items-center space-x-4>
          <LayoutHeaderConfig />
          <Tooltip color="white">
            <template #title>
              <Button type="link" @click="logout">退出登录</Button>
            </template>
            <Badge :count="1">
              <Avatar shape="circle">
                <template #icon>
                  <UserOutlined />
                </template>
              </Avatar>
            </Badge>
          </Tooltip>
        </div>
      </LayoutHeader>
      <LayoutContent
        :style="{ margin: '24px 16px', padding: '24px', background: '#fff' }"
      >
        <slot />
      </LayoutContent>
    </Layout>
  </Layout>
</template>
