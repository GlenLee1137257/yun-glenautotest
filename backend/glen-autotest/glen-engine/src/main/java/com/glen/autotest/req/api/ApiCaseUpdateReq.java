package com.glen.autotest.req.api;

import com.glen.autotest.dto.ApiCaseStepDTO;
import lombok.Data;

import java.util.List;

/**
 * API用例更新请求
 */
@Data
public class ApiCaseUpdateReq {
    private Long id;
    private Long projectId;
    private Long moduleId;
    private String name;
    private String description;
    private List<ApiCaseStepDTO> list;
}
