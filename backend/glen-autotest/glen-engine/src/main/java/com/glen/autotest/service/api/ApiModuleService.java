package com.glen.autotest.service.api;

import com.glen.autotest.dto.api.ApiModuleDTO;
import com.glen.autotest.req.api.ApiModuleSaveReq;
import com.glen.autotest.req.api.ApiModuleUpdateReq;

import java.util.List;

/**
 * API模块服务接口
 */
public interface ApiModuleService {
    List<ApiModuleDTO> list(Long projectId);
    ApiModuleDTO getById(Long projectId, Long moduleId);
    int save(ApiModuleSaveReq req);
    int update(ApiModuleUpdateReq req);
    int delete(Long id, Long projectId);
}
