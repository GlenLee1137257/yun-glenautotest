package com.glen.autotest.controller.api;

import jakarta.annotation.Resource;
import com.glen.autotest.req.api.ApiModuleDelReq;
import com.glen.autotest.req.api.ApiModuleSaveReq;
import com.glen.autotest.req.api.ApiModuleUpdateReq;
import com.glen.autotest.service.api.ApiModuleService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/api_module")
public class ApiModuleController {

    @Resource
    private ApiModuleService apiModuleService;

    @GetMapping("/list")
    public JsonData list(Long projectId) {
        return JsonData.buildSuccess(apiModuleService.list(projectId));
    }

    /**
     * 根据id查找
     */
    @GetMapping("/find")
    public JsonData find(@RequestParam("projectId") Long projectId, @RequestParam("moduleId") Long moduleId) {
        return JsonData.buildSuccess(apiModuleService.getById(projectId,moduleId));
    }

    /**
     * 根据projectId和moduleId删除用例模块
     */
    @PostMapping("/delete")
    public JsonData delete(@RequestBody ApiModuleDelReq req) {
        return JsonData.buildSuccess(apiModuleService.delete(req.getId(),req.getProjectId()));
    }


    /**
     * 保存
     */
    @PostMapping("/save")
    public JsonData save(@RequestBody ApiModuleSaveReq req) {
        return JsonData.buildSuccess(apiModuleService.save(req));
    }


    /**
     * 更新
     */
    @PostMapping("/update")
    public JsonData update(@RequestBody ApiModuleUpdateReq req) {
        return JsonData.buildSuccess(apiModuleService.update(req));
    }


}
