import { type AfterFetchContext, objectPick } from '@vueuse/core'
// import type { IPorject, ProjectTableNeeds } from '~/types/apis/project'
import type { IBasic } from '~/types/apis/basic'
import type { IRole } from '~/types/apis/role'

export const usePermissionStore = defineStore('permission', () => {
  const roles = ref<{ roleList: IRole[] }>({ roleList: [] })
  const userInfo = ref<{ username: string; phone: string; mail: string }>({
    username: '',
    phone: '',
    mail: '',
  })

  // 请求用户角色信息
  const { execute: fetchUserRole } = useCustomFetch<{ roleList: IRole[]; username: string; phone: string; mail: string }>(
    '/account-service/api/v1/account/findLoginAccountRole',
    {
      initialData: { roleList: [], username: '', phone: '', mail: '' },
      immediate: false,
      afterFetch(ctx) {
        if (ctx.data && ctx.data.code === 0) {
          roles.value = { roleList: ctx.data.data.roleList || [] }
          userInfo.value = {
            username: ctx.data.data.username || '',
            phone: ctx.data.data.phone || '',
            mail: ctx.data.data.mail || '',
          }
        }
        return ctx
      },
    },
  )

  // 判断用户是否有权限访问某个页面
  // 判断用户是否有权限访问某个页面
  // function hasPermissionToAccessPage(): boolean {
  //   // 遍历用户角色信息
  //   for (const role of roles.value) {
  //     if (role.name === '项目管理员') {
  //       // 如果用户是项目管理员，具有访问权限
  //       return true
  //     }
  //   }
  //   return false // 用户不是项目管理员，无访问权限
  // }

  // 判断用户是否有权限执行某个操作
  // function hasPermissionToDoAction(action: string): boolean {
  //   // 根据用户角色信息和业务需求进行逻辑判断
  //   // 省略具体的权限判断逻辑，返回 true 或 false
  // }

  return {
    roles,
    userInfo,
    fetchUserRole,
    // hasPermissionToAccessPage,
    // hasPermissionToDoAction,
  }
},
{
  persist: {
    paths: ['roles', 'userInfo'],
  },
})
