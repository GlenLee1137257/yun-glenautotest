package com.glen.autotest.dto;

import lombok.Data;

/**
 * API用例结果项DTO
 */
@Data
public class ApiCaseResultItemDTO {
    private Long reportId;
    private Long stepId;
    private String stepName;
    private Boolean success;
    private String message;
    private Long expendTime;
    private Boolean executeState;
    private Boolean assertionState;
    private String exceptionMsg;
    private String responseBody;
    private String responseHeaders;
    private ApiCaseStepDTO apiCaseStep;
}
