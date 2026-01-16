import type { IModule } from '~/types/apis/module'

export const useTemporaryStore = defineStore('temporary', () => {
  const modules = ref<IModule[]>([])
  const selectedModuleId = useLocalStorage('selectedModuleId', -1)
  const editState = ref<object | null>()

  function setEditState(state: object | null) {
    editState.value = state
  }

  function setSelectedModuleId(id: number) {
    selectedModuleId.value = id
  }

  function setModules(_modules: IModule[]) {
    modules.value = _modules
  }

  return {
    modules,
    editState,
    selectedModuleId,
    setModules,
    setEditState,
    setSelectedModuleId,
  }
})
