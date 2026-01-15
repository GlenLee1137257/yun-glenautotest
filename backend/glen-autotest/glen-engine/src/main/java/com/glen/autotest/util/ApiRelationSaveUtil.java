package com.glen.autotest.util;

import com.glen.autotest.context.ApiRelationContext;
import io.restassured.response.Response;

/**
 * API关联保存工具类
 */
public class ApiRelationSaveUtil {
    
    /**
     * 保存响应数据到上下文
     */
    public static void save(String relation, Response response) {
        if (relation == null || relation.isEmpty()) {
            return;
        }
        
        try {
            // 解析关联配置，从响应中提取数据并保存到上下文
            // 格式示例：{"token":"$.data.token","userId":"$.data.id"}
            // 实际实现需要根据具体需求解析 JSON 路径并提取值
            // 这里提供简化的框架
            
            // 将整个响应体作为默认值保存
            ApiRelationContext.put("lastResponse", response.getBody().asString());
        } catch (Exception e) {
            // 忽略保存失败
        }
    }
}
