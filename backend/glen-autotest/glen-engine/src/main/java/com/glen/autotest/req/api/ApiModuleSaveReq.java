package com.glen.autotest.req.api;

import lombok.Data;

/**
 * API模块保存请求
 */
@Data
public class ApiModuleSaveReq {
    private Long projectId;
    private String name;
}
