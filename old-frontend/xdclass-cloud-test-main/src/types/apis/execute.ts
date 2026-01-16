import type { IUICaseStep } from './ui-case'
import type { IApiCaseStep } from './api-case'

export interface IExexuteList<T extends object> {
  step: T
  expendTime: number
  exceptionMsg: string
  executeState: boolean
  assertionState: boolean
}

export interface IExexute<T extends object> {
  endTime: number
  startTime: number
  expendTime: number
  quantity: number
  passQuantity: number
  failQuantity: number
  executeState: boolean
  list: IExexuteList<T>[]
}

export type ExexecuteList = IUICaseExecuteList | IApiCaseExecuteList

export interface IUICaseExecuteList extends IExexuteList<IUICaseStep> {}

export interface IApiCaseExecuteList extends IExexuteList<IApiCaseStep> {
  responseHeader: {
    name: string
    value: string
  }[]
  responseBody: string
}
