package com.glen.autotest.dto.common;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.v3.oas.annotations.media.Schema;
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
public class ProjectDTO {

    private Long id;

    private Long projectAdmin;

    private String projectAdminName;

    private String name;

    private String description;

    private Date gmtCreate;

    private Date gmtModified;
}
