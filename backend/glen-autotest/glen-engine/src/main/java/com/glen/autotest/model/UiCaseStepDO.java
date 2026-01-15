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
    
    // 元素定位相关
    private String locationType;
    private String locationExpress;
    private Long elementWait;
    
    // 目标元素定位（用于拖拽等操作）
    private String targetLocationType;
    private String targetLocationExpress;
    private Long targetElementWait;
    
    // 期望值（用于断言）
    private String expectValue;
    
    private Date gmtCreate;
    private Date gmtModified;
}
