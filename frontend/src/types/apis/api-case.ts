import { objectOmit } from '@vueuse/core'
import { type IApi, defaultWithIApi } from './api'
import type { IDict } from './dict'

export const defaultWithIApiCase: IApiCase = {
  id: 0,
  moduleId: -1,
  name: '',
  description: '',
  level: 'p0',
  isSyncSession: true,
  isSyncCookie: true,
  createAccountId: 0,
  updateAccountId: 0,
  gmtCreate: '',
  gmtModified: '',
  stepList: [],
}

export interface IApiCase {
  id: number
  moduleId: number
  name: string
  description: string
  level: string
  isSyncSession: boolean
  isSyncCookie: boolean
  createAccountId: number
  updateAccountId: number
  gmtCreate: string
  gmtModified: string
  stepList: IApiCaseStep[]
}

export const defaultWithIApiCaseStep: IApiCaseStep = {
  ...objectOmit(defaultWithIApi, ['moduleId']),
  caseId: 0,
  num: 0,
  assertion: '[]',
  relation: '[]',
}

export type IApiCaseStep = Omit<IApi, 'moduleId'> & {
  caseId: number
  num: number
  assertion: string
  relation: string
}

export const defaultWithIApiCaseStepAssertion: IApiCaseStepAssertion = {
  from: 'response_code',
  type: 'regexp',
  action: 'equal',
  express: '',
  value: '',
}

export interface IApiCaseStepAssertion {
  from: 'response_code' | 'response_header' | 'response_body'
  type: 'regexp' | 'jsonpath'
  action:
    | 'contain'
    | 'not_contain'
    | 'equal'
    | 'not_equal'
    | 'great_then'
    | 'less_then'
  express: string
  value: string
}

export const defaultWithIApiCaseStepRelation: IApiCaseStepRelation = {
  from: 'request_header',
  type: 'regexp',
  express: '',
  name: '',
}

export interface IApiCaseStepRelation {
  from:
    | 'request_header'
    | 'request_body'
    | 'request_query'
    | 'response_header'
    | 'response_body'
  type: 'regexp' | 'jsonpath'
  express: string
  name: string
}

export const defaultWithIApiConstantSelectOptions: IApiConstantSelectOptions = {
  api_relation_type: [],
  api_relation_from: [],
  api_assertion_type: [],
  api_assertion_from: [],
  api_assertion_action: [],
}

export interface IApiConstantSelectOptions {
  api_relation_type: IDict[]
  api_relation_from: IDict[]
  api_assertion_type: IDict[]
  api_assertion_from: IDict[]
  api_assertion_action: IDict[]
}
