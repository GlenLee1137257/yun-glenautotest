package com.glen.autotest.req.api;

import com.baomidou.mybatisplus.annotation.TableField;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

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
public class ApiCaseSaveReq {

    private Long projectId;

    private Long moduleId;

    private String name;

    private String description;

    private String level;

    private List<ApiCaseStepSaveReq> list;
}
