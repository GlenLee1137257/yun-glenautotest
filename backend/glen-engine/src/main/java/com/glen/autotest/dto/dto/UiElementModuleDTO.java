package com.glen.autotest.dto.dto;

import lombok.Data;
import java.util.Date;
import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素模块DTO
 * @Author Glen Team
 * @Version 1.0
 **/
@Data
public class UiElementModuleDTO {
    private Long id;
    private Long projectId;
    private String name;
    private String description;
    private Date gmtCreate;
    private Date gmtModified;
    private List<UiElementDTO> list;
}
