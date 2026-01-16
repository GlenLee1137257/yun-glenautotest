import { type AfterFetchContext, objectPick } from '@vueuse/core'
import type { IPorject, ProjectTableNeeds } from '~/types/apis/project'
import type { IBasic } from '~/types/apis/basic'

export const useGlobalConfigStore = defineStore(
  'global-config',
  () => {
    const config = reactive<{
      projectId: number
      projectDatas: IPorject[]
      projectListDataProxy: ProjectTableNeeds[]
    }>({
      projectId: 1,
      projectDatas: [],
      projectListDataProxy: [],
    })

    const loginToken = ref('')

    const isLogin = computed(() => !!loginToken.value)

    function setLoginToken(token: string) {
      loginToken.value = token
    }

    const {
      isFetching: loadingWithGetProjectDatas,
      execute: fetchGetProjectDatas,
    } = useCustomFetch<IPorject[]>('/engine-service/api/v1/project/list', {
      initialData: [],
      immediate: false,
      afterFetch(ctx: AfterFetchContext<IBasic<IPorject[]>>) {
        if (ctx.data && ctx.data.code === 0) {
          config.projectDatas = ctx.data.data
          config.projectListDataProxy = ctx.data.data.map((item) =>
            objectPick(item, ['id', 'name', 'description', 'projectAdmin']),
          )
          modifyConfig({ projectId: ctx.data.data[0].id })

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

    function modifyConfig(_config: Partial<typeof config>) {
      // @ts-expect-error
      Object.entries(_config).forEach(([key, value]) => (config[key] = value))
    }

    return {
      loginToken,
      isLogin,
      config,
      modifyConfig,
      setLoginToken,
      fetchGetProjectDatas,
      loadingWithGetProjectDatas,
    }
  },
  {
    persist: true,
  },
)
