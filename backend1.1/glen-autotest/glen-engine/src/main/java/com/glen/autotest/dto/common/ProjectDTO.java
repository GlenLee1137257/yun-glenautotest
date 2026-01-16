package com.glen.autotest.dto.common;

import lombok.Data;

import java.util.Date;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Lee
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class ProjectDTO {

    private Long id;

    private Long projectAdmin;

    /**
     * 项目管理员用户名
     */
    private String projectAdminName;

    private String name;

    private String description;

    private Date gmtCreate;

    private Date gmtModified;
}
