package com.glen.autotest.service.ui;

import com.glen.autotest.dto.dto.UiElementModuleDTO;
import com.glen.autotest.req.ui.UiElementModuleSaveReq;
import com.glen.autotest.req.ui.UiElementModuleUpdateReq;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素模块Service接口
 * @Author Glen Team
 * @Version 1.0
 **/
public interface UiElementModuleService {
    List<UiElementModuleDTO> list(Long projectId);

    UiElementModuleDTO getById(Long projectId, Long moduleId);

    Integer save(UiElementModuleSaveReq req);

    Integer update(UiElementModuleUpdateReq req);

    Integer delete(Long projectId, Long id);
}
