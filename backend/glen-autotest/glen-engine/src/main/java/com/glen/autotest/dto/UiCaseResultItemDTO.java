package com.glen.autotest.dto;

import lombok.Data;

/**
 * UI用例结果项DTO
 */
@Data
public class UiCaseResultItemDTO {
    private Long reportId;
    private Long stepId;
    private String stepName;
    private Boolean success;
    private String message;
    private String screenshotUrl;
    private Long duration;
    private Long expendTime;
    private Boolean executeState;
    private Integer assertionState;
    private String exceptionMsg;
    private UiCaseStepDTO uiCaseStep;
}
