package com.glen.autotest.service.ui;

/**
 * Selenium浏览器操作服务接口
 */
public interface SeleniumBrowserOperationService {
    void open(String url);
    void close();
    void switchByHandle(String handle);
    void switchByIndex(int index);
    void refresh();
    void back();
    void forward();
    void resizeMaximize();
    void resize(int width, int height);
}
