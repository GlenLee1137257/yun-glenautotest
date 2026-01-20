package com.glen.autotest.controller.req;

import lombok.Data;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class ReportPageReq {

    private Long page;

    private Long size;

    /**
     * 项目id
     */
    private Long projectId;

    /**
     * 用例id
     */
    private Long caseId;

    /**
     * 报告id
     */
    private Long reportId;

    /**
     * 用例类型，API, UI STRESS
     */
    private String type;

    /**
     * 用例名称
     */
    private String name;

    /**
     * 开始时间
     */
    private String startTime;

    /**
     * 结束时间
     */
    private String endTime;

}
