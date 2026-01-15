package com.glen.autotest.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * UI操作结果DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UiOperationResultDTO {
    private Boolean success;
    private String message;
    private Object data;
    private String operationType;
    private Integer operationState;
    private String actualValue;
}
