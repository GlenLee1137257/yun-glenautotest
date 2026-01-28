import { createFetch } from '@vueuse/core'
import { message } from 'ant-design-vue'
//测试 ip
// export const baseUrl = 'http://192.168.3.138:8000'
//线上 ip
// export const baseUrl = 'http://120.25.217.15:8000'
// 使用相对路径，通过 Nginx 代理到网关
export const baseUrl = ''

export const useCustomFetch = createFetch({
  baseUrl,
  options: {
    afterFetch(ctx) {
      if (ctx.data) {
        ctx.data = JSON.parse(ctx.data)
        if (ctx.data.code !== 0) {
          message.error(ctx.data.msg ?? ctx.data.message)
        }
      }
      return ctx
    },
    beforeFetch({ options, url }) {
      const globalConfigStore = useGlobalConfigStore()
      if (!options.method) return

      if (globalConfigStore.isLogin) {
        options.headers = {
          ...options.headers,
          satoken: `${globalConfigStore.loginToken}`,
        }

        // 获取 projectId，如果无效则不添加到请求中
        const projectId = globalConfigStore.config.projectId
        const isValidProjectId = projectId != null && projectId !== undefined && !isNaN(Number(projectId)) && projectId > 0

        if (
          ['POST', 'PUT'].includes(options.method.toUpperCase()) &&
          options.body
        ) {
          const bodyData = JSON.parse(options.body as string)
          // 只有当 projectId 有效时才添加
          if (isValidProjectId) {
            bodyData.projectId = projectId
          }
          options.body = JSON.stringify(bodyData)
        } else if (options.method === 'GET') {
          // 只有当 projectId 有效且 URL 中不包含 projectId 参数时才添加
          // 对于某些不需要 projectId 的接口（如登录、获取用户信息等），避免强制添加
          if (isValidProjectId && !url.includes('projectId=') && !url.includes('/login') && !url.includes('findLoginAccountRole')) {
          url = handleParams(url, {
              projectId: projectId,
          })
          }
        }
      }

      return {
        url,
        options,
      }
    },
  },
  fetchOptions: {
    headers: {
      'Content-Type': 'application/json',
    },
  },
})
