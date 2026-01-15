package com.glen.autotest.controller.ui;

import jakarta.annotation.Resource;
import com.glen.autotest.req.ui.UiCaseStepDelReq;
import com.glen.autotest.req.ui.UiCaseStepSaveReq;
import com.glen.autotest.req.ui.UiCaseStepUpdateReq;
import com.glen.autotest.service.ui.UiCaseStepService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/ui_case_step")
public class UiCaseStepController {

    @Resource
    private UiCaseStepService uiCaseStepService;

    @RequestMapping("/save")
    public JsonData save(@RequestBody UiCaseStepSaveReq req)
    {
        return JsonData.buildSuccess(uiCaseStepService.save(req));
    }

    @RequestMapping("/update")
    public JsonData update(@RequestBody UiCaseStepUpdateReq req)
    {
        return JsonData.buildSuccess(uiCaseStepService.update(req));
    }

    @RequestMapping("/del")
    public JsonData delete(@RequestBody UiCaseStepDelReq req)
    {
        return JsonData.buildSuccess(uiCaseStepService.delete(req));
    }
}
