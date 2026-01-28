<script lang="ts" setup>
import {
  Avatar,
  Badge,
  Breadcrumb,
  Button,
  Dropdown,
  Divider,
  type ItemType,
  Layout,
  LayoutContent,
  LayoutHeader,
  LayoutSider,
  Menu,
  Tag,
  Tooltip,
  message,
} from 'ant-design-vue'
import {
  ApartmentOutlined,
  AppstoreOutlined,
  CodeSandboxOutlined,
  CodeOutlined,
  HomeOutlined,
  LogoutOutlined,
  MenuFoldOutlined,
  MenuOutlined,
  MenuUnfoldOutlined,
  SettingOutlined,
  ToolOutlined,
  UsbOutlined,
  UserOutlined,
} from '@ant-design/icons-vue'
import { getMetaTitleFromRoute } from '~/router'
import type { ExexecuteList } from '../types/apis/execute'
import type { MenuInfo } from 'ant-design-vue/es/menu/src/interface'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'

const globalConfigStore = useGlobalConfigStore()
const permissionStore = usePermissionStore()
const route = useRoute()
const router = useRouter()

const openKeys = ref<string[]>([])
const selectedKeys = ref<string[]>([])
const breadcrumb = ref<[string, string][]>([])
const [collapsed, toggleCollapsed] = useToggle()

// 获取用户信息
const userDisplayName = computed(() => {
  const { userInfo } = permissionStore
  return userInfo.username || userInfo.phone || userInfo.mail || '用户'
})

// 获取用户名首字母（用于头像）
const userAvatar = computed(() => {
  const name = userDisplayName.value
  if (name === '用户') return 'U'
  // 如果是中文，取第一个字
  if (/[\u4e00-\u9fa5]/.test(name[0])) {
    return name[0]
  }
  // 如果是英文或数字，取第一个字母并大写
  return name[0].toUpperCase()
})

// 获取用户角色列表
const userRoles = computed(() => {
  return permissionStore.roles.roleList || []
})

