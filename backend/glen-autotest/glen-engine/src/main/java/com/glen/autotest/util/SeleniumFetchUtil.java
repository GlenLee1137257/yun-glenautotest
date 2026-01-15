package com.glen.autotest.util;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;

/**
 * Selenium元素获取工具类
 */
public class SeleniumFetchUtil {
    public static WebElement fetchElement(WebDriver driver, String operationType, String element) {
        By by = switch (operationType.toLowerCase()) {
            case "id" -> By.id(element);
            case "name" -> By.name(element);
            case "class" -> By.className(element);
            case "xpath" -> By.xpath(element);
            case "css" -> By.cssSelector(element);
            default -> throw new IllegalArgumentException("不支持的元素定位类型: " + operationType);
        };
        return driver.findElement(by);
    }
}
