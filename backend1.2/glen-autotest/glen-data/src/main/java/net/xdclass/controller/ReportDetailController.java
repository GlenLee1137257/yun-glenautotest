package com.glen.autotest.controller;

import jakarta.annotation.Resource;
import com.glen.autotest.controller.req.ReportDetailPageReq;
import com.glen.autotest.service.ReportDetailService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/report_detail")
public class ReportDetailController {

    @Resource
    private ReportDetailService reportDetailService;


    /**
     * 分页查询接口
     */
    @PostMapping("page")
    public JsonData page(@RequestBody ReportDetailPageReq req){

        Map<String,Object> pageMap = reportDetailService.page(req);
        return JsonData.buildSuccess(pageMap);
    }

}
