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
public class ApiJsonAssertionDTO {

    private String from;

    private String type;

    private String action;

    private String express;

    private String value;
}
