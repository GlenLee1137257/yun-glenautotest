package com.glen.autotest.req.common;

import lombok.Data;

/**
 * 项目更新请求
 */
@Data
public class ProjectUpdateReq {
    private Long id;
    private String name;
    private String description;
}
