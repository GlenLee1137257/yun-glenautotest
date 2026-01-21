package com.glen.autotest.controller.ui;

import jakarta.annotation.Resource;
import com.glen.autotest.req.ui.UiCaseStepDelReq;
import com.glen.autotest.req.ui.UiCaseStepSaveReq;
import com.glen.autotest.req.ui.UiCaseStepUpdateReq;
import com.glen.autotest.service.ui.UiCaseStepService;
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
@RequestMapping("/api/v1/ui_case_step")
public class UiCaseStepController {

    @Resource
    private UiCaseStepService uiCaseStepService;

    @PostMapping("/save")
    public JsonData save(@RequestBody UiCaseStepSaveReq req)
    {
        return JsonData.buildSuccess(uiCaseStepService.save(req));
    }

    @PostMapping("/update")
    public JsonData update(@RequestBody UiCaseStepUpdateReq req)
    {
        return JsonData.buildSuccess(uiCaseStepService.update(req));
    }

    @PostMapping("/delete")
    public JsonData delete(@RequestBody UiCaseStepDelReq req)
    {
        return JsonData.buildSuccess(uiCaseStepService.delete(req));
    }
}
