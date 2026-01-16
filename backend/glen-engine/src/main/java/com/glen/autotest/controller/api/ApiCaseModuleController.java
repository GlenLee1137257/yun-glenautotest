package com.glen.autotest.controller.api;

import jakarta.annotation.Resource;
import com.glen.autotest.req.api.ApiCaseModuleDelReq;
import com.glen.autotest.req.api.ApiCaseModuleSaveReq;
import com.glen.autotest.req.api.ApiCaseModuleUpdateReq;
import com.glen.autotest.service.api.ApiCaseModuleService;
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
@RequestMapping("/api/v1/api_case_module")
public class ApiCaseModuleController {

    @Resource
    private ApiCaseModuleService apiCaseModuleService;

    /**
     * 列表接口
     */
    @GetMapping("/list")
    public JsonData list(@RequestParam("projectId") Long projectId) {
        return JsonData.buildSuccess(apiCaseModuleService.list(projectId));
    }

    /**
     * find查找
     */
    @GetMapping("/find")
    public JsonData find(@RequestParam("projectId") Long projectId, @RequestParam("moduleId") Long moduleId) {
        return JsonData.buildSuccess(apiCaseModuleService.getById(projectId, moduleId));
    }

    /**
     * save保存
     */
    @PostMapping("/save")
    public JsonData save(@RequestBody ApiCaseModuleSaveReq req) {
        return JsonData.buildSuccess(apiCaseModuleService.save(req));
    }

    /**
     * update修改
     */
    @PostMapping("/update")
    public JsonData update(@RequestBody ApiCaseModuleUpdateReq req) {
        return JsonData.buildSuccess(apiCaseModuleService.update(req));
    }


    /**
     * 删除
     */
    @PostMapping("/delete")
    public JsonData delete(@RequestBody ApiCaseModuleDelReq req) {
        return JsonData.buildSuccess(apiCaseModuleService.del(req));
    }

}
