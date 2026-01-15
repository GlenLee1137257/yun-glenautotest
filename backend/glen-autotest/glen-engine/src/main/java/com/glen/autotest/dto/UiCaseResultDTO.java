package com.glen.autotest.dto;

import lombok.Data;

import java.util.List;

/**
 * UI用例结果DTO
 */
@Data
public class UiCaseResultDTO {
    private Long caseId;
    private String caseName;
    private Boolean success;
    private List<UiCaseStepResultDTO> stepList;
}
