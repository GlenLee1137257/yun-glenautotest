package com.glen.autotest.service.api.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.ApiCaseResultDTO;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.api.ApiCaseDTO;
import com.glen.autotest.dto.ApiCaseStepDTO;
import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.enums.BizCodeEnum;
import com.glen.autotest.enums.ReportStateEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.feign.ReportFeignService;
import com.glen.autotest.mapper.ApiCaseMapper;
import com.glen.autotest.mapper.ApiCaseStepMapper;
import com.glen.autotest.model.ApiCaseDO;
import com.glen.autotest.model.ApiCaseStepDO;
import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.req.api.ApiCaseSaveReq;
import com.glen.autotest.req.api.ApiCaseUpdateReq;
import com.glen.autotest.service.api.ApiCaseService;
import com.glen.autotest.service.api.core.ApiExecuteEngine;
import com.glen.autotest.util.JsonData;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.List;

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
public class ApiCaseServiceImpl implements ApiCaseService {

    @Resource
    private ApiCaseMapper apiCaseMapper;

    @Resource
    private ApiCaseStepMapper apiCaseStepMapper;

    @Resource
    private ReportFeignService reportFeignService;

    @Override
    public ApiCaseDTO getById(Long projectId, Long id) {
        LambdaQueryWrapper<ApiCaseDO> queryWrapper = new LambdaQueryWrapper<ApiCaseDO>();
        queryWrapper.eq(ApiCaseDO::getProjectId, projectId).eq(ApiCaseDO::getId, id);
        ApiCaseDO apiCaseDO = apiCaseMapper.selectOne(queryWrapper);
        
        // 如果查询结果为空，返回 null
        if (apiCaseDO == null) {
            return null;
        }
        
        ApiCaseDTO apiCaseDTO = SpringBeanUtil.copyProperties(apiCaseDO, ApiCaseDTO.class);

        //查找关联的步骤
        LambdaQueryWrapper<ApiCaseStepDO> caseStepQueryWrapper = new LambdaQueryWrapper<ApiCaseStepDO>();
        caseStepQueryWrapper.eq(ApiCaseStepDO::getCaseId, apiCaseDO.getId()).orderByAsc(ApiCaseStepDO::getNum);
        List<ApiCaseStepDO> apiCaseStepDOS = apiCaseStepMapper.selectList(caseStepQueryWrapper);
        List<ApiCaseStepDTO> apiCaseStepDTOS = SpringBeanUtil.copyProperties(apiCaseStepDOS, ApiCaseStepDTO.class);

        apiCaseDTO.setList(apiCaseStepDTOS);
        return apiCaseDTO;
    }

    @Override
    public int save(ApiCaseSaveReq req) {
        ApiCaseDO apiCaseDO = SpringBeanUtil.copyProperties(req, ApiCaseDO.class);
        int insert = apiCaseMapper.insert(apiCaseDO);
        //保存用例下的步骤
        if (req.getList() != null && !req.getList().isEmpty()) {
            req.getList().forEach(step -> {
                ApiCaseStepDO apiCaseStepDO = SpringBeanUtil.copyProperties(step, ApiCaseStepDO.class);
                apiCaseStepDO.setCaseId(apiCaseDO.getId());
                apiCaseStepMapper.insert(apiCaseStepDO);
            });
        }

        return insert;
    }

    @Override
    public int update(ApiCaseUpdateReq req) {
        ApiCaseDO apiCaseDO = SpringBeanUtil.copyProperties(req, ApiCaseDO.class);
        LambdaQueryWrapper<ApiCaseDO> queryWrapper = new LambdaQueryWrapper<ApiCaseDO>();
        queryWrapper.eq(ApiCaseDO::getProjectId, req.getProjectId()).eq(ApiCaseDO::getId, req.getId());
        return apiCaseMapper.update(apiCaseDO, queryWrapper);
    }

    @Override
    public int del(Long projectId, Long id) {
        LambdaQueryWrapper<ApiCaseDO> queryWrapper = new LambdaQueryWrapper<ApiCaseDO>();
        queryWrapper.eq(ApiCaseDO::getProjectId, projectId).eq(ApiCaseDO::getId, id);
        int delete = apiCaseMapper.delete(queryWrapper);

        //删除用例下的步骤
        LambdaQueryWrapper<ApiCaseStepDO> queryWrapperStep = new LambdaQueryWrapper<ApiCaseStepDO>();
        queryWrapperStep.eq(ApiCaseStepDO::getCaseId, id);
        apiCaseStepMapper.delete(queryWrapperStep);
        return delete;
    }

    /**
     * 查询用例
     * 查询用例关联的步骤
     * 初始化测试报告
     * 执行自动化测试
     * 响应结果
     *
     * @param projectId
     * @param caseId
     * @return
     */
    @Override
    public JsonData execute(Long projectId, Long caseId) {
        LambdaQueryWrapper<ApiCaseDO> queryWrapper = new LambdaQueryWrapper<ApiCaseDO>();
        queryWrapper.eq(ApiCaseDO::getProjectId, projectId).eq(ApiCaseDO::getId, caseId);
        ApiCaseDO apiCaseDO = apiCaseMapper.selectOne(queryWrapper);
        if (apiCaseDO != null) {
            //查找用例关联的步骤
            LambdaQueryWrapper<ApiCaseStepDO> stepQueryWrapper = new LambdaQueryWrapper<ApiCaseStepDO>();
            stepQueryWrapper.eq(ApiCaseStepDO::getCaseId, apiCaseDO.getId()).orderByAsc(ApiCaseStepDO::getNum);
            List<ApiCaseStepDO> apiCaseStepDOS = apiCaseStepMapper.selectList(stepQueryWrapper);
            if(apiCaseStepDOS == null || apiCaseStepDOS.isEmpty()){
                throw new BizException(BizCodeEnum.API_CASE_STEP_IS_EMPTY);
            }
            //初始化测试报告
            ReportSaveReq reportSaveReq = ReportSaveReq.builder().projectId(apiCaseDO.getProjectId())
                    .caseId(apiCaseDO.getId())
                    .startTime(System.currentTimeMillis())
                    .executeState(ReportStateEnum.EXECUTING.name())
                    .name(apiCaseDO.getName())
                    .type(TestTypeEnum.API.name()).build();
            JsonData jsonData = reportFeignService.save(reportSaveReq);
            if(jsonData.isSuccess()){
                //执行用例
                ReportDTO reportDTO = jsonData.getData(ReportDTO.class);

                CaseInfoDTO caseInfoDTO = new CaseInfoDTO();
                caseInfoDTO.setId(apiCaseDO.getId());
                caseInfoDTO.setModuleId(apiCaseDO.getModuleId());
                caseInfoDTO.setName(apiCaseDO.getName());

                ApiExecuteEngine apiExecuteEngine = new ApiExecuteEngine(reportDTO);
                ApiCaseResultDTO  apiCaseResultDTO = apiExecuteEngine.execute(caseInfoDTO, apiCaseStepDOS);
                return JsonData.buildSuccess(apiCaseResultDTO);
            }else {
                log.error("API接口用例执行，初始化测试报告失败,{}",apiCaseDO);
                return JsonData.buildError("API接口用例执行，初始化测试报告失败");
            }
        } else {
            return JsonData.buildError("用例不存在");
        }

    }
}
