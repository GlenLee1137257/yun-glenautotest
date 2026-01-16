package com.glen.autotest.controller.common;

import jakarta.annotation.Resource;
import com.glen.autotest.req.common.EnvironmentDelReq;
import com.glen.autotest.req.common.EnvironmentSaveReq;
import com.glen.autotest.req.common.EnvironmentUpdateReq;
import com.glen.autotest.service.common.EnvironmentService;
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
@RequestMapping("/api/v1/env")
public class EnvironmentController {

    @Resource
    private EnvironmentService environmentService;


    @GetMapping("/list")
    public JsonData list(@RequestParam("projectId")Long projectId){
        return JsonData.buildSuccess(environmentService.list(projectId));
    }


    @PostMapping("/save")
    public JsonData save(@RequestBody EnvironmentSaveReq req){
        return JsonData.buildSuccess(environmentService.save(req));
    }


    @PostMapping("/update")
    public JsonData update(@RequestBody EnvironmentUpdateReq req){
        return JsonData.buildSuccess(environmentService.update(req));
    }

    @PostMapping("/del")
    public JsonData delete(@RequestBody EnvironmentDelReq req){
        return JsonData.buildSuccess(environmentService.delete(req.getProjectId(),req.getId()));
    }
}
