package com.glen.autotest.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * Selenium操作枚举
 */
@Getter
@AllArgsConstructor
public enum SeleniumOperationEnum {
    CLICK("click", "点击"),
    INPUT("input", "输入"),
    GET_TEXT("get_text", "获取文本"),
    WAIT("wait", "等待");

    private final String code;
    private final String desc;
}
