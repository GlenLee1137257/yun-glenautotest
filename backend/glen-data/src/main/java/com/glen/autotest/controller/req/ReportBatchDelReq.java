package com.glen.autotest.controller.req;

import lombok.Data;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description 批量删除测试报告请求对象
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class ReportBatchDelReq {

    /**
     * 项目id
     */
    private Long projectId;

    /**
     * 记录id列表
     */
    private List<Long> ids;

    /**
     * 类型
     */
    private String type;

}
