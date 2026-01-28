package com.glen.autotest.service.api;


import com.glen.autotest.dto.api.ApiCaseDTO;
import com.glen.autotest.req.api.ApiCaseBatchExecuteReq;
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

    /**
     * 批量执行用例
     */
    JsonData batchExecute(ApiCaseBatchExecuteReq req);

    /**
     * 按模块执行用例
     */
    JsonData executeByModule(Long projectId, Long moduleId);
}
