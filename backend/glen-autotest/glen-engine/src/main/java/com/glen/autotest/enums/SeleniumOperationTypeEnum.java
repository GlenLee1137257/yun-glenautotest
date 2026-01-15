package com.glen.autotest.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * Selenium操作类型枚举
 */
@Getter
@AllArgsConstructor
public enum SeleniumOperationTypeEnum {
    ID("id", "ID"),
    NAME("name", "名称"),
    CLASS("class", "类名"),
    XPATH("xpath", "XPath"),
    CSS("css", "CSS选择器");

    private final String code;
    private final String desc;
}
