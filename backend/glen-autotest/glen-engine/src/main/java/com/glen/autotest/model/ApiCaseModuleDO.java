package com.glen.autotest.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * API用例模块数据对象
 */
@Data
@TableName("api_case_module")
public class ApiCaseModuleDO {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long projectId;
    private String name;
    private Date gmtCreate;
    private Date gmtModified;
}
