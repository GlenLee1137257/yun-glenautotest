package com.glen.autotest.service;

import com.glen.autotest.controller.req.ReportDelReq;
import com.glen.autotest.controller.req.ReportExportReq;
import com.glen.autotest.controller.req.ReportPageReq;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.ReportExcelDTO;
import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.req.ReportUpdateReq;

import java.util.List;
import java.util.Map;

public interface ReportService {
    /**
     * 保存测试报告
     * @param req
     * @return
     */
    ReportDTO save(ReportSaveReq req);

    /**
     * 更新状态
     * @param req
     */
    void updateReportState(ReportUpdateReq req);

    /**
     * 导出报告
     * @param req
     * @return
     */
    List<ReportExcelDTO> exportReport(ReportExportReq req);

    /**
     * 分页查询
     * @param req
     * @return
     */
    Map<String, Object> page(ReportPageReq req);

    /**
     * 删除报告
     * @param req
     * @return
     */
    int delete(ReportDelReq req);
}
