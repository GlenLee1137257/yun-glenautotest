export interface IPorject {
  id: number
  projectAdmin: number
  projectAdminName?: string
  name: string
  description: string
  createAccountId: number
  updateAccountId: number
  gmtCreate: Date
  gmtModified: Date
}

export type ProjectTableNeeds = Pick<
  IPorject,
  'id' | 'name' | 'description' | 'projectAdmin' | 'projectAdminName'
>
