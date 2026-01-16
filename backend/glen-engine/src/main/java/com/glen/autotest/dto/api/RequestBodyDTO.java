package com.glen.autotest.dto.api;

import lombok.AllArgsConstructor;
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
@AllArgsConstructor
@NoArgsConstructor
public class RequestBodyDTO {

    private String body;

    private String bodyType;
}
