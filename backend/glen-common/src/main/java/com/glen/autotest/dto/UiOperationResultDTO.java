package com.glen.autotest.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UiOperationResultDTO {

    /**
     * 操作的状态
     */
    private Boolean operationState;

    /**
     * 操作类型
     */
    private String operationType;


    /**
     * 期望内容
     */
    private Object expectValue;

    /**
     * 实际内容
     */
    private Object actualValue;

}
