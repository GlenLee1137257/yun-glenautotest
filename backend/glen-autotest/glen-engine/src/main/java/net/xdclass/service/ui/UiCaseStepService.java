package com.glen.autotest.service.ui;

import com.glen.autotest.req.ui.UiCaseStepDelReq;
import com.glen.autotest.req.ui.UiCaseStepSaveReq;
import com.glen.autotest.req.ui.UiCaseStepUpdateReq;

public interface UiCaseStepService {
    Integer save(UiCaseStepSaveReq req);

    Integer update(UiCaseStepUpdateReq req);

    Integer delete(UiCaseStepDelReq req);
}
