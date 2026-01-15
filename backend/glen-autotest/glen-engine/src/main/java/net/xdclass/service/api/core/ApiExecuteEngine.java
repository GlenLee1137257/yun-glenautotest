package com.glen.autotest.service.api.core;

import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import lombok.Data;
import com.glen.autotest.dto.ApiCaseResultDTO;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.ApiCaseResultItemDTO;
import com.glen.autotest.dto.ApiCaseStepDTO;
import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.enums.ApiBodyTypeEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.mapper.EnvironmentMapper;
import com.glen.autotest.model.ApiCaseStepDO;
import com.glen.autotest.model.EnvironmentDO;
import com.glen.autotest.service.common.ResultSenderService;
import com.glen.autotest.util.*;
import org.apache.commons.lang3.StringUtils;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
 * @Version 1.0
 **/
@Data
public class ApiExecuteEngine {

    private ReportDTO reportDTO;

    private EnvironmentMapper environmentMapper;

    private ResultSenderService resultSenderService;

    public ApiExecuteEngine(ReportDTO reportDTO){
        this.reportDTO = reportDTO;
        environmentMapper = SpringContextHolder.getBean(EnvironmentMapper.class);
        resultSenderService = SpringContextHolder.getBean(ResultSenderService.class);
    }

    /**
     * 重点和难点
     * @param caseInfoDTO
     * @param apiCaseStepDOList
     * @return
     */
    public ApiCaseResultDTO execute(CaseInfoDTO caseInfoDTO, List<ApiCaseStepDO> apiCaseStepDOList){

        try {
            int quantity = apiCaseStepDOList.size();
            long startTime = System.currentTimeMillis();
            //进行执行
            ApiCaseResultDTO result = doExecute(null,apiCaseStepDOList);
            //结束时间
            long endTime = System.currentTimeMillis();

            result.setReportId(reportDTO.getId());
            result.setStartTime(startTime);
            result.setEndTime(endTime);
            result.setExpendTime(endTime-startTime);
            result.setQuantity(quantity);

            int passQuantity = result.getList().stream().filter(item -> {
                item.setReportId(reportDTO.getId());
                return item.getExecuteState() && item.getAssertionState();
            }).toList().size();

            result.setPassQuantity(passQuantity);
            result.setFailQuantity(quantity-passQuantity);
            result.setExecuteState(Objects.equals(result.getQuantity(), result.getPassQuantity()));

            //发送结果
            resultSenderService.sendResult(caseInfoDTO, TestTypeEnum.API, JsonUtil.obj2Json(result));
            return result;
        }finally {
            //释放相关资源
            ApiRelationContext.remove();
        }

    }

    private ApiCaseResultDTO doExecute(ApiCaseResultDTO result, List<ApiCaseStepDO> stepList) {

        if(result == null){
            result = new ApiCaseResultDTO();
            result.setList(new ArrayList<>(stepList.size()));
        }
        if(stepList == null || stepList.isEmpty()){
            return result;
        }
        //用例步骤执行结果处理
        ApiCaseStepDO step = stepList.get(0);
        ApiCaseResultItemDTO resultItem = new ApiCaseResultItemDTO();
        resultItem.setApiCaseStep(SpringBeanUtil.copyProperties(step, ApiCaseStepDTO.class));
        resultItem.setExecuteState(true);
        resultItem.setAssertionState(true);
        result.getList().add(resultItem);

        EnvironmentDO environmentDO = environmentMapper.selectById(step.getEnvironmentId());
        String base = getBaseUrl(environmentDO);
        //创建请求
        ApiRequest request = new ApiRequest(base, step.getPath(), step.getAssertion(), step.getRelation(), step.getQuery(), step.getHeader(), step.getBody(), step.getBodyType());
        RequestSpecification given = request.createRequest();
        try {
            long startTime = System.currentTimeMillis();
            //发起请求
            Response response = given.request(step.getMethod())
                    .thenReturn();
            long endTime = System.currentTimeMillis();

            resultItem.setExpendTime(endTime - startTime);
            resultItem.setRequestHeader(JsonUtil.obj2Json(request.getHeaderList()));
            resultItem.setRequestQuery(JsonUtil.obj2Json(request.getQueryList()));
            if(StringUtils.isNotBlank(request.getRequestBody().getBody())){
                if(step.getBodyType().equals(ApiBodyTypeEnum.JSON.name())){
                    resultItem.setRequestBody(request.getRequestBody().getBody());
                }else {
                    resultItem.setRequestBody(JsonUtil.obj2Json(request.getBodyList()));
                }
            }
            //处理响应结果
            resultItem.setResponseBody(response.getBody().asString());
            resultItem.setResponseHeader(JsonUtil.obj2Json(response.getHeaders()));

            //关联取值
            ApiRelationSaveUtil.dispatcher(request,response);

            //断言处理
            ApiAssertionUtil.dispatcher(request,response);


        }catch (BizException e){
            e.printStackTrace();
            //断言失败
            resultItem.setAssertionState(false);
            //TODO 如何改进断言信息返回 exceptionMsg
            resultItem.setExceptionMsg(e.getDetail());
        }catch (Exception e){
            e.printStackTrace();
            resultItem.setExecuteState(false);
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            resultItem.setExceptionMsg(sw.toString());
        }

        //下轮递归
        stepList.remove(0);
        return doExecute(result,stepList);
    }



    private static String getBaseUrl(EnvironmentDO environmentDO){
        return environmentDO.getProtocol() + "://" + environmentDO.getDomain() + ":" + environmentDO.getPort();
    }


}
