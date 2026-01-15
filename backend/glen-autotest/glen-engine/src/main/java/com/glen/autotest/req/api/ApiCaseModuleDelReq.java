package com.glen.autotest.req.api;

import lombok.Data;

/**
 * API用例模块删除请求
 */
@Data
public class ApiCaseModuleDelReq {
    private Long id;
    private Long projectId;
}
