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
  from: 'RESPONSE_CODE',
  type: 'REGEXP',
  action: 'EQUAL',
  express: '',
  value: '',
}

export interface IApiCaseStepAssertion {
  from: 'RESPONSE_CODE' | 'RESPONSE_HEADER' | 'RESPONSE_DATA'
  type: 'REGEXP' | 'JSONPATH'
  action:
    | 'CONTAIN'
    | 'NOT_CONTAIN'
    | 'EQUAL'
    | 'NOT_EQUAL'
    | 'GREAT_THEN'
    | 'LESS_THEN'
  express: string
  value: string
}

export const defaultWithIApiCaseStepRelation: IApiCaseStepRelation = {
  from: 'REQUEST_HEADER',
  type: 'REGEXP',
  express: '',
  name: '',
}

export interface IApiCaseStepRelation {
  from:
    | 'REQUEST_HEADER'
    | 'REQUEST_BODY'
    | 'REQUEST_QUERY'
    | 'RESPONSE_HEADER'
    | 'RESPONSE_DATA'
  type: 'REGEXP' | 'JSONPATH'
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
