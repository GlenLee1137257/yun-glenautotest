package com.glen.autotest.dto;

import lombok.Data;

/**
 * UI操作结果DTO
 */
@Data
public class UiOperationResultDTO {
    private Boolean success;
    private String message;
    private Object data;
}
