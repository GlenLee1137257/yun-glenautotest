package com.glen.autotest.service.api;

import com.glen.autotest.req.api.ApiCaseStepSaveReq;
import com.glen.autotest.req.api.ApiCaseStepUpdateReq;

public interface ApiCaseStepService {
    int save(ApiCaseStepSaveReq req);

    int update(ApiCaseStepUpdateReq req);

    int del(Long projectId, Long id);
}
