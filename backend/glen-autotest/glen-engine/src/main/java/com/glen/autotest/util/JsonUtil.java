package com.glen.autotest.util;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

/**
 * JSON工具类
 */
public class JsonUtil {
    
    /**
     * 对象转JSON字符串
     */
    public static String toJsonString(Object obj) {
        return JSON.toJSONString(obj);
    }
    
    /**
     * JSON字符串转对象
     */
    public static <T> T parseObject(String json, Class<T> clazz) {
        return JSON.parseObject(json, clazz);
    }
    
    /**
     * JSON字符串转对象（带泛型）
     */
    public static <T> T parseObject(String json, TypeReference<T> typeReference) {
        return JSON.parseObject(json, typeReference);
    }
}
