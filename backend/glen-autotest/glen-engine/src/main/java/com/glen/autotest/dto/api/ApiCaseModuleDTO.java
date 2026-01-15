package com.glen.autotest.dto.api;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * API用例模块DTO
 */
@Data
public class ApiCaseModuleDTO {
    private Long id;
    private Long projectId;
    private String name;
    private Date gmtCreate;
    private Date gmtModified;
    private List<ApiCaseDTO> list;
}
