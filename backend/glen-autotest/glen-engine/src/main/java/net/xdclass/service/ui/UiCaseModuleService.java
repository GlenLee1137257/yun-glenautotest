package com.glen.autotest.service.ui;

import com.glen.autotest.dto.dto.UiCaseModuleDTO;
import com.glen.autotest.req.ui.UiCaseModuleSaveReq;
import com.glen.autotest.req.ui.UiCaseModuleUpdateReq;

import java.util.List;

public interface UiCaseModuleService {
    List<UiCaseModuleDTO> list(Long projectId);

    UiCaseModuleDTO getById(Long projectId, Long moduleId);

    Integer save(UiCaseModuleSaveReq req);

    Integer update(UiCaseModuleUpdateReq req);

    Integer delete(Long projectId, Long id);
}
