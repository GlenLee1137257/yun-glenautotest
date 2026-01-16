package com.glen.autotest.config;

import cn.dev33.satoken.stp.StpInterface;
import jakarta.annotation.Resource;
import com.glen.autotest.service.PermissionService;
import com.glen.autotest.service.RoleService;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Component
public class StpInterfaceImpl implements StpInterface {

    @Resource
    private RoleService roleService;

    @Resource
    private PermissionService permissionService;

    @Override
    public List<String> getPermissionList(Object loginId, String s) {
        if(loginId == null){
            return new ArrayList<>();
        }
        Long accountId = Long.parseLong(loginId.toString());
        List<String> list = permissionService.findPermissionCodeList(accountId);
        return list;
    }

    @Override
    public List<String> getRoleList(Object loginId, String s) {
        if(loginId == null){
            return new ArrayList<>();
        }
        Long accountId = Long.parseLong(loginId.toString());
        List<String> list = roleService.findRoleCodeList(accountId);
        return list;
    }
}
