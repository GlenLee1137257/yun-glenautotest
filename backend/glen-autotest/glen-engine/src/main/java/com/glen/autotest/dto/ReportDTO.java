package com.glen.autotest.dto;

import lombok.Data;

/**
 * 报告DTO
 */
@Data
public class ReportDTO {
    private Long id;
    private Long planJobId;
    private String name;
    private Integer state;
    private String result;
}
