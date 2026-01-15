package com.glen.autotest.dto;

import lombok.Data;

/**
 * UI用例步骤结果DTO
 */
@Data
public class UiCaseStepResultDTO {
    private Long stepId;
    private String stepName;
    private Boolean success;
    private String message;
}
