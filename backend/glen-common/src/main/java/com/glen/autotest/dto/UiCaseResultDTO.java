package com.glen.autotest.dto;

import lombok.Data;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class UiCaseResultDTO {

    private Long reportId;

    private Boolean executeState;

    private Long startTime;

    private Long endTime;

    private Long expendTime;

    private Integer quantity;

    private Integer passQuantity;

    private Integer failQuantity;

    private List<UiCaseResultItemDTO> list;
}
