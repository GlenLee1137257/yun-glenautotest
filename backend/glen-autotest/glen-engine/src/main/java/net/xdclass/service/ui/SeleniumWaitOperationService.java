package com.glen.autotest.service.ui;

import com.glen.autotest.model.UiCaseStepDO;

/**
 * Selenium等待操作服务接口，提供了一系列的页面元素等待操作方法。
 */
public interface SeleniumWaitOperationService {

    /**
     * 隐藏等待，等待页面元素隐藏。
     * @param millSeconds 等待的毫秒数。
     */
    void waitHide(Long millSeconds);

    /**
     * 显示等待，等待页面元素显示。
     * @param millSeconds 等待的毫秒数。
     */
    void waitShow(UiCaseStepDO uiCaseStepDO);

    /**
     * 强制等待，等待指定的时间。
     * @param millSeconds 等待的毫秒数。
     */
    void waitForce(Long millSeconds);
}
