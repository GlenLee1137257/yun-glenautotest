package com.glen.autotest.dto.stress;

import com.baomidou.mybatisplus.annotation.TableField;
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
public class StressCaseModuleDTO {

    private Long id;

    private Long projectId;

    private String name;

    private Date gmtCreate;

    private Date gmtModified;

    private List<StressCaseDTO> list;
}
