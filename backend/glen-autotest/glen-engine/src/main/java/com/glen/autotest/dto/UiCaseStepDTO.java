package com.glen.autotest.dto;

import lombok.Data;

/**
 * UI用例步骤DTO
 */
@Data
public class UiCaseStepDTO {
    private Long id;
    private Long caseId;
    private String name;
    private String operationType;
    private String operation;
    private String element;
    private String value;
    private Integer sort;
    
    // 元素定位相关
    private String locationType;
    private String locationExpress;
    private Long elementWait;
    
    // 目标元素定位
    private String targetLocationType;
    private String targetLocationExpress;
    private Long targetElementWait;
    
    // 期望值
    private String expectValue;
    
    // 截图标志
    private Integer isScreenshot;
    
    // 失败后是否继续
    private Integer isContinue;
}
