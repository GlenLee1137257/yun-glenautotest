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
 * UI元素实体类
 *
 * @Description UI元素数据对象
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Getter
@Setter
@TableName("glen_ui.ui_element")
@Schema(name = "UiElementDO", description = "UI元素")
public class UiElementDO implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "所属项目ID")
    @TableField("project_id")
    private Long projectId;

    @Schema(description = "所属UI元素模块ID")
    @TableField("module_id")
    private Long moduleId;

    @Schema(description = "UI元素名称")
    @TableField("name")
    private String name;

    @Schema(description = "UI元素描述")
    @TableField("description")
    private String description;

    @Schema(description = "UI元素定位类型")
    @TableField("location_type")
    private String locationType;

    @Schema(description = "UI元素定位表达式")
    @TableField("location_express")
    private String locationExpress;

    @Schema(description = "元素查找最长等待时间")
    @TableField("element_wait")
    private Long elementWait;

    @Schema(description = "创建时间")
    @TableField("gmt_create")
    private Date gmtCreate;

    @Schema(description = "更新时间")
    @TableField("gmt_modified")
    private Date gmtModified;
}
