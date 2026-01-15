package com.glen.autotest.service.api;

import com.glen.autotest.dto.api.ApiCaseDTO;
import com.glen.autotest.req.api.ApiCaseSaveReq;
import com.glen.autotest.req.api.ApiCaseUpdateReq;

import java.util.List;

/**
 * API用例服务接口
 */
public interface ApiCaseService {
    ApiCaseDTO getById(Long projectId, Long id);
    List<ApiCaseDTO> list(Long projectId, Long moduleId);
    int save(ApiCaseSaveReq req);
    int update(ApiCaseUpdateReq req);
    int delete(Long id, Long projectId);
}
