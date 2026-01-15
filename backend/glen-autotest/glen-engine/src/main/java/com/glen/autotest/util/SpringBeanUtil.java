package com.glen.autotest.util;

import org.springframework.beans.BeanUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * 对象转换拷贝工具类
 */
public class SpringBeanUtil {
    public static <T> T copyProperties(Object source, Class<T> target) {
        try {
            T t = target.getDeclaredConstructor().newInstance();
            BeanUtils.copyProperties(source, t);
            return t;
        } catch (Exception e) {
            throw new RuntimeException("对象拷贝失败", e);
        }
    }

    public static <T> List<T> copyProperties(List<?> sourceList, Class<T> target) {
        List<T> result = new ArrayList<>();
        if (sourceList != null) {
            for (Object source : sourceList) {
                result.add(copyProperties(source, target));
            }
        }
        return result;
    }
}
