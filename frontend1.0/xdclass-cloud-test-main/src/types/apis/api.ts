import type { BodyType } from './basic'

export const defaultWithIApi: IApi = {
  id: -1,
  moduleId: -1,
  environmentId: -1,
  name: '默认名称',
  description: '无描述',
  level: 'p0',
  path: '/',
  method: 'GET',
  query: '[]',
  rest: '[]',
  header: '[]',
  body: '[]',
  bodyType: 'JSON',
  createAccountId: '',
  updateAccountId: '',
  gmtCreate: new Date(),
  gmtModified: new Date(),
}

export interface IApi {
  id: number
  moduleId: number
  environmentId: number
  name: string
  description?: string
  level: 'p0' | 'p1' | 'p2' | 'p3'
  path: string
  method: string
  query: string
  rest: string
  header: string
  body: string
  bodyType: BodyType
  createAccountId: string
  updateAccountId: string
  gmtCreate: Date
  gmtModified: Date
}
