package com.glen.autotest.dto.common;

import lombok.Data;

import java.util.List;

/**
 * 用例信息DTO
 */
@Data
public class CaseInfoDTO {
    private Long caseId;
    private Long projectId;
    private Long environmentId;
    private List<?> stepList;
}
