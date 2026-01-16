package com.glen.autotest.controller.api;

import jakarta.annotation.Resource;
import com.glen.autotest.req.api.ApiCaseDelReq;
import com.glen.autotest.req.api.ApiCaseSaveReq;
import com.glen.autotest.req.api.ApiCaseUpdateReq;
import com.glen.autotest.service.api.ApiCaseService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
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
    @PostMapping("/delete")
    public JsonData delete(@RequestBody ApiCaseDelReq req) {
        return JsonData.buildSuccess(apiCaseService.del(req.getProjectId(), req.getId()));
    }


    @GetMapping("execute")
    public JsonData execute(@RequestParam("projectId") Long projectId, @RequestParam("id") Long caseId){
        return apiCaseService.execute(projectId,caseId);
    }


}
