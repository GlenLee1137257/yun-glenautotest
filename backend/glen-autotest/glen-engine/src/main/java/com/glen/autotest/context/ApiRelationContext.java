package com.glen.autotest.context;

import java.util.HashMap;
import java.util.Map;

/**
 * API关联上下文 - 用于存储步骤间的关联数据
 */
public class ApiRelationContext {
    private static final ThreadLocal<Map<String, Object>> CONTEXT = ThreadLocal.withInitial(HashMap::new);
    
    /**
     * 保存关联数据
     */
    public static void put(String key, Object value) {
        CONTEXT.get().put(key, value);
    }
    
    /**
     * 获取关联数据
     */
    public static Object get(String key) {
        return CONTEXT.get().get(key);
    }
    
    /**
     * 清空上下文
     */
    public static void clear() {
        CONTEXT.remove();
    }
}
