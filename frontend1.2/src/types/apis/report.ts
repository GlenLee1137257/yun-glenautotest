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
