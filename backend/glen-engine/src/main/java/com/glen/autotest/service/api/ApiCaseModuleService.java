package com.glen.autotest.service.api;

import com.glen.autotest.dto.api.ApiCaseDTO;
import com.glen.autotest.dto.api.ApiCaseModuleDTO;
import com.glen.autotest.req.api.ApiCaseModuleDelReq;
import com.glen.autotest.req.api.ApiCaseModuleSaveReq;
import com.glen.autotest.req.api.ApiCaseModuleUpdateReq;

import java.util.List;

public interface ApiCaseModuleService {

    List<ApiCaseModuleDTO> list(Long projectId);

    ApiCaseModuleDTO getById(Long projectId, Long moduleId);

    int save(ApiCaseModuleSaveReq req);

    int update(ApiCaseModuleUpdateReq req);

    int del(ApiCaseModuleDelReq req);
}
