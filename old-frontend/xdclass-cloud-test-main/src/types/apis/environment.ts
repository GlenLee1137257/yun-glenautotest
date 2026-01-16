export interface IEnvironment {
  id: number
  name: string
  port: number
  domain: string
  protocol: string
  projectId: number
  description: string
  createAccountId: number
  updateAccountId: number
  gmtCreate: Date
  gmtModified: Date
}

export type EnvironmentTableNeeds = Omit<
  IEnvironment,
  'createAccountId' | 'updateAccountId' | 'gmtCreate' | 'gmtModified'
>
