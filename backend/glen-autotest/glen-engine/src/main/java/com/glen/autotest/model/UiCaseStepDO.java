package com.glen.autotest.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * UI用例步骤数据对象
 */
@Data
@TableName("ui_case_step")
public class UiCaseStepDO {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long caseId;
    private String name;
    private String operationType;
    private String operation;
    private String element;
    private String value;
    private Integer sort;
    private Date gmtCreate;
    private Date gmtModified;
}
