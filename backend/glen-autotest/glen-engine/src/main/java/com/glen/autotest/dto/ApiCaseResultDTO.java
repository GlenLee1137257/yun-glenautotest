package com.glen.autotest.dto;

import lombok.Data;

import java.util.List;

/**
 * API用例结果DTO
 */
@Data
public class ApiCaseResultDTO {
    private Long caseId;
    private String caseName;
    private Boolean success;
    private List<ApiCaseResultItemDTO> itemList;
}
