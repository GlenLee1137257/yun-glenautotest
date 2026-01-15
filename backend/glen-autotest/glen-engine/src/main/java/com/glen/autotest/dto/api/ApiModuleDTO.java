package com.glen.autotest.dto.api;

import lombok.Data;

import java.util.Date;

/**
 * API模块DTO
 */
@Data
public class ApiModuleDTO {
    private Long id;
    private Long projectId;
    private String name;
    private Date gmtCreate;
    private Date gmtModified;
}
