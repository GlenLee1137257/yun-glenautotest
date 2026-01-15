package com.glen.autotest.service.ui;

import com.glen.autotest.model.UiCaseStepDO;

/**
 * Selenium等待操作服务接口
 */
public interface SeleniumWaitOperationService {
    void waitShow(UiCaseStepDO step);
    void waitHide(long milliseconds);
    void waitForce(long milliseconds);
}
