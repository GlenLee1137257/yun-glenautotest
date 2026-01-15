export const defaultWithIUIElement: IUIElement = {
  id: -1,
  moduleId: -1,
  name: '默认名称',
  description: '无描述',
  locationType: '',
  locationExpress: '',
  createAccountId: -1,
  updateAccountId: -1,
  gmtCreate: new Date(),
  gmtModified: new Date(),
}

export interface IUIElement {
  id: number
  moduleId: number
  name: string
  locationType: string
  locationExpress: string
  description: string
  createAccountId: number
  updateAccountId: number
  gmtCreate: Date
  gmtModified: Date
}

export interface IOperation {
  id: number
  category: string
  categoryName: string
  name: string
  value: string
  extend: string
  remark: null // waiting backend
}
