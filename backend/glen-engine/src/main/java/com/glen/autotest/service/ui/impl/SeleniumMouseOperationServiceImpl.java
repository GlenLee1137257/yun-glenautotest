package com.glen.autotest.service.ui.impl;

import com.glen.autotest.service.ui.SeleniumMouseOperationService;
import com.glen.autotest.util.SeleniumWebdriverContext;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
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
public class SeleniumMouseOperationServiceImpl implements SeleniumMouseOperationService {
    @Override
    public void leftClick(WebElement webElement) {
        webElement.click();
    }

    @Override
    public void rightClick(WebElement webElement) {
        Actions actions = new Actions(SeleniumWebdriverContext.get());
        actions.contextClick(webElement).perform();
    }

    @Override
    public void doubleClick(WebElement webElement) {
        Actions actions = new Actions(SeleniumWebdriverContext.get());
        actions.doubleClick(webElement).perform();

    }

    @Override
    public void dragElementToElement(WebElement source, WebElement target) {
        Actions actions = new Actions(SeleniumWebdriverContext.get());
        actions.dragAndDrop(source,target).perform();
    }

    @Override
    public void moveToElement(WebElement webElement) {
        Actions actions = new Actions(SeleniumWebdriverContext.get());
        actions.moveToElement(webElement).perform();
    }
}
