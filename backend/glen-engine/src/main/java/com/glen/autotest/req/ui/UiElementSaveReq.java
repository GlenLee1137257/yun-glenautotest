package com.glen.autotest.req.ui;

import lombok.Data;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素保存请求
 * @Author Glen Team
 * @Version 1.0
 **/
@Data
public class UiElementSaveReq {
    private Long projectId;
    private Long moduleId;
    private String name;
    private String description;
    private String locationType;
    private String locationExpress;
    private Long elementWait;
}
