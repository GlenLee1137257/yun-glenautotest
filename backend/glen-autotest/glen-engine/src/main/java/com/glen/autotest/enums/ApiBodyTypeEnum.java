package com.glen.autotest.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * API请求体类型枚举
 */
@Getter
@AllArgsConstructor
public enum ApiBodyTypeEnum {
    JSON("json", "JSON"),
    FORM("form", "表单"),
    XML("xml", "XML"),
    RAW("raw", "原始数据");

    private final String code;
    private final String desc;
}
