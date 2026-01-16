package com.glen.autotest.service.ui.impl;

import com.glen.autotest.service.ui.SeleniumKeyboardOperationService;
import org.openqa.selenium.WebElement;
import org.springframework.stereotype.Component;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Component
public class SeleniumKeyboardOperationServiceImpl implements SeleniumKeyboardOperationService {
    @Override
    public void input(WebElement webElement, String... text) {
        webElement.sendKeys(text);
    }

    @Override
    public void clear(WebElement webElement) {
        webElement.clear();
    }

    @Override
    public void submit(WebElement webElement) {
        webElement.submit();
    }
}
