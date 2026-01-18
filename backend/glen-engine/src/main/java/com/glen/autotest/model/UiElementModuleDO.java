package com.glen.autotest.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.util.Date;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * Glen AutoTest Platform
 * UI元素模块实体类
 *
 * @Description UI元素模块数据对象
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Getter
@Setter
@TableName("glen_ui.ui_element_module")
@Schema(name = "UiElementModuleDO", description = "UI元素模块")
public class UiElementModuleDO implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "所属项目ID")
    @TableField("project_id")
    private Long projectId;

    @Schema(description = "UI元素模块名称")
    @TableField("name")
    private String name;

    @Schema(description = "模块描述")
    @TableField("description")
    private String description;

    @Schema(description = "创建时间")
    @TableField("gmt_create")
    private Date gmtCreate;

    @Schema(description = "更新时间")
    @TableField("gmt_modified")
    private Date gmtModified;
}
