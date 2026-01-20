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
     * 注意：需要对 name 中的特殊字符进行转义，例如 $ 需要转义为 \$
     * @param name
     * @return
     */
    public static String byName(String name) {
        // 转义正则表达式特殊字符，特别是 $ 符号
        String escapedName = name.replaceAll("([\\$\\[\\]\\{\\}\\(\\)\\*\\+\\?\\.\\\\\\^\\|])", "\\\\$1");
        return "\\{\\{(" + escapedName + ")}}";
    }
}

