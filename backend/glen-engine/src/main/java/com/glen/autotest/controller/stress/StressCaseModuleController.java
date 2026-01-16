package com.glen.autotest.controller.stress;

import jakarta.annotation.Resource;
import com.glen.autotest.req.stress.StressCaseModuleDelReq;
import com.glen.autotest.req.stress.StressCaseModuleSaveReq;
import com.glen.autotest.req.stress.StressCaseModuleUpdateReq;
import com.glen.autotest.service.stress.StressCaseModuleService;
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
@RequestMapping("/api/v1/stress_case_module")
public class StressCaseModuleController {

    @Resource
    private StressCaseModuleService stressCaseModuleService;


    @GetMapping("list")
    public JsonData list(@RequestParam("projectId")Long projectId){
        return JsonData.buildSuccess(stressCaseModuleService.list(projectId));
    }

    @GetMapping("find")
    public JsonData findById(@RequestParam("projectId") Long projectId, @RequestParam("moduleId") Long moduleId){
        return JsonData.buildSuccess(stressCaseModuleService.findById(projectId,moduleId));
    }


    @PostMapping("/del")
    public JsonData delete(@RequestBody StressCaseModuleDelReq req){
        return JsonData.buildSuccess(stressCaseModuleService.delete(req.getProjectId(),req.getId()));
    }
    @PostMapping("/save")
    public JsonData save(@RequestBody StressCaseModuleSaveReq req){
        return JsonData.buildSuccess(stressCaseModuleService.save(req));
    }

    @PostMapping("/update")
    public JsonData update(@RequestBody StressCaseModuleUpdateReq req){
        return JsonData.buildSuccess(stressCaseModuleService.update(req));
    }
}
