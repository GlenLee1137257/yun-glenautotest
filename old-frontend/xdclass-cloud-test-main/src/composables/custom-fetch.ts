import { createFetch } from '@vueuse/core'
import { message } from 'ant-design-vue'
//测试 ip
// export const baseUrl = 'http://192.168.3.138:8000'
//线上 ip
// export const baseUrl = 'http://120.25.217.15:8000'
export const baseUrl = 'http://localhost:8000'

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

        if (
          ['POST', 'PUT'].includes(options.method.toUpperCase()) &&
          options.body
        ) {
          options.body = JSON.stringify({
            ...JSON.parse(options.body as string),
            projectId: globalConfigStore.config.projectId,
          })
        } else if (options.method === 'GET') {
          url = handleParams(url, {
            projectId: globalConfigStore.config.projectId,
          })
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
