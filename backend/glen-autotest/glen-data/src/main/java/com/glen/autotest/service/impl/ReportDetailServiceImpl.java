package com.glen.autotest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.glen.autotest.dto.*;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.controller.req.ReportDetailPageReq;
import com.glen.autotest.enums.ReportStateEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.mapper.ReportDetailApiMapper;
import com.glen.autotest.mapper.ReportDetailStressMapper;
import com.glen.autotest.mapper.ReportDetailUiMapper;
import com.glen.autotest.mapper.ReportMapper;
import com.glen.autotest.model.ReportDO;
import com.glen.autotest.model.ReportDetailApiDO;
import com.glen.autotest.model.ReportDetailStressDO;
import com.glen.autotest.model.ReportDetailUiDO;
import com.glen.autotest.service.ReportDetailService;
import com.glen.autotest.util.JsonUtil;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Lee
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Service
@Slf4j
public class ReportDetailServiceImpl implements ReportDetailService {

    @Resource
    private ReportDetailStressMapper reportDetailStressMapper;

    @Resource
    private ReportDetailApiMapper reportDetailApiMapper;

    @Resource
    private ReportMapper reportMapper;

    @Resource
    private ReportDetailUiMapper reportDetailUiMapper;

    @Override
    public void handleStressReportDetail(String topicContent) {

        StressSampleResultDTO stressSampleResultDTO = JsonUtil.json2Obj(topicContent, StressSampleResultDTO.class);

        ReportDetailStressDO reportDetailStressDO = SpringBeanUtil.copyProperties(stressSampleResultDTO, ReportDetailStressDO.class);

        reportDetailStressMapper.insert(reportDetailStressDO);

    }

    @Override
    public void handleApiReportDetail(String reportContent) {

        ApiCaseResultDTO apiCaseResultDTO = JsonUtil.json2Obj(reportContent, ApiCaseResultDTO.class);

        //处理测试报告的概述
        ReportDO reportDO = reportMapper.selectById(apiCaseResultDTO.getReportId());
        reportDO.setExecuteState(ReportStateEnum.EXECUTE_SUCCESS.name());
        reportDO.setEndTime(apiCaseResultDTO.getEndTime());
        reportDO.setExpandTime(apiCaseResultDTO.getExpendTime());
        reportDO.setQuantity(Long.valueOf(apiCaseResultDTO.getQuantity()));
        reportDO.setFailQuantity(Long.valueOf(apiCaseResultDTO.getFailQuantity()));
        reportDO.setPassQuantity(reportDO.getQuantity() - reportDO.getFailQuantity());
        //更新概述
        reportMapper.updateById(reportDO);

        //处理测试报告明细
        List<ApiCaseResultItemDTO> stepList = apiCaseResultDTO.getList();
        stepList.forEach(item->{

            ReportDetailApiDO reportDetailApiDO = SpringBeanUtil.copyProperties(item, ReportDetailApiDO.class);
            ApiCaseStepDTO step = item.getApiCaseStep();
            reportDetailApiDO.setEnvironmentId(step.getEnvironmentId());
            reportDetailApiDO.setCaseId(step.getCaseId());
            reportDetailApiDO.setNum(step.getNum());
            reportDetailApiDO.setName(step.getName());
            reportDetailApiDO.setDescription(step.getDescription());
            reportDetailApiDO.setAssertion(step.getAssertion());
            reportDetailApiDO.setRelation(step.getRelation());
            reportDetailApiDO.setPath(step.getPath());
            reportDetailApiDO.setMethod(step.getMethod());
            reportDetailApiDO.setQuery(step.getQuery());
            reportDetailApiDO.setHeader(step.getHeader());
            reportDetailApiDO.setBody(step.getBody());
            reportDetailApiDO.setBodyType(step.getBodyType());
            reportDetailApiMapper.insert(reportDetailApiDO);
        });


    }

