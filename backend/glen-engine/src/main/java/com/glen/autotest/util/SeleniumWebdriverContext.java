package com.glen.autotest.util;

import org.openqa.selenium.WebDriver;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public class SeleniumWebdriverContext {

    private static final ThreadLocal<WebDriver> THREAD_LOCAL = new ThreadLocal<>();

    public static WebDriver get() {
        return THREAD_LOCAL.get();
    }

    public static void  set(WebDriver webDriver){
        THREAD_LOCAL.set(webDriver);
    }

    public static void remove(){
        THREAD_LOCAL.remove();
    }
}
