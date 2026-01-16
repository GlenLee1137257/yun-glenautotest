package com.glen.autotest.controller;

import com.glen.autotest.controller.req.*;
import jakarta.annotation.Resource;
import com.glen.autotest.dto.AccountDTO;
import com.glen.autotest.dto.RoleDTO;
import com.glen.autotest.service.RoleService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Lee
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@RestController
public class RoleController {

    @Resource
    private RoleService roleService;


    /**
     * 给某个角色新增权限
     */
    @PostMapping("/api/permit/v1/role/addPermission")
    public JsonData addPermission(@RequestBody RoleAddPermissionReq req) {
        int rows = roleService.addPermission(req);
        return JsonData.buildSuccess(rows);
    }


    /**
     * 某个角色移除权限
     */
    @PostMapping("/api/permit/v1/role/delPermission")
    public JsonData delPermission(@RequestBody RoleDelPermissionReq req) {
        int rows = roleService.delPermission(req);
        return JsonData.buildSuccess(rows);
    }


    /**
     * 给某个账号新增角色
     */
    @PostMapping("/api/permit/v1/role/addRoleByAccountId")
    public JsonData addRoleByAccountId(@RequestBody AccountRoleAddReq req) {
        int rows = roleService.addRoleByAccountId(req);
        return JsonData.buildSuccess(rows);
    }

    /**
     * 给某个账号移除角色
     */
    @PostMapping("/api/permit/v1/role/delRoleByAccountId")
    public JsonData delRoleByAccountId(@RequestBody AccountRoleDelReq req) {
        int rows = roleService.delRoleByAccountId(req);
        return JsonData.buildSuccess(rows);
    }

    /**
     * 查看全部角色列表
     */
    @GetMapping("/api/permit/v1/role/list")
    public JsonData list() {
        List<RoleDTO> list = roleService.list();
        return JsonData.buildSuccess(list);
    }


    /**
     * 新增角色
     */
    @PostMapping("/api/permit/v1/role/add")
    public JsonData addRole(@RequestBody RoleAddReq addReq){

        int rows = roleService.addRole(addReq);
        return JsonData.buildSuccess(rows);
    }

    /**
     * 删除角色
     */
    @PostMapping("/api/permit/v1/role/delete")
    public JsonData deleteRole(@RequestBody RoleDelReq delReq){

        int rows = roleService.deleteRole(delReq.getId());
        return JsonData.buildSuccess(rows);
    }


    /**
     * 查找某个账号的角色和权限
     */
    @GetMapping("/api/permit/v1/role/findRoleByAccountId")
    public JsonData findRoleByAccountId(@RequestParam("accountId") Long accountId) {
        AccountDTO accountDTO = roleService.getAccountWithRoleByAccountId(accountId);
        return JsonData.buildSuccess(accountDTO);
    }


}
