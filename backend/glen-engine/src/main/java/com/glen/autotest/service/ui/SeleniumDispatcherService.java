package com.glen.autotest.service.ui;

import com.glen.autotest.dto.UiOperationResultDTO;
import com.glen.autotest.model.UiCaseStepDO;

public interface SeleniumDispatcherService {

    UiOperationResultDTO operationDispatcher(UiCaseStepDO uiCaseStepDO);
}
