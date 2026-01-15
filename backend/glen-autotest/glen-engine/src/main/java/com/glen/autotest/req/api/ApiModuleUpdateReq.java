package com.glen.autotest.req.api;

import lombok.Data;

/**
 * API模块更新请求
 */
@Data
public class ApiModuleUpdateReq {
    private Long id;
    private Long projectId;
    private String name;
}
