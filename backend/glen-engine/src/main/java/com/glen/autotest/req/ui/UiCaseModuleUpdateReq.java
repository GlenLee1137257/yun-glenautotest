package com.glen.autotest.req.ui;

import lombok.Data;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class UiCaseModuleUpdateReq {

    private Long projectId;

    private Long id;


    private String name;
}
