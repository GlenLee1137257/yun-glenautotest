package com.glen.autotest.req.ui;

import lombok.Data;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素模块保存请求
 * @Author Glen Team
 * @Version 1.0
 **/
@Data
public class UiElementModuleSaveReq {
    private Long projectId;
    private String name;
    private String description;
}
