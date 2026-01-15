package com.glen.autotest.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * 项目数据对象
 */
@Data
@TableName("project")
public class ProjectDO {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long projectAdmin;
    private String name;
    private String description;
    private Date gmtCreate;
    private Date gmtModified;
}
