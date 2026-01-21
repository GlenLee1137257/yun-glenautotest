package com.glen.autotest.dto.dto;

import lombok.Getter;
import lombok.Setter;
import com.glen.autotest.dto.UiCaseStepDTO;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * <p>
 * 
 * </p>
 *
 * @author 小滴课堂-二当家小D,
 * @since 2024-03-02
 */
@Getter
@Setter
public class UiCaseDTO implements Serializable {

    private Long id;

    private Long projectId;

    private Long moduleId;

    private String browser;

    private String name;

    private String description;

    private String level;

    private Integer headlessMode;

    private Date gmtCreate;

    private Date gmtModified;

    private List<UiCaseStepDTO> list;
}
