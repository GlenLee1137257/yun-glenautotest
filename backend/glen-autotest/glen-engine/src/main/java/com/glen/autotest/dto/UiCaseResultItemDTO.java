package com.glen.autotest.dto;

import lombok.Data;

/**
 * UI用例结果项DTO
 */
@Data
public class UiCaseResultItemDTO {
    private Long stepId;
    private String stepName;
    private Boolean success;
    private String message;
    private String screenshotUrl;
    private Long duration;
}
