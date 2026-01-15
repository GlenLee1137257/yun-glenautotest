package com.glen.autotest.dto;

import lombok.Data;

/**
 * API用例结果项DTO
 */
@Data
public class ApiCaseResultItemDTO {
    private Long stepId;
    private String stepName;
    private Boolean success;
    private String message;
}
