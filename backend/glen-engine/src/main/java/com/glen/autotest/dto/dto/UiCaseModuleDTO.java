package com.glen.autotest.dto.dto;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class UiCaseModuleDTO {


    private Long id;

    private Long projectId;

    private String name;

    private Date gmtCreate;

    private Date gmtModified;

    private List<UiCaseDTO> list;
}
