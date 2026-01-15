package com.glen.autotest.dto.api;

import com.glen.autotest.dto.ApiCaseStepDTO;
import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * API用例DTO
 */
@Data
public class ApiCaseDTO {
    private Long id;
    private Long projectId;
    private Long moduleId;
    private String name;
    private String description;
    private List<ApiCaseStepDTO> list;
    private Date gmtCreate;
    private Date gmtModified;
}
