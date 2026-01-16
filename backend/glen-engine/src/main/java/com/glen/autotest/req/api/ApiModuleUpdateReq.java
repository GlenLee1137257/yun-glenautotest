package com.glen.autotest.req.api;

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
public class ApiModuleUpdateReq {

    private Long id;

    private Long projectId;

    private String name;
}
