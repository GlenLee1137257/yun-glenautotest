import { type IApi, defaultWithIApi } from './api'

export const defaultWithIStressCase: IStressCase = {
  ...defaultWithIApi,
  projectId: -1,
  jmxUrl: '',
  relation: '',
  assertion: '',
  stressSourceType: 'JMX',
  threadGroupConfig: '',
}

export interface IStressCase extends Omit<IApi, 'rest'> {
  jmxUrl: string
  relation: string
  projectId: number
  stressSourceType: string
  assertion: string
  threadGroupConfig: string
}

export const defaultWithIStressCaseRelation: IStressCaseRelation = {
  sourceType: 'csv',
  recycle: true,
  delimiter: ',',
  ignoreFirstLine: true,
  variableNames: 'id, name',
  remoteFilePath: '',
  name: 'CSV 数据集合',
}

export interface IStressCaseRelation {
  sourceType: string
  recycle: boolean
  delimiter: string
  ignoreFirstLine: boolean
  variableNames: string
  remoteFilePath: string
  name: string
}

export const defaultWithIStressCaseAssertion: IStressCaseAssertion = {
  name: '',
  action: 'EQUAL',
  from: 'RESPONSE_CODE',
  value: '200',
}

export interface IStressCaseAssertion {
  name: string
  action: string
  from: string
  value: string
}

export const defaultWithIStressCaseThreadGroupConfig: IStressCaseThreadGroupConfig =
  {
    threadGroupName: '',
    numThreads: 1,
    rampUp: 0,
    loopCount: 1,
    schedulerEnabled: false,
    duration: 0,
    delay: 0,
  }

export interface IStressCaseThreadGroupConfig {
  threadGroupName: string
  numThreads: number
  rampUp: number
  loopCount: number
  schedulerEnabled: boolean
  duration: number
  delay: number
}
