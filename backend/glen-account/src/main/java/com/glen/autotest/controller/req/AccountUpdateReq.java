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
public class AccountUpdateReq {
    private Long id;
    /**
     * 账号的状态
     */
    private Boolean enabled;
}
