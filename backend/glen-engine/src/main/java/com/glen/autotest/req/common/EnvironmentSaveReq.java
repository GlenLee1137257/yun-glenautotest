package com.glen.autotest.req.common;

import lombok.Data;

import java.util.Date;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class EnvironmentSaveReq {

    private Long projectId;

    private String name;

    private String protocol;

    private String domain;

    private Integer port;

    private String description;

}
