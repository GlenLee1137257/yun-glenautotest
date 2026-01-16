package com.glen.autotest.controller.api;

import jakarta.annotation.Resource;
import com.glen.autotest.req.api.ApiCaseStepDelReq;
import com.glen.autotest.req.api.ApiCaseStepSaveReq;
import com.glen.autotest.req.api.ApiCaseStepUpdateReq;
import com.glen.autotest.service.api.ApiCaseStepService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/api_case_step")
public class ApiCaseStepController {

    @Resource
    private ApiCaseStepService apiCaseStepService;

    /**
     * 保存接口
     */
    @PostMapping("/save")
    public JsonData save(@RequestBody ApiCaseStepSaveReq req) {
        return JsonData.buildSuccess(apiCaseStepService.save(req));
    }

    /**
     * 修改接口
     */
    @PostMapping("/update")
    public JsonData update(@RequestBody ApiCaseStepUpdateReq req) {
        return JsonData.buildSuccess(apiCaseStepService.update(req));
    }


    /**
     * 删除接口
     */
    @PostMapping("/delete")
    public JsonData delete(@RequestBody ApiCaseStepDelReq req) {
        return JsonData.buildSuccess(apiCaseStepService.del(req.getProjectId(), req.getId()));
    }

}
