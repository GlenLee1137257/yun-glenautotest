package com.glen.autotest.util;

import com.glen.autotest.enums.BizCodeEnum;
import com.glen.autotest.exception.BizException;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * Selenium元素获取工具类
 */
public class SeleniumFetchUtil {
    
    /**
     * 查找元素（支持等待）
     * @param locationType 定位类型（ID, NAME, XPATH, CSS_SELECTOR等）
     * @param locationExpress 定位表达式
     * @param waitTime 等待时间（毫秒）
     * @return WebElement
     */
    public static WebElement findElement(String locationType, String locationExpress, long waitTime) {
        WebDriver webDriver = SeleniumWebdriverContext.getDriver();
        if (webDriver == null) {
            throw new BizException(BizCodeEnum.UI_DRIVER_NOT_INITIALIZED);
        }
        
        // 元素查找最长等待时间
        WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofMillis(waitTime));
        
        try {
            // 根据定位类型查找元素
            SeleniumByEnum seleniumByEnum = SeleniumByEnum.valueOf(locationType);
            return switch (seleniumByEnum) {
                case ID -> wait.until(ExpectedConditions.presenceOfElementLocated(By.id(locationExpress)));
                case NAME -> wait.until(ExpectedConditions.presenceOfElementLocated(By.name(locationExpress)));
                case CLASS_NAME -> wait.until(ExpectedConditions.presenceOfElementLocated(By.className(locationExpress)));
                case XPATH -> wait.until(ExpectedConditions.presenceOfElementLocated(By.xpath(locationExpress)));
                case CSS_SELECTOR -> wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(locationExpress)));
                case LINK_TEXT -> wait.until(ExpectedConditions.presenceOfElementLocated(By.linkText(locationExpress)));
                case PARTIAL_LINK_TEXT -> wait.until(ExpectedConditions.presenceOfElementLocated(By.partialLinkText(locationExpress)));
                case TAG_NAME -> wait.until(ExpectedConditions.presenceOfElementLocated(By.tagName(locationExpress)));
                default -> throw new BizException(BizCodeEnum.UI_OPERATION_UNSUPPORTED_ELEMENT);
            };
        } catch (NoSuchElementException e) {
            // 未找到元素
            throw new BizException(BizCodeEnum.UI_ELEMENT_NOT_EXIST);
        } catch (IllegalArgumentException e) {
            // 不支持的定位类型
            throw new BizException(BizCodeEnum.UI_OPERATION_UNSUPPORTED_ELEMENT);
        }
    }
    
    /**
     * 兼容旧方法
     */
    public static WebElement fetchElement(WebDriver driver, String operationType, String element) {
        return findElement(operationType, element, 0);
    }
}

/**
 * Selenium定位类型枚举
 */
enum SeleniumByEnum {
    ID, NAME, CLASS_NAME, XPATH, CSS_SELECTOR, LINK_TEXT, PARTIAL_LINK_TEXT, TAG_NAME
}
