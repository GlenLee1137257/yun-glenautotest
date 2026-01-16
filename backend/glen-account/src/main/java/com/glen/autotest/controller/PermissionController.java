package com.glen.autotest.controller;

import jakarta.annotation.Resource;
import com.glen.autotest.dto.PermissionDTO;
import com.glen.autotest.service.PermissionService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@RestController
public class PermissionController {

    @Resource
    private PermissionService permissionService;


    /**
     * 获取全部权限
     */
    @GetMapping("/api/permit/v1/permission/list")
    public JsonData getAllPermission() {
        List<PermissionDTO> list = permissionService.list();
        return JsonData.buildSuccess(list);
    }



}
