package com.glen.autotest.service.api;

import com.glen.autotest.dto.api.ApiModuleDTO;
import com.glen.autotest.req.api.ApiModuleSaveReq;
import com.glen.autotest.req.api.ApiModuleUpdateReq;

import java.util.List;

public interface ApiModuleService {
    List<ApiModuleDTO> list(Long projectId);

    ApiModuleDTO getById(Long projectId, Long moduleId);

    int delete(Long id, Long projectId);

    int save(ApiModuleSaveReq req);

    int update(ApiModuleUpdateReq req);
}
