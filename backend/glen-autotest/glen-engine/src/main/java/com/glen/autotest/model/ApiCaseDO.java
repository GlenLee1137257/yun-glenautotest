package com.glen.autotest.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * API用例数据对象
 */
@Data
@TableName("api_case")
public class ApiCaseDO {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long moduleId;
    private String name;
    private String description;
    private Date gmtCreate;
    private Date gmtModified;
}