    @Override
    public void handleUiReportDetail(String reportContent) {
        UiCaseResultDTO uiCaseResultDTO = JsonUtil.json2Obj(reportContent, UiCaseResultDTO.class);
        ReportDO reportDO = reportMapper.selectById(uiCaseResultDTO.getReportId());
        reportDO.setExecuteState(ReportStateEnum.EXECUTE_SUCCESS.name());
        reportDO.setEndTime(uiCaseResultDTO.getEndTime());
        reportDO.setExpandTime(uiCaseResultDTO.getExpendTime());
        reportDO.setQuantity(Long.valueOf(uiCaseResultDTO.getQuantity()));
        reportDO.setFailQuantity(Long.valueOf(uiCaseResultDTO.getFailQuantity()));
        reportDO.setPassQuantity(reportDO.getQuantity() - reportDO.getFailQuantity());

        reportMapper.updateById(reportDO);

        //处理报告明细
        List<UiCaseResultItemDTO> stepList = uiCaseResultDTO.getList();
        stepList.forEach(item->{
            ReportDetailUiDO reportDetailUiDO = SpringBeanUtil.copyProperties(item, ReportDetailUiDO.class);
            UiCaseStepDTO uiCaseStep = item.getUiCaseStep();
            SpringBeanUtil.copyProperties(uiCaseStep, reportDetailUiDO);
            reportDetailUiDO.setId(null);
            reportDetailUiMapper.insert(reportDetailUiDO);
        });


    }

    @Override
    public Map<String, Object> page(ReportDetailPageReq req) {
        // 将类型转为大写，兼容前端传入的小写值（如 'api' -> 'API'）
        TestTypeEnum testTypeEnum = TestTypeEnum.valueOf(req.getType().toUpperCase());
        Map<String,Object> pageMap = new HashMap<>(3);
        switch (testTypeEnum){
            case STRESS:
                Page<ReportDetailStressDO> stressPage = new Page<>(req.getPage(), req.getSize());
                LambdaQueryWrapper<ReportDetailStressDO> stressQueryWrapper = new LambdaQueryWrapper<>();
                stressQueryWrapper.eq(ReportDetailStressDO::getReportId,req.getReportId());
                Page<ReportDetailStressDO> reportDetailStressDOPage = reportDetailStressMapper.selectPage(stressPage, stressQueryWrapper);
                List<ReportDetailStressDO> stressRecords = reportDetailStressDOPage.getRecords();
                List<ReportDetailStressDTO> reportDetailStressDTOS = SpringBeanUtil.copyProperties(stressRecords, ReportDetailStressDTO.class);
                pageMap.put("total_record",reportDetailStressDOPage.getTotal());
                pageMap.put("total_page",reportDetailStressDOPage.getPages());
                pageMap.put("current_data",reportDetailStressDTOS);
                break;
            case API:
                Page<ReportDetailApiDO> apiPage = new Page<>(req.getPage(), req.getSize());
                LambdaQueryWrapper<ReportDetailApiDO> apiQueryWrapper = new LambdaQueryWrapper<>();
                apiQueryWrapper.eq(ReportDetailApiDO::getReportId,req.getReportId());
                Page<ReportDetailApiDO> reportDetailApiDOPage = reportDetailApiMapper.selectPage(apiPage, apiQueryWrapper);
                List<ReportDetailApiDO> apiRecords = reportDetailApiDOPage.getRecords();
                List<ReportDetailApiDTO> reportDetailApiDTOS = SpringBeanUtil.copyProperties(apiRecords, ReportDetailApiDTO.class);
                pageMap.put("total_record",reportDetailApiDOPage.getTotal());
                pageMap.put("total_page",reportDetailApiDOPage.getPages());
                pageMap.put("current_data",reportDetailApiDTOS);
                break;
            case UI:
                Page<ReportDetailUiDO> uiPage = new Page<>(req.getPage(), req.getSize());
                LambdaQueryWrapper<ReportDetailUiDO> uiQueryWrapper = new LambdaQueryWrapper<>();
                uiQueryWrapper.eq(ReportDetailUiDO::getReportId,req.getReportId());
                Page<ReportDetailUiDO> reportDetailUiDOPage = reportDetailUiMapper.selectPage(uiPage, uiQueryWrapper);
                List<ReportDetailUiDO> records = reportDetailUiDOPage.getRecords();
                List<ReportDetailUiDTO> reportDetailUiDTOS = SpringBeanUtil.copyProperties(records, ReportDetailUiDTO.class);
                pageMap.put("total_record",reportDetailUiDOPage.getTotal());
                pageMap.put("total_page",reportDetailUiDOPage.getPages());
                pageMap.put("current_data",reportDetailUiDTOS);
                break;
            default:
                break;
        }
        return pageMap;
    }

}
