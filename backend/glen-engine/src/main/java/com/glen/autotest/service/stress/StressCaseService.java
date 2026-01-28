package com.glen.autotest.service.stress;

import com.glen.autotest.dto.stress.StressCaseDTO;
import com.glen.autotest.req.stress.StressCaseBatchExecuteReq;
import com.glen.autotest.req.stress.StressCaseSaveReq;
import com.glen.autotest.req.stress.StressCaseUpdateReq;
import com.glen.autotest.util.JsonData;

public interface StressCaseService {
    StressCaseDTO findById(Long projectId, Long caseId);

    int delete(Long projectId, Long id);

    int save(StressCaseSaveReq req);

    int update(StressCaseUpdateReq req);

    void execute(Long projectId, Long caseId);

    /**
     * 批量执行用例
     */
    JsonData batchExecute(StressCaseBatchExecuteReq req);

    /**
     * 按模块执行用例
     */
    JsonData executeByModule(Long projectId, Long moduleId);
}
