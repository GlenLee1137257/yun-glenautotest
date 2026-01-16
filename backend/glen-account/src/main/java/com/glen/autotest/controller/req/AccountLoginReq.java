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
public class AccountLoginReq {



    /**
     * 账号唯一标识
     */
    private String identifier;

    /**
     * 凭证，密码
     */
    private String credential;

    /**
     * 账号类型，手机，邮箱，微信，支付宝等
     */
    private String identityType;
}
