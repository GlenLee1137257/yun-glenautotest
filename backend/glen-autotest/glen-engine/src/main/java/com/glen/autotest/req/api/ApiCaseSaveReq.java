package com.glen.autotest.req.api;

import lombok.Data;

/**
 * API用例保存请求
 */
@Data
public class ApiCaseSaveReq {
    private Long projectId;
    private Long moduleId;
    private String name;
    private String description;
}
