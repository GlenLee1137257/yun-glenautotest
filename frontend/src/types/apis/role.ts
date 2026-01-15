export interface IPermissionList {
  id: number
  name: string
  code: null
  description: string
}

export interface IRole {
  id: number
  name: string
  code: null
  description: string
  permissionList: IPermissionList[]
}

export interface IPerson {
  id: number
  name: string
  code: string
  description: string
}
