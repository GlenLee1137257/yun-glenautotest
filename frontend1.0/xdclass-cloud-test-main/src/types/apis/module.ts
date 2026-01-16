export const defaultApiModule: IModule = {
  id: -1,
  projectId: -1,
  name: '',
  createAccountId: -1,
  updateAccountId: -1,
  gmtCreate: new Date(),
  gmtModified: new Date(),
  list: null,
}

export interface IModule<T = null, R = T extends null ? null : T[]> {
  id: number
  projectId: number
  name: string
  createAccountId: number
  updateAccountId: number
  gmtCreate: Date
  gmtModified: Date
  list: R
}
