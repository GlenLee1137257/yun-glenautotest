export interface IBasic<T = any> {
  data: T
  code: number
  msg: string | null
}

export interface IBasicWithPage<T> extends Omit<IBasic<T>, 'data'> {
  data: {
    total_page: number
    total_record: number
    current_data: T[]
  }
}

export type ToRaw<T extends unknown[]> = T extends Array<infer R> ? R : never

export type BodyType =
  | 'X_WWW_FORM_URLENCODED'
  | 'JSON'
  | 'RAW'
  | 'BINARY'
  | 'FORM_DATA'

export type StepItem<T extends { stepList: Record<string, any>[] }> = ToRaw<
  T['stepList']
>
