package com.glen.autotest.dto;

import lombok.Data;

import java.util.List;

/**
 * API用例结果DTO
 */
@Data
public class ApiCaseResultDTO {
    private Long reportId;
    private Long caseId;
    private String caseName;
    private Boolean success;
    private Long startTime;
    private Long endTime;
    private Long expendTime;
    private Integer quantity;
    private Integer passQuantity;
    private Integer failQuantity;
    private Boolean executeState;
    private List<Object> list;
    private List<ApiCaseResultItemDTO> itemList;
}
