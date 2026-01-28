package com.glen.autotest.service.ui;

import com.glen.autotest.dto.dto.UiCaseDTO;
import com.glen.autotest.req.ui.UiCaseBatchExecuteReq;
import com.glen.autotest.req.ui.UiCaseDelReq;
import com.glen.autotest.req.ui.UiCaseSaveReq;
import com.glen.autotest.req.ui.UiCaseUpdateReq;
import com.glen.autotest.util.JsonData;

public interface UiCaseService {
    UiCaseDTO find(Long projectId, Long caseId);

    Integer delete(UiCaseDelReq req);

    Integer update(UiCaseUpdateReq req);

    Integer save(UiCaseSaveReq req);

    JsonData execute(Long projectId, Long caseId);

    /**
     * 批量执行用例
     */
    JsonData batchExecute(UiCaseBatchExecuteReq req);

    /**
     * 按模块执行用例
     */
    JsonData executeByModule(Long projectId, Long moduleId);
}
