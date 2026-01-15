package com.glen.autotest.req.api;

import lombok.Data;

/**
 * API用例模块更新请求
 */
@Data
public class ApiCaseModuleUpdateReq {
    private Long id;
    private Long projectId;
    private String name;
}
