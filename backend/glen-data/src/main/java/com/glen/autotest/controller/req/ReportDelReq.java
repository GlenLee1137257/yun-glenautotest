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
public class ReportDelReq {


    /**
     * 项目id
     */
    private Long projectId;

    /**
     * 记录id
     */
    private Long id;

    /**
     * 类型
     */
    private String type;

}
