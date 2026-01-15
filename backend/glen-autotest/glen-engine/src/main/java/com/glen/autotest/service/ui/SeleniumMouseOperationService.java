package com.glen.autotest.service.ui;

import org.openqa.selenium.WebElement;

/**
 * Selenium鼠标操作服务接口
 */
public interface SeleniumMouseOperationService {
    void leftClick(WebElement element);
    void rightClick(WebElement element);
    void doubleClick(WebElement element);
    void moveToElement(WebElement element);
    void dragElementToElement(WebElement source, WebElement target);
}
