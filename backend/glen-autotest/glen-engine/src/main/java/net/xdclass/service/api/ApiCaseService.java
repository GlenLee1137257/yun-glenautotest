package com.glen.autotest.service.api;


import com.glen.autotest.dto.api.ApiCaseDTO;
import com.glen.autotest.req.api.ApiCaseDelReq;
import com.glen.autotest.req.api.ApiCaseSaveReq;
import com.glen.autotest.req.api.ApiCaseUpdateReq;
import com.glen.autotest.util.JsonData;

public interface ApiCaseService {
    ApiCaseDTO getById(Long projectId, Long id);

    int save(ApiCaseSaveReq req);

    int update(ApiCaseUpdateReq req);

    int del(Long projectId,Long id);

    JsonData execute(Long projectId, Long caseId);
}
