package com.glen.autotest.dto;

import lombok.Data;

/**
 * API用例步骤DTO
 */
@Data
public class ApiCaseStepDTO {
    private Long id;
    private Long caseId;
    private String name;
    private String base;
    private String path;
    private String method;
    private String query;
    private String header;
    private String body;
    private String bodyType;
    private String assertion;
    private String relation;
    private Integer sort;
}
