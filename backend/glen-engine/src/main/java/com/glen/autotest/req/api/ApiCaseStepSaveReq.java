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
public class ApiCaseStepSaveReq {


    private Long projectId;

    private Long environmentId;

    private Long caseId;

    private Long apiId;

    private Boolean useApiLibrary;

    private Long num;

    private String name;

    private String description;

    private String assertion;

    private String relation;

    private String path;

    private String method;

    private String query;

    private String header;

    private String body;

    private String bodyType;

}
