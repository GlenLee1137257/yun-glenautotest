package com.glen.autotest.dto.api;

import lombok.Data;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class ApiJsonRelationDTO {

    /**
     * 取值来源， header,body
     */
    private String from;

    /**
     * 类型， jsonpath, regexp
     */
    private String type;

    /**
     * 表达式
     */
    private String express;

    /**
     * 取出来变量名称
     */
    private String name;
}
