package com.glen.autotest.controller.ui;

import io.swagger.v3.core.util.Json;
import jakarta.annotation.Resource;
import com.glen.autotest.dto.dto.UiCaseDTO;
import com.glen.autotest.req.ui.UiCaseDelReq;
import com.glen.autotest.req.ui.UiCaseSaveReq;
import com.glen.autotest.req.ui.UiCaseUpdateReq;
import com.glen.autotest.service.ui.UiCaseService;
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
@RequestMapping("/api/v1/ui_case")
public class UiCaseController {

    @Resource
    private UiCaseService uiCaseService;

    @RequestMapping("/update")
    public JsonData update(@RequestBody UiCaseUpdateReq req)
    {
        return JsonData.buildSuccess(uiCaseService.update(req));
    }

    @RequestMapping("/del")
    public JsonData delete(@RequestBody UiCaseDelReq req)
    {
        return JsonData.buildSuccess(uiCaseService.delete(req));
    }



    @RequestMapping("/find")
    public JsonData find(@RequestParam("projectId") Long projectId, @RequestParam("id") Long caseId)
    {
        UiCaseDTO uiCaseDTO = uiCaseService.find(projectId, caseId);
        return JsonData.buildSuccess(uiCaseDTO);
    }

    /**
     * 新增
     */
    @RequestMapping("/save")
    public JsonData save(@RequestBody UiCaseSaveReq req)
    {
        return JsonData.buildSuccess(uiCaseService.save(req));
    }



    @GetMapping("/execute")
    public JsonData execute(@RequestParam("projectId") Long projectId, @RequestParam("id") Long caseId){

        JsonData jsonData = uiCaseService.execute(projectId, caseId);

        return  jsonData;
    }

}
