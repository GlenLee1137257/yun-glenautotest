package com.glen.autotest.controller.api;

import jakarta.annotation.Resource;
import com.glen.autotest.req.api.ApiCaseDelReq;
import com.glen.autotest.req.api.ApiCaseSaveReq;
import com.glen.autotest.req.api.ApiCaseUpdateReq;
import com.glen.autotest.service.api.ApiCaseService;
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
@RequestMapping("/api/v1/api_case")
public class ApiCaseController {

    @Resource
    private ApiCaseService apiCaseService;

    /**
     * 根据id查找用例
     */
    @GetMapping("/find")
    public JsonData find(@RequestParam("projectId") Long projectId, @RequestParam("id") Long id) {
        return JsonData.buildSuccess(apiCaseService.getById(projectId, id));
    }

    /**
     * 保存
     */
    @PostMapping("/save")
    public JsonData save(@RequestBody ApiCaseSaveReq req) {
        return JsonData.buildSuccess(apiCaseService.save(req));
    }

    /**
     * 修改
     */
    @PostMapping("/update")
    public JsonData update(@RequestBody ApiCaseUpdateReq req) {
        return JsonData.buildSuccess(apiCaseService.update(req));
    }

    /**
     * 删除
     */
    @PostMapping("/del")
    public JsonData delete(@RequestBody ApiCaseDelReq req) {
        return JsonData.buildSuccess(apiCaseService.del(req.getProjectId(), req.getId()));
    }


    @GetMapping("execute")
    public JsonData execute(@RequestParam("projectId") Long projectId, @RequestParam("id") Long caseId){
        return apiCaseService.execute(projectId,caseId);
    }


}
