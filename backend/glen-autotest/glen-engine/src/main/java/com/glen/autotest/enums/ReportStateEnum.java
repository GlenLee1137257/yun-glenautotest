package com.glen.autotest.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 报告状态枚举
 */
@Getter
@AllArgsConstructor
public enum ReportStateEnum {
    RUNNING(1, "运行中"),
    SUCCESS(2, "成功"),
    FAILED(3, "失败");

    private final int code;
    private final String desc;
}
