package com.glen.autotest.req.api;

import lombok.Data;

/**
 * API用例更新请求
 */
@Data
public class ApiCaseUpdateReq {
    private Long id;
    private Long projectId;
    private Long moduleId;
    private String name;
    private String description;
}
