package com.glen.autotest.service.api.core;

import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.ApiCaseResultDTO;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.ApiCaseResultItemDTO;
import com.glen.autotest.dto.ApiCaseStepDTO;
import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.enums.ApiBodyTypeEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.mapper.EnvironmentMapper;
import com.glen.autotest.mapper.ApiMapper;
import com.glen.autotest.model.ApiCaseStepDO;
import com.glen.autotest.model.ApiDO;
import com.glen.autotest.model.EnvironmentDO;
import com.glen.autotest.service.common.ResultSenderService;
import com.glen.autotest.util.*;
import org.apache.commons.lang3.StringUtils;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
@Slf4j
public class ApiExecuteEngine {

    private ReportDTO reportDTO;

    private EnvironmentMapper environmentMapper;

    private ApiMapper apiMapper;

    private ResultSenderService resultSenderService;

    public ApiExecuteEngine(ReportDTO reportDTO){
        this.reportDTO = reportDTO;
        environmentMapper = SpringContextHolder.getBean(EnvironmentMapper.class);
        apiMapper = SpringContextHolder.getBean(ApiMapper.class);
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
            // 预置内置关联变量（例如 {{$timestamp}}），供整个用例执行过程使用
            // 注意：变量名需要和占位符中的内容完全一致，这里为 `$timestamp`
            // 生成秒级时间戳并格式化为 yyyy-MM-dd HH:mm:ss 格式
            long currentTimeSeconds = System.currentTimeMillis() / 1000;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String formattedTimestamp = sdf.format(new Date(currentTimeSeconds * 1000));
            ApiRelationContext.set("$timestamp", formattedTimestamp);

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

            // 为所有步骤结果设置 reportId（必须在 filter 之前设置，确保明细数据能正确保存）
            result.getList().forEach(item -> {
                item.setReportId(reportDTO.getId());
            });

            int passQuantity = result.getList().stream().filter(item -> {
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
        
        // 从接口库同步信息（如果启用）
        resolveApiLibrary(step);
        
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
            //断言失败或业务异常
            resultItem.setAssertionState(false);
            // 优先使用 detail，如果没有则使用 msg，最后使用 message
            String exceptionMsg = e.getDetail();
            if (exceptionMsg == null || exceptionMsg.trim().isEmpty()) {
                exceptionMsg = e.getMsg();
            }
            if (exceptionMsg == null || exceptionMsg.trim().isEmpty()) {
                exceptionMsg = e.getMessage();
            }
            resultItem.setExceptionMsg(exceptionMsg);
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

    /**
     * 从接口库同步信息
     * 参考 UI 自动化的 resolveElementLibrary 方法
     * @param step 用例步骤
     */
    private void resolveApiLibrary(ApiCaseStepDO step) {
        // 如果未启用接口库或没有关联接口ID，则不处理
        if (step.getApiId() == null || step.getUseApiLibrary() == null || !step.getUseApiLibrary()) {
            return;
        }

        try {
            // 查询接口库中的接口信息
            LambdaQueryWrapper<ApiDO> queryWrapper = new LambdaQueryWrapper<>(ApiDO.class);
            queryWrapper.eq(ApiDO::getId, step.getApiId())
                       .eq(ApiDO::getProjectId, step.getProjectId());
            ApiDO apiDO = apiMapper.selectOne(queryWrapper);

            if (apiDO != null) {
                // 接口存在，同步最新的接口信息
                log.info("从接口库同步信息 - 步骤ID: {}, 接口ID: {}, 接口名称: {}", 
                        step.getId(), apiDO.getId(), apiDO.getName());
                
                // 同步接口基本信息
                step.setMethod(apiDO.getMethod());
                step.setPath(apiDO.getPath());
                step.setEnvironmentId(apiDO.getEnvironmentId());
                
                // 同步请求参数（如果接口库中有配置）
                if (StringUtils.isNotBlank(apiDO.getQuery())) {
                    step.setQuery(apiDO.getQuery());
                }
                if (StringUtils.isNotBlank(apiDO.getHeader())) {
                    step.setHeader(apiDO.getHeader());
                }
                if (StringUtils.isNotBlank(apiDO.getBody())) {
                    step.setBody(apiDO.getBody());
                }
                if (StringUtils.isNotBlank(apiDO.getBodyType())) {
                    step.setBodyType(apiDO.getBodyType());
                }
            } else {
                // 接口不存在（已从接口库中删除），使用步骤中的备用信息
                log.warn("接口库中的接口不存在 - 步骤ID: {}, 接口ID: {}, 将使用备用接口信息", 
                        step.getId(), step.getApiId());
            }
        } catch (Exception e) {
            // 查询失败，使用步骤中的备用信息，不中断执行
            log.error("从接口库同步信息失败 - 步骤ID: {}, 接口ID: {}, 错误: {}", 
                     step.getId(), step.getApiId(), e.getMessage());
        }
    }


}