// 获取主要角色（显示第一个角色）
const primaryRole = computed(() => {
  if (userRoles.value.length > 0) {
    return userRoles.value[0].name
  }
  return '普通用户'
})

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
      {
        key: '/ui-automation/elements',
        title: '元素库管理',
        label: '元素库管理',
      },
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
    title: '性能测试',
    label: '性能测试',
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
        key: '/report/interface',
        title: '接口测试',
        label: '接口测试',
      },
      {
        key: '/report/ui',
        title: 'UI测试',
        label: 'UI测试',
      },
      {
        key: '/report/stress',
        title: '性能测试',
        label: '性能测试',
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
      // 重置为默认值而不是 null，避免接口请求时出现 projectId=null 的情况
      globalConfigStore.config.projectId = 1  // 使用默认值 1 而不是 null
      globalConfigStore.config.projectDatas = []
      globalConfigStore.config.projectListDataProxy = []
      // 清空用户信息和角色信息
      permissionStore.userInfo = { username: '', phone: '', mail: '' }
      permissionStore.roles = { roleList: [] }
      // 清除 localStorage 中的数据
      localStorage.clear()
      // 清除权限数据
      permissionStore.roles = '' as any
      // 跳转到登录页
      router.push('/login')
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
    <LayoutSider 
      v-model:collapsed="collapsed" 
      :trigger="null" 
      collapsible
      :style="{ position: 'fixed', top: 0, left: 0, height: '100vh', zIndex: 100 }"
    >
      <div class="logo-container">
        <RouterLink to="/" class="logo-link">
          <div class="logo-icon-wrapper">
            <div class="logo-icon">
              <CodeOutlined class="logo-svg-icon" />
            </div>
          </div>
          <transition name="logo-text">
            <div v-if="!collapsed" class="logo-text">
              <span class="logo-title">Glen</span>
              <span class="logo-subtitle">云测平台</span>
            </div>
          </transition>
        </RouterLink>
      </div>
      <Menu
        v-model:selectedKeys="selectedKeys"
        v-model:open-keys="openKeys"
        theme="dark"
        mode="inline"
        :items="items"
        @click="handleMenuClick"
      />
    </LayoutSider>
    <Layout :style="{ marginLeft: collapsed ? '80px' : '200px', transition: 'margin-left 0.2s' }">
      <LayoutHeader
        :style="{ 
          background: '#fff', 
          position: 'fixed', 
          top: 0, 
          right: 0, 
          left: collapsed ? '80px' : '200px', 
          zIndex: 99,
          transition: 'left 0.2s' 
        }"
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
          
          <!-- 用户头像下拉菜单 -->
          <Dropdown placement="bottomRight">
            <div class="user-avatar-wrapper">
              <Avatar 
                class="user-avatar" 
                :style="{ 
                  backgroundColor: '#1890ff', 
                  cursor: 'pointer',
                  fontSize: '16px',
                  fontWeight: 'bold'
                }"
              >
                {{ userAvatar }}
              </Avatar>
              <div class="user-info">
                <div class="user-name">{{ userDisplayName }}</div>
                <Tag 
                  :color="primaryRole === '超级管理员' ? 'red' : primaryRole === '项目管理员' ? 'blue' : 'green'" 
                  class="user-role-tag"
                  size="small"
                >
                  {{ primaryRole }}
                </Tag>
              </div>
            </div>
            
            <template #overlay>
              <Menu class="user-dropdown-menu">
                <!-- 用户信息展示 -->
                <div class="dropdown-user-info">
                  <Avatar 
                    :size="48"
                    :style="{ 
                      backgroundColor: '#1890ff',
                      fontSize: '20px',
                      fontWeight: 'bold'
                    }"
                  >
                    {{ userAvatar }}
                  </Avatar>
                  <div class="dropdown-user-details">
                    <div class="dropdown-user-name">{{ userDisplayName }}</div>
                    <div class="dropdown-user-account">
                      {{ permissionStore.userInfo.phone || permissionStore.userInfo.mail || '暂无账号信息' }}
                    </div>
                  </div>
                </div>
                
                <Divider style="margin: 8px 0" />
                
                <!-- 角色列表 -->
                <Menu.ItemGroup title="我的角色">
                  <Menu.Item v-for="role in userRoles" :key="role.id" disabled>
                    <Tag 
                      :color="role.name === '超级管理员' ? 'red' : role.name === '项目管理员' ? 'blue' : 'green'"
                      style="margin: 0"
                    >
                      {{ role.name }}
                    </Tag>
                  </Menu.Item>
                  <Menu.Item v-if="userRoles.length === 0" disabled>
                    <span style="color: #999">暂无角色</span>
                  </Menu.Item>
                </Menu.ItemGroup>
                
                <Divider style="margin: 8px 0" />
                
                <!-- 操作菜单 -->
                <Menu.Item key="profile">
                  <UserOutlined />
                  <span style="margin-left: 8px">个人信息</span>
                </Menu.Item>
                <Menu.Item key="settings">
                  <SettingOutlined />
                  <span style="margin-left: 8px">账号设置</span>
                </Menu.Item>
                <Menu.Item key="logout" @click="logout" danger>
                  <LogoutOutlined />
                  <span style="margin-left: 8px">退出登录</span>
                </Menu.Item>
              </Menu>
                </template>
          </Dropdown>
        </div>
      </LayoutHeader>
      <LayoutContent
        :style="{ margin: '88px 16px 24px 16px', padding: '24px', background: '#fff' }"
      >
        <slot />
      </LayoutContent>
    </Layout>
  </Layout>
</template>

<style scoped>
/* 统一侧边栏背景色为深蓝色 */
:deep(.ant-layout-sider) {
  background: #0f172a !important;
  overflow-y: auto;
  overflow-x: hidden;
}

/* 侧边栏滚动条样式 */
:deep(.ant-layout-sider)::-webkit-scrollbar {
  width: 6px;
}

:deep(.ant-layout-sider)::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

:deep(.ant-layout-sider)::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

:deep(.ant-layout-sider)::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

:deep(.ant-menu-dark) {
  background: transparent !important;
}

:deep(.ant-menu-dark .ant-menu-item-selected) {
  background: rgba(37, 99, 235, 0.3) !important;
  border-radius: 8px;
}

