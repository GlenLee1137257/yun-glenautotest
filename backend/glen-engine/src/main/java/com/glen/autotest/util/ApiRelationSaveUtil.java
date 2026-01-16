package com.glen.autotest.util;

import com.jayway.jsonpath.JsonPath;
import io.restassured.response.Response;
import com.glen.autotest.dto.api.ApiJsonRelationDTO;
import com.glen.autotest.enums.ApiRelateFieldFromEnum;
import com.glen.autotest.enums.ApiRelateTypeEnum;
import com.glen.autotest.enums.BizCodeEnum;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.service.api.core.ApiRequest;

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
public class ApiRelationSaveUtil {

    public static void dispatcher(ApiRequest request, Response response){

        if(request.getRelationList() == null){
            return;
        }

        for(ApiJsonRelationDTO relation : request.getRelationList()){
            ApiRelateTypeEnum typeEnum = ApiRelateTypeEnum.valueOf(relation.getType());
            switch (typeEnum){
                case REGEXP:
                    regexp(request, response, relation);
                    break;
                case JSONPATH:
                    jsonPath(request, response, relation);
                    break;
                default:throw new IllegalArgumentException("不支持的表达式解析类型");
            }

        }

    }

    private static void jsonPath(ApiRequest request, Response response, ApiJsonRelationDTO relation) {
        try{
            ApiRelateFieldFromEnum fieldFromEnum = ApiRelateFieldFromEnum.valueOf(relation.getFrom());
            String value = switch (fieldFromEnum){
                case REQUEST_HEADER -> request.getHeader();
                case REQUEST_BODY -> request.getRequestBody().getBody();
                case REQUEST_QUERY -> request.getQuery();
                case RESPONSE_HEADER -> JsonUtil.obj2Json(response.getHeaders());
                case RESPONSE_DATA -> response.getBody().asString();
                default -> throw new BizException(BizCodeEnum.API_OPERATION_UNSUPPORTED_FROM);
            };

            Object json = JsonPath.read(value, relation.getExpress());
            if(json!= null){
                ApiRelationContext.set(relation.getName(),String.valueOf(json));
            }
        }catch (Exception e){
            throw new BizException(BizCodeEnum.API_OPERATION_UNSUPPORTED_RELATION);
        }

    }

    private static void regexp(ApiRequest request, Response response, ApiJsonRelationDTO relation) {
        try {
            Pattern pattern = Pattern.compile(relation.getExpress());
            ApiRelateFieldFromEnum fieldFromEnum = ApiRelateFieldFromEnum.valueOf(relation.getFrom());
            String value = switch (fieldFromEnum){
                case REQUEST_HEADER -> request.getHeader();
                case REQUEST_BODY -> request.getRequestBody().getBody();
                case REQUEST_QUERY -> request.getQuery();
                case RESPONSE_HEADER -> JsonUtil.obj2Json(response.getHeaders());
                case RESPONSE_DATA -> response.getBody().asString();
                default -> throw new BizException(BizCodeEnum.API_OPERATION_UNSUPPORTED_FROM);
            };
            Matcher matcher = pattern.matcher(value);
            if(matcher.find()){
                ApiRelationContext.set(relation.getName(),matcher.group());
            }

        }catch (Exception e){
            throw new BizException(BizCodeEnum.API_OPERATION_UNSUPPORTED_RELATION);
        }

    }

}
