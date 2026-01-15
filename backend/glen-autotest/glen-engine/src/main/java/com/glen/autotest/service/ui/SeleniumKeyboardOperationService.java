package com.glen.autotest.service.ui;

import org.openqa.selenium.WebElement;

/**
 * Selenium键盘操作服务接口
 */
public interface SeleniumKeyboardOperationService {
    void input(WebElement element, String text);
    void clear(WebElement element);
    void submit(WebElement element);
}