:deep(.ant-menu-dark .ant-menu-item:hover) {
  background: rgba(37, 99, 235, 0.2) !important;
  border-radius: 8px;
}

:deep(.ant-menu-dark .ant-menu-submenu-title:hover) {
  background: rgba(37, 99, 235, 0.2) !important;
  border-radius: 8px;
}

.logo-container {
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
  background: transparent;
}

.logo-link {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  text-decoration: none;
  width: 100%;
  transition: all 0.3s ease;
}

.logo-link:hover {
  transform: translateY(-1px);
}

.logo-icon-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.logo-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 50%, #2563eb 100%);
  border-radius: 12px;
  padding: 8px;
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.4), 0 0 0 2px rgba(255, 255, 255, 0.1);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.logo-icon::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.2) 0%, rgba(255, 255, 255, 0.1) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.logo-link:hover .logo-icon::before {
  opacity: 1;
}

.logo-link:hover .logo-icon {
  transform: scale(1.05) rotate(5deg);
  box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
}

.logo-svg-icon {
  font-size: 24px;
  color: #ffffff;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
}

.logo-text {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  overflow: hidden;
}

.logo-title {
  font-size: 20px;
  font-weight: 700;
  color: #ffffff;
  letter-spacing: 0.5px;
  line-height: 1.2;
  text-shadow: 0 2px 8px rgba(37, 99, 235, 0.4);
  background: linear-gradient(135deg, #ffffff 0%, #dbeafe 50%, #bfdbfe 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  position: relative;
}

.logo-subtitle {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.75);
  font-weight: 400;
  letter-spacing: 0.3px;
  line-height: 1.2;
  margin-top: 2px;
}

/* 文字淡入淡出动画 */
.logo-text-enter-active,
.logo-text-leave-active {
  transition: all 0.3s ease;
  opacity: 1;
  transform: translateX(0);
}

.logo-text-enter-from {
  opacity: 0;
  transform: translateX(-10px);
}

.logo-text-leave-to {
  opacity: 0;
  transform: translateX(-10px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .logo-icon {
    width: 36px;
    height: 36px;
    padding: 6px;
  }

  .logo-title {
    font-size: 18px;
  }

  .logo-subtitle {
    font-size: 11px;
  }
}

/* ========== 用户头像区域样式 ========== */
.user-avatar-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: #f5f5f5;
}

.user-avatar-wrapper:hover {
  background: #e8e8e8;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.user-avatar {
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.2);
  transition: all 0.3s ease;
}

.user-avatar-wrapper:hover .user-avatar {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.user-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0; /* 允许flex收缩 */
}

.user-name {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  line-height: 1.2;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.user-role-tag {
  font-size: 11px !important;
  line-height: 16px !important;
  padding: 0 6px !important;
  border-radius: 4px !important;
  white-space: nowrap;
}

/* ========== 下拉菜单样式 ========== */
.user-dropdown-menu {
  min-width: 260px;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  padding: 8px 0;
}

.dropdown-user-info {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 16px 8px;
}

.dropdown-user-details {
  flex: 1;
  min-width: 0;
}

.dropdown-user-name {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  line-height: 1.4;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.dropdown-user-account {
  font-size: 12px;
  color: #999;
  line-height: 1.4;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 下拉菜单项样式优化 */
:deep(.user-dropdown-menu .ant-menu-item-group-title) {
  padding: 8px 16px;
  font-size: 12px;
  color: #999;
  font-weight: 600;
  text-transform: uppercase;
}

:deep(.user-dropdown-menu .ant-menu-item) {
  margin: 2px 8px;
  border-radius: 6px;
  padding: 8px 12px;
  height: auto;
  line-height: 1.5;
}

:deep(.user-dropdown-menu .ant-menu-item:hover) {
  background-color: #f5f5f5;
}

:deep(.user-dropdown-menu .ant-menu-item-danger:hover) {
  background-color: #fff1f0;
  color: #ff4d4f;
}

:deep(.user-dropdown-menu .ant-menu-item-danger .anticon) {
  color: #ff4d4f;
}
</style>
