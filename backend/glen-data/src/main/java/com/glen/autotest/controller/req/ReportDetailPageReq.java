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
public class ReportDetailPageReq {

    private Long page;

    private Long size;


    private Long reportId;

    /**
     * 用例类型，API, UI STRESS
     */
    private String type;



}
