package com.glen.autotest.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * Selenium操作枚举
 */
@Getter
@AllArgsConstructor
public enum SeleniumOperationEnum {
    // 操作类别
    BROWSER("browser", "浏览器操作"),
    MOUSE("mouse", "鼠标操作"),
    KEYBOARD("keyboard", "键盘操作"),
    WAIT("wait", "等待操作"),
    ASSERTION("assertion", "断言操作"),
    
    // 断言类型
    ASSERTION_BROWSER("assertion_browser", "浏览器断言"),
    ASSERTION_ELEMENT_TEXT("assertion_element_text", "元素文本断言"),
    ASSERTION_ELEMENT("assertion_element", "元素断言"),
    
    // 浏览器操作详细类型
    BROWSER_OPEN("open", "打开URL"),
    BROWSER_CLOSE("close", "关闭浏览器"),
    BROWSER_REFRESH("refresh", "刷新页面"),
    BROWSER_BACK("back", "后退"),
    BROWSER_FORWARD("forward", "前进"),
    BROWSER_MAXIMIZE("maximize", "最大化窗口"),
    BROWSER_GET_TITLE("get_title", "获取标题"),
    BROWSER_GET_URL("get_url", "获取URL"),
    
    // 鼠标操作详细类型
    MOUSE_CLICK("click", "点击"),
    MOUSE_DOUBLE_CLICK("double_click", "双击"),
    MOUSE_RIGHT_CLICK("right_click", "右键点击"),
    MOUSE_DRAG_AND_DROP("drag_and_drop", "拖拽"),
    MOUSE_HOVER("hover", "悬停"),
    MOUSE_MOVE_TO_ELEMENT("move_to_element", "移动到元素"),
    
    // 键盘操作详细类型
    KEYBOARD_INPUT("input", "输入"),
    KEYBOARD_CLEAR("clear", "清空"),
    KEYBOARD_SUBMIT("submit", "提交"),
    KEYBOARD_SEND_KEYS("send_keys", "发送按键"),
    KEYBOARD_GET_TEXT("get_text", "获取文本"),
    KEYBOARD_GET_ATTRIBUTE("get_attribute", "获取属性"),
    
    // 等待操作详细类型
    WAIT_FIXED("fixed_wait", "固定等待"),
    WAIT_ELEMENT_VISIBLE("element_visible", "等待元素可见"),
    WAIT_ELEMENT_CLICKABLE("element_clickable", "等待元素可点击"),
    
    // 断言操作详细类型
    ASSERTION_TITLE_EQUALS("title_equals", "标题等于"),
    ASSERTION_TITLE_CONTAINS("title_contains", "标题包含"),
    ASSERTION_URL_EQUALS("url_equals", "URL等于"),
    ASSERTION_TEXT_EQUALS("text_equals", "文本等于"),
    ASSERTION_TEXT_CONTAINS("text_contains", "文本包含"),
    ASSERTION_ELEMENT_EXISTS("element_exists", "元素存在"),
    ASSERTION_ELEMENT_VISIBLE("element_visible", "元素可见"),
    ASSERTION_ELEMENT_ENABLED("element_enabled", "元素启用"),
    ASSERTION_ELEMENT_SELECTED("element_selected", "元素已选中"),
    ASSERTION_ATTRIBUTE_EQUALS("attribute_equals", "属性等于");

    private final String code;
    private final String desc;
}
