package com.glen.autotest.service.ui;

import com.glen.autotest.dto.UiOperationResultDTO;

/**
 * Selenium断言操作服务接口
 */
public interface SeleniumAssertionOperationService {
    UiOperationResultDTO existElement(String locationType, String locationExpress);
    UiOperationResultDTO absentElement(String locationType, String locationExpress);
    UiOperationResultDTO enableElement(String locationType, String locationExpress);
    UiOperationResultDTO disableElement(String locationType, String locationExpress);
    UiOperationResultDTO visibleElement(String locationType, String locationExpress);
    UiOperationResultDTO invisibleElement(String locationType, String locationExpress);
    UiOperationResultDTO selectElement(String locationType, String locationExpress);
    UiOperationResultDTO unselectElement(String locationType, String locationExpress);
    UiOperationResultDTO greaterThan(long actual, long expected);
    UiOperationResultDTO lessThan(long actual, long expected);
    UiOperationResultDTO equalValue(String actual, String expected);
    UiOperationResultDTO notEqualValue(String actual, String expected);
    UiOperationResultDTO containValue(String actual, String expected);
    UiOperationResultDTO notContainValue(String actual, String expected);
}
