package com.glen.autotest.service;

import com.glen.autotest.controller.req.*;
import com.glen.autotest.dto.AccountDTO;
import com.glen.autotest.dto.RoleDTO;

import java.util.List;

public interface RoleService {
    int addPermission(RoleAddPermissionReq req);

    int delPermission(RoleDelPermissionReq req);

    int addRoleByAccountId(AccountRoleAddReq req);

    int delRoleByAccountId(AccountRoleDelReq req);

    List<RoleDTO> list();

    int addRole(RoleAddReq addReq);

    int deleteRole(Long id);

    AccountDTO getAccountWithRoleByAccountId(Long accountId);
}
