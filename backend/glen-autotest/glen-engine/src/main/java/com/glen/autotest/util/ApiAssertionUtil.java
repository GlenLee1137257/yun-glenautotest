package com.glen.autotest.util;

import com.glen.autotest.enums.BizCodeEnum;
import com.glen.autotest.exception.BizException;
import io.restassured.response.Response;

/**
 * API断言工具类
 */
public class ApiAssertionUtil {
    
    /**
     * 执行断言
     * @param assertion 断言配置（JSON格式）
     * @param response 响应对象
     * @return 断言是否通过
     */
    public static boolean assertion(String assertion, Response response) {
        if (assertion == null || assertion.isEmpty()) {
            return true;
        }
        
        try {
            // 解析断言配置并执行断言
            // 格式示例：{"statusCode":200,"body.code":"0","body.data.name":"test"}
            // 实际实现需要根据具体需求解析并执行断言
            // 这里提供简化的框架
            
            // 示例：检查状态码
            if (response.getStatusCode() != 200) {
                throw new BizException(BizCodeEnum.CASE_EXECUTE_FAIL);
            }
            
            return true;
        } catch (BizException e) {
            throw e;
        } catch (Exception e) {
            return false;
        }
    }
}
