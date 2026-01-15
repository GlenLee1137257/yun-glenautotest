package com.glen.autotest.util;

import org.openqa.selenium.WebDriver;

/**
 * Selenium WebDriver上下文
 */
public class SeleniumWebdriverContext {
    private static final ThreadLocal<WebDriver> THREAD_LOCAL = new ThreadLocal<>();

    public static WebDriver get() {
        return THREAD_LOCAL.get();
    }

    public static void set(WebDriver webDriver) {
        THREAD_LOCAL.set(webDriver);
    }

    public static void remove() {
        THREAD_LOCAL.remove();
    }
    
    // 兼容方法
    public static WebDriver getDriver() {
        return get();
    }
    
    public static void setDriver(WebDriver driver) {
        set(driver);
    }
    
    public static void removeDriver() {
        remove();
    }
}
