package com.glen.autotest.controller;

import cn.hutool.http.server.HttpServerResponse;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import com.glen.autotest.controller.req.ReportBatchDelReq;
import com.glen.autotest.controller.req.ReportDelReq;
import com.glen.autotest.controller.req.ReportExportReq;
import com.glen.autotest.controller.req.ReportPageReq;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.ReportExcelDTO;
import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.req.ReportUpdateReq;
import com.glen.autotest.service.ReportService;
import com.glen.autotest.util.ExcelUtil;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;

import java.util.List;
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
@RequestMapping("/api/v1/report")
public class ReportController {

    @Resource
    private ReportService reportService;


    /**
     * 分页接口
     * @param req
     * @return
     */
    @PostMapping("page")
    public JsonData list(@RequestBody ReportPageReq req){

        Map<String,Object> pageInfo  = reportService.page(req);

        return JsonData.buildSuccess(pageInfo);
    }


    /**
     * 删除
     * @param req
     * @return
     */
    @PostMapping("del")
    public JsonData delete(@RequestBody ReportDelReq req){
        try {
            int rows = reportService.delete(req);
            return JsonData.buildSuccess(rows);
        } catch (IllegalArgumentException e) {
            return JsonData.buildError(e.getMessage());
        } catch (Exception e) {
            return JsonData.buildError("删除报告失败：" + e.getMessage());
        }
    }

    /**
     * 批量删除
     * @param req
     * @return
     */
    @PostMapping("batchDel")
    public JsonData batchDelete(@RequestBody ReportBatchDelReq req){
        try {
            int rows = reportService.batchDelete(req);
            return JsonData.buildSuccess(rows);
        } catch (IllegalArgumentException e) {
            return JsonData.buildError(e.getMessage());
        } catch (Exception e) {
            return JsonData.buildError("批量删除报告失败：" + e.getMessage());
        }
    }



    @PostMapping("/save")
    public JsonData save(@RequestBody ReportSaveReq req){

        ReportDTO reportDTO = reportService.save(req);

        return JsonData.buildSuccess(reportDTO);
    }


    @PostMapping("/update")
    public JsonData update(@RequestBody ReportUpdateReq req){

        reportService.updateReportState(req);

        return JsonData.buildSuccess();
    }



    @GetMapping("/export")
    public void exportReport(HttpServletResponse response, ReportExportReq req){
        List<ReportExcelDTO> list = reportService.exportReport(req);
        ExcelUtil.exportExcel(response,list,"测试报告");
    }




}
