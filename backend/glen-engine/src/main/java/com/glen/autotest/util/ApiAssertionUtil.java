package com.glen.autotest.util;

import com.jayway.jsonpath.JsonPath;
import io.restassured.response.Response;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.api.ApiJsonAssertionDTO;
import com.glen.autotest.enums.ApiAssertActionEnum;
import com.glen.autotest.enums.ApiAssertFieldFromEnum;
import com.glen.autotest.enums.ApiAssertTypeEnum;
import com.glen.autotest.enums.BizCodeEnum;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.service.api.core.ApiRequest;
import org.apache.commons.lang3.StringUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Slf4j
/**
 * Api断言工具类
 */
public class ApiAssertionUtil {

    /**
     * 断言分发方法
     * @param action        断言类型
     * @param value         待断言的值
     * @param expectValue   预期值
     * @return              断言结果
     */
    public static boolean assertionDispatcher(String action, String value, String expectValue) {
        ApiAssertActionEnum actionEnum = ApiAssertActionEnum.valueOf(action);
        boolean result = switch (actionEnum) {
            case CONTAIN -> value.contains(expectValue);
            case NOT_CONTAIN -> !value.contains(expectValue);
            case EQUAL -> value.equals(expectValue);
            case NOT_EQUAL -> !value.equals(expectValue);
            case LESS_THEN -> Long.parseLong(value) < Long.parseLong(expectValue);
            case GREAT_THEN -> Long.parseLong(value) > Long.parseLong(expectValue);
            default -> throw new BizException(BizCodeEnum.API_OPERATION_UNSUPPORTED_ASSERTION);
        };

        //加判断，封装对象，AssertMsg{ msg = "", state=true | false}
//        if(result){
//            return
//        }else


        return result;
    }

    /**
     * 断言分发方法
     * @param request       Api请求对象
     * @param response      Api响应对象
     */
    public static void dispatcher(ApiRequest request, Response response) {
        if (StringUtils.isBlank(request.getAssertion())) {
            return;
        }

        for (ApiJsonAssertionDTO assertion : request.getAssertionList()) {
            boolean state = true;
            String express = assertion.getExpress();
            // 对预期值进行变量替换（如将 {{category_id}} 替换为实际值）
            String expectValue = ApiRelationGetUtil.getParameter(assertion.getValue());
            ApiAssertFieldFromEnum fieldFromEnum = ApiAssertFieldFromEnum.valueOf(assertion.getFrom());
            String actualValue = null; // 用于记录实际值，便于生成错误信息
            try {
                if (ApiAssertTypeEnum.JSONPATH.name().equals(assertion.getType())) {
                    // jsonpath解析
                    state = switch (fieldFromEnum) {
                        case RESPONSE_CODE -> {
                            String stringify = String.valueOf(response.getStatusCode());
                            Object responseCode = JsonPath.read(stringify, express);
                            actualValue = String.valueOf(responseCode);
                            yield assertionDispatcher(assertion.getAction(), actualValue, expectValue);
                        }
                        case RESPONSE_HEADER -> {
                            String stringify = JsonUtil.obj2Json(response.getHeaders());
                            Object responseHeader = JsonPath.read(stringify, express);
                            actualValue = String.valueOf(responseHeader);
                            yield assertionDispatcher(assertion.getAction(), actualValue, expectValue);
                        }
                        case RESPONSE_DATA -> {
                            String stringify = response.getBody().asString();
                            Object responseData = JsonPath.read(stringify, express);
                            // 处理 null 值：如果 JSONPath 返回 null，断言失败
                            if (responseData == null) {
                                log.warn("JSONPath 表达式 {} 未匹配到值，响应体：{}", express, stringify);
                                actualValue = "null";
                                yield false;
                            }
                            actualValue = String.valueOf(responseData);
                            log.debug("断言检查 - JSONPath: {}, 实际值: {}, 预期值: {}, 动作: {}", express, actualValue, expectValue, assertion.getAction());
                            yield assertionDispatcher(assertion.getAction(), actualValue, expectValue);
                        }
                        default -> {
                            log.error("不支持的断言来源:{}", fieldFromEnum);
                            throw new BizException(BizCodeEnum.API_OPERATION_UNSUPPORTED_FROM);
                        }
                    };

                } else if (ApiAssertTypeEnum.REGEXP.name().equals(assertion.getType())) {
                    // 正则解析
                    Pattern pattern = Pattern.compile(express);
                    state = switch (fieldFromEnum) {
                        case RESPONSE_CODE -> {
                            String stringify = String.valueOf(response.getStatusCode());
                            Matcher matcher = pattern.matcher(stringify);
                            if (matcher.find()) {
                                actualValue = matcher.group();
                                yield assertionDispatcher(assertion.getAction(), actualValue, expectValue);
                            } else {
                                actualValue = "未匹配到";
                                yield false;
                            }
                        }
                        case RESPONSE_HEADER -> {
                            String stringify = JsonUtil.obj2Json(response.getHeaders());
                            Matcher matcher = pattern.matcher(stringify);
                            if (matcher.find()) {
                                actualValue = matcher.group();
                                yield assertionDispatcher(assertion.getAction(), actualValue, expectValue);
                            } else {
                                actualValue = "未匹配到";
                                yield false;
                            }
                        }
                        case RESPONSE_DATA -> {
                            String stringify = response.getBody().asString();
                            Matcher matcher = pattern.matcher(stringify);
                            if (matcher.find()) {
                                actualValue = matcher.group();
                                yield assertionDispatcher(assertion.getAction(), actualValue, expectValue);
                            } else {
                                actualValue = "未匹配到";
                                yield false;
                            }
                        }
                        default -> {
                            log.error("不支持的断言来源:{}", fieldFromEnum);
                            throw new BizException(BizCodeEnum.API_OPERATION_UNSUPPORTED_FROM);
                        }
                    };
                }
                if (!state) {
                    // 断言失败，构建详细的错误信息
                    String errorDetail = String.format(
                        "断言失败 - 来源: %s, 类型: %s, 动作: %s, 表达式: %s, 实际值: %s, 预期值: %s",
                        assertion.getFrom(),
                        assertion.getType(),
                        assertion.getAction(),
                        express,
                        actualValue != null ? actualValue : "未知",
                        expectValue
                    );
                    log.error(errorDetail);
                    // 使用包含 detail 的构造函数，将详细信息传递给异常
                    RuntimeException detailException = new RuntimeException(errorDetail);
                    throw new BizException(BizCodeEnum.API_ASSERTION_FAILED, detailException);
                }
            } catch (BizException e) {
                // 如果是业务异常（包括断言失败），直接抛出
                throw e;
            } catch (Exception e) {
                // 其他异常（如 JSONPath 解析错误、正则表达式错误等）
                String errorDetail = String.format(
                    "断言执行异常 - 来源: %s, 类型: %s, 表达式: %s, 错误: %s",
                    assertion.getFrom(),
                    assertion.getType(),
                    express,
                    e.getMessage()
                );
                log.error(errorDetail, e);
                // 使用包含 detail 的构造函数，将详细信息传递给异常
                RuntimeException detailException = new RuntimeException(errorDetail);
                throw new BizException(BizCodeEnum.API_ASSERTION_FAILED, detailException);
            }
        }
    }
}
