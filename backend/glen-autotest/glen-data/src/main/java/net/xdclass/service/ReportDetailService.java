package com.glen.autotest.service;

import com.glen.autotest.controller.req.ReportDetailPageReq;

import java.util.Map;

public interface ReportDetailService {

    void handleStressReportDetail(String topicContent);

    void handleApiReportDetail(String topicContent);

    void handleUiReportDetail(String topicContent);

    Map<String, Object> page(ReportDetailPageReq req);
}
