package com.glen.autotest.service.ui;

import com.glen.autotest.dto.UiOperationResultDTO;
import com.glen.autotest.model.UiCaseStepDO;

/**
 * Selenium调度服务接口
 */
public interface SeleniumDispatcherService {
    UiOperationResultDTO execute(UiCaseStepDO step);
}
