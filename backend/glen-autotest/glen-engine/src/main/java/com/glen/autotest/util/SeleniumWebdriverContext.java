package com.glen.autotest.util;

import org.openqa.selenium.WebDriver;

/**
 * Selenium WebDriver上下文
 */
public class SeleniumWebdriverContext {
    private static final ThreadLocal<WebDriver> driverThreadLocal = new ThreadLocal<>();

    public static void setDriver(WebDriver driver) {
        driverThreadLocal.set(driver);
    }

    public static WebDriver getDriver() {
        return driverThreadLocal.get();
    }

    public static void removeDriver() {
        driverThreadLocal.remove();
    }
}
