package com.glen.autotest.dto.dto;

import lombok.Data;
import java.util.Date;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素DTO
 * @Author Glen Team
 * @Version 1.0
 **/
@Data
public class UiElementDTO {
    private Long id;
    private Long projectId;
    private Long moduleId;
    private String name;
    private String description;
    private String locationType;
    private String locationExpress;
    private Long elementWait;
    private Date gmtCreate;
    private Date gmtModified;
}
