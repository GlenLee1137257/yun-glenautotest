import type { IDict } from './dict'

export const defualtWithIUICase: IUICase = {
  id: -1,
  moduleId: -1,
  browser: '',
  name: '默认名称',
  level: 'p0',
  status: '未执行',
  description: '无描述',
  createAccountId: 0,
  updateAccountId: 0,
  gmtCreate: new Date(),
  gmtModified: new Date(),
  stepList: [],
}

export interface IUICase {
  id: number
  moduleId: number
  browser: string
  name: string
  level: string
  status: string
  description: string
  createAccountId: number
  updateAccountId: number
  gmtCreate: Date
  gmtModified: Date
  stepList: IUICaseStep[]
}

export const defaultWithIUICaseStep: IUICaseStep = {
  id: -1,
  caseId: -1,
  num: -1,
  name: '默认名称',
  operationType: '',
  locationType: '',
  locationExpress: '',
  elementWait: 0,
  targetLocationType: '',
  targetLocationExpress: '',
  targetElementWait: 0,
  value: '',
  expectKey: '',
  expectValue: '',
  description: '',
  isContinue: false,
  isScreenshot: false,
  createAccountId: -1,
  updateAccountId: -1,
  gmtCreate: new Date(),
  gmtModified: new Date(),
}

export interface IUICaseStep {
  id: number
  caseId: number
  num: number
  name: string
  operationType: string
  locationType: string
  locationExpress: string
  elementWait: number
  targetLocationType: string
  targetLocationExpress: string
  targetElementWait: number
  value: string
  expectKey: string
  expectValue: string
  description: string
  isContinue: boolean
  isScreenshot: boolean
  createAccountId: number
  updateAccountId: number
  gmtCreate: Date
  gmtModified: Date
}

export const defaultWithIUIConstantSelectOptions: IUIConstantSelectOptions = {
  ui_location_type: [],
}

export interface IUIConstantSelectOptions {
  ui_location_type: IDict[]
}
