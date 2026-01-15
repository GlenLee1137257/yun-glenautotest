package com.glen.autotest.dto.api;

import lombok.Data;

import java.util.Date;

/**
 * API用例DTO
 */
@Data
public class ApiCaseDTO {
    private Long id;
    private Long moduleId;
    private String name;
    private String description;
    private Date gmtCreate;
    private Date gmtModified;
}
