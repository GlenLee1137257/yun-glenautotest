package com.glen.autotest.controller.common;

import jakarta.annotation.Resource;
import com.glen.autotest.req.common.PlanJobDelReq;
import com.glen.autotest.req.common.PlanJobPageReq;
import com.glen.autotest.req.common.PlanJobSaveReq;
import com.glen.autotest.req.common.PlanJobUpdateReq;
import com.glen.autotest.service.common.PlanJobService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/plan_job")
public class PlanJobController {


    @Resource
    private PlanJobService planJobService;


    /**
     * 分页接口
     */
    @PostMapping("page")
    public JsonData page(@RequestBody PlanJobPageReq req){
        Map<String,Object> pageInfo = planJobService.page(req);
        return JsonData.buildSuccess(pageInfo);
    }


    /**
     * 新增
     */
    @PostMapping("save")
    public JsonData save(@RequestBody PlanJobSaveReq req){

        int rows = planJobService.save(req);
        return JsonData.buildSuccess(rows);
    }


    /**
     * 更新
     */
    @PostMapping("update")
    public JsonData update(@RequestBody PlanJobUpdateReq req){

        int rows = planJobService.update(req);
        return JsonData.buildSuccess(rows);
    }

    /**
     * 删除
     */
    @PostMapping("del")
    public JsonData del(@RequestBody PlanJobDelReq req){

        int rows = planJobService.del(req);
        return JsonData.buildSuccess(rows);
    }


}
