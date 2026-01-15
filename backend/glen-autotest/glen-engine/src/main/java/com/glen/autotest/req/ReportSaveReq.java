package com.glen.autotest.req;

import lombok.Data;

/**
 * 报告保存请求
 */
@Data
public class ReportSaveReq {
    private Long planJobId;
    private String name;
    private Integer state;
    private String result;
}
