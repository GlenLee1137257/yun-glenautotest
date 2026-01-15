package com.glen.autotest.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * API用例步骤数据对象
 */
@Data
@TableName("api_case_step")
public class ApiCaseStepDO {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long caseId;
    private String name;
    private String base;
    private String path;
    private String method;
    private String query;
    private String header;
    private String body;
    private String bodyType;
    private String assertion;
    private String relation;
    private Integer sort;
    private Date gmtCreate;
    private Date gmtModified;
}
