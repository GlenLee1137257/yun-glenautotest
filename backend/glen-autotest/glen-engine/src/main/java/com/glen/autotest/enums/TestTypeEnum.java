package com.glen.autotest.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 测试类型枚举
 */
@Getter
@AllArgsConstructor
public enum TestTypeEnum {
    API(1, "API测试"),
    UI(2, "UI测试"),
    STRESS(3, "压力测试");

    private final int code;
    private final String desc;
}
