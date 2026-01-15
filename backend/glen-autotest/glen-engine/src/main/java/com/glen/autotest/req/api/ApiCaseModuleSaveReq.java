package com.glen.autotest.req.api;

import lombok.Data;

/**
 * API用例模块保存请求
 */
@Data
public class ApiCaseModuleSaveReq {
    private Long projectId;
    private String name;
}
