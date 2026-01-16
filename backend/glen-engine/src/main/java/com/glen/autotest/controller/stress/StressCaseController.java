package com.glen.autotest.controller.stress;

import jakarta.annotation.Resource;
import com.glen.autotest.req.stress.StressCaseDelReq;
import com.glen.autotest.req.stress.StressCaseSaveReq;
import com.glen.autotest.req.stress.StressCaseUpdateReq;
import com.glen.autotest.service.stress.StressCaseService;
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
@RequestMapping("/api/v1/stress_case")
public class StressCaseController {

    @Resource
    private StressCaseService stressCaseService;


    @RequestMapping("find")
    public JsonData findById(@RequestParam("projectId") Long projectId, @RequestParam("id") Long caseId){
        return JsonData.buildSuccess(stressCaseService.findById(projectId,caseId));
    }

    @PostMapping("del")
    public JsonData delete(@RequestBody StressCaseDelReq req){
        return JsonData.buildSuccess(stressCaseService.delete(req.getProjectId(),req.getId()));
    }

    @PostMapping("save")
    public JsonData save(@RequestBody StressCaseSaveReq req){
        return JsonData.buildSuccess(stressCaseService.save(req));
    }

    @RequestMapping("update")
    public JsonData update(@RequestBody StressCaseUpdateReq req){

        return JsonData.buildSuccess(stressCaseService.update(req));
    }

    @GetMapping("/execute")
    public JsonData execute(@RequestParam("projectId") Long projectId,@RequestParam("id") Long caseId){
        stressCaseService.execute(projectId,caseId);
        return JsonData.buildSuccess();
    }

}
