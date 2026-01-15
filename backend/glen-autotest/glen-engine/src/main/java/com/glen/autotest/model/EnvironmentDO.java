package com.glen.autotest.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * 环境数据对象
 */
@Data
@TableName("environment")
public class EnvironmentDO {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long projectId;
    private String name;
    private String baseUrl;
    private Date gmtCreate;
    private Date gmtModified;
}
