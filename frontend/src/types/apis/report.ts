export interface IReport {
  id: number
  projectId: number
  caseId: number
  type: string
  name: string
  executeState: string
  startTime: number
  endTime: number
  expandTime: number
  quantity: number
  passQuantity: number
  failQuantity: number
  summary: string
  gmtCreate: Date
  gmtModified: Date
}

export interface IReportDetails {
  id: number
  reportId: number
  assertInfo: string
  errorCount: number
  errorPercentage: number
  maxTime: number
  meanTime: number
  minTime: number
  receiveKBPerSecond: number
  sentKBPerSecond: number
  requestLocation: string
  requestHeader: string
  requestBody: string
  requestRate: number
  responseCode: string
  responseData: string
  responseHeader: string
  samplerCount: number
  samplerLabel: string
  threadCount: number
  sampleTime: number
  gmtCreate: string
  gmtModified: string
}

// 接口测试报告详情
export interface IApiReportDetail {
  id: number
  reportId: number
  executeState: boolean
  assertionState: boolean
  exceptionMsg: string
  expendTime: number
  requestHeader: string
  requestQuery: string
  requestBody: string
  responseHeader: string
  responseBody: string
  environmentId: number
  caseId: number
  num: number
  name: string
  description: string
  assertion: string // JSON字符串
  relation: string // JSON字符串
  path: string
  method: string
  query: string
  header: string
  body: string
  bodyType: string
  gmtCreate: string
  gmtModified: string
}
