export interface IUser {
    id: number,
    account: string,
    username: string,
    state: boolean,
    registerTime: string,
}

export interface IPermissionList {
    id: number,
    name: string,
    code: null,
    description: string
}

export interface IRole {
    id: number,
    name: string,
    code: null,
    description: string,
    permissionList: IPermissionList[]
}


export interface IAccountPower {
    id: number,
    username: string,
    headImg:null,
    isDisabled: boolean,
    gmtCreate: null,
    gmtModified:null,
    roleList: IRole[]
}

