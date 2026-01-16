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
public class AccountPageReq {

    private Long page;

    private Long size;

    /**
     * 支持根据名称搜索
     */
    private String username;
}
