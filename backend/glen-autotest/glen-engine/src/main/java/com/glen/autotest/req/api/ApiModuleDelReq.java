package com.glen.autotest.req.api;

import lombok.Data;

/**
 * API模块删除请求
 */
@Data
public class ApiModuleDelReq {
    private Long id;
    private Long projectId;
}
