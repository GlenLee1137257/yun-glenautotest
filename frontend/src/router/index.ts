import { createRouter, createWebHashHistory } from 'vue-router/auto'
import { message } from 'ant-design-vue'

const router = createRouter({
  history: createWebHashHistory(),
})

type RouteMeta = {
  title: string
  path?: string
  children?: Record<string, RouteMeta>
}

export const routerMetas: Record<string, RouteMeta> = {
  '': {
    title: '首页',
    path: '/home',
    children: {
      'common-menu': {
        title: '公共菜单',
        children: {
          'environment-manager': {
            title: '环境管理',
            path: '/common-menu/environment-manager',
          },
          'project-manager': {
            title: '项目管理',
            path: '/common-menu/project-manager',
          },
          'user-manager': {
            title: '用户管理',
            path: '/common-menu/user-manager',
          },
          'role-manager': {
            title: '角色管理',
            path: '/common-menu/role-manager',
          },
        },
      },
      'interface-automation': {
        title: '接口自动化',
        children: {
          case: {
            title: '用例管理',
            path: '/interface-automation/case',
            children: {
              'new-or-edit': {
                title: '新建/编辑页面',
                path: '/interface-automation/case/new-or-edit',
              },
            },
          },
          manager: {
            title: '接口管理',
            path: '/interface-automation/manager',
            children: {
              'new-or-edit': {
                title: '新建/编辑页面',
                path: '/interface-automation/manager/new-or-edit',
              },
            },
          },
        },
      },
      'ui-automation': {
        title: 'UI自动化',
        children: {
          elements: {
            title: '元素库管理',
            path: '/ui-automation/elements',
            children: {
              'new-or-edit': {
                title: '新建/编辑页面',
                path: '/ui-automation/elements/new-or-edit',
              },
            },
          },
          case: {
            title: '用例管理',
            path: '/ui-automation/case',
            children: {
              'new-or-edit': {
                title: '新建/编辑页面',
                path: '/ui-automation/case/new-or-edit',
              },
            },
          },
        },
      },
      'stress-test': {
        title: '压测引擎',
        children: {
          manager: {
            title: '用例管理',
            path: '/stress-test/manager',
            children: {
              'new-or-edit': {
                title: '新建/编辑页面',
                path: '/stress-test/manager/new-or-edit',
              },
            },
          },
        },
      },
      report: {
        title: '测试报告',
        children: {
          details: {
            title: '报告详情',
            path: '/report/details',
          },
          ui: {
            title: 'UI测试',
            path: '/report/ui',
          },
          interface: {
            title: '接口测试',
            path: '/report/interface',
          },
          stress: {
            title: '压力测试',
            path: '/report/stress',
          },
        },
      },
      'test-plan': {
        title: '测试计划',
        children: {
          manager: {
            title: '定时计划',
            path: '/test-plan/time-plan',
          },
        },
      },
    },
  },
}

router.beforeEach((to, from, next) => {
  const globalConfigStore = useGlobalConfigStore()
  const permissionStore = usePermissionStore()
  const token = to.query.token
  if ((token?.length ?? 0) >= 16) {
    globalConfigStore.setLoginToken(token as string)
  }

  if (
    globalConfigStore.isLogin &&
    (to.path === '/login' || to.path === '/register')
  ) {
    return next('/home')
  }

  if (
    !globalConfigStore.isLogin &&
    to.path !== '/login' &&
    to.path !== '/register'
  ) {
    return next('/login')
  }
  const foundRoles = permissionStore.roles.roleList?.filter((role) =>
    role.permissionList.some(
      (permission) => permission.code === 'PROJECT_AUTH',
    ),
  )

  if (foundRoles && foundRoles.length > 0) {
    next()
  } else if (to.path === '/common-menu/role-manager') {
    message.error('无此权限')
    next('/home')
  } else {
    next()
  }
})

export function getMetaTitleFromRoute(routes: string[]): [string, string][] {
  function getTitle(
    routeArray: string[],
    currentRouteMetas: Record<string, RouteMeta>,
    returnArray: [string, string][] = [],
  ) {
    if (routeArray.length === 0) {
      return returnArray
    } else {
      const route = routeArray[0]?.replace(/\?.+/, '')
      if (currentRouteMetas[route]) {
        return getTitle(
          routeArray.slice(1),
          currentRouteMetas[route].children || {},
          returnArray.concat([
            [
              currentRouteMetas[route].title,
              currentRouteMetas[route].path ?? 'unreachable',
            ],
          ]),
        )
      } else {
        return returnArray
      }
    }
  }

  return getTitle(routes, routerMetas)
}

export default router
