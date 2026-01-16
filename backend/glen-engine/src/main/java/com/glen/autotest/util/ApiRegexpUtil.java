package com.glen.autotest.util;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public class ApiRegexpUtil {
    /**
     * 正则表达式 - 关联取值
     * 匹配以 {{ 开头，以 }} 结尾，且中间不包含 }} 的字符串
     */
    public static final String REGEXP = "\\{\\{([^}]+)}}";

    /**
     * 正则表达式具名 - 关联取值
     * @param name
     * @return
     */
    public static String byName(String name) {
        return "\\{\\{(" + name + ")}}";
    }
}

