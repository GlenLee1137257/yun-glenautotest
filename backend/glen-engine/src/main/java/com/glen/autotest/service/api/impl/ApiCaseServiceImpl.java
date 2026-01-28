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
import com.glen.autotest.req.api.ApiCaseBatchExecuteReq;
import com.glen.autotest.req.api.ApiCaseSaveReq;
import com.glen.autotest.req.api.ApiCaseUpdateReq;
import com.glen.autotest.service.api.ApiCaseService;
import com.glen.autotest.service.api.core.ApiExecuteEngine;
import com.glen.autotest.util.JsonData;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
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
        caseStepQueryWrapper.eq(ApiCaseStepDO::getCaseId, apiCaseDO.getId())
                .orderByAsc(ApiCaseStepDO::getNum)
                .orderByDesc(ApiCaseStepDO::getGmtModified); // num相同时，按修改时间降序排序（修改时间越新的越先执行）
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
        req.getList().forEach(step -> {
            ApiCaseStepDO apiCaseStepDO = SpringBeanUtil.copyProperties(step, ApiCaseStepDO.class);
            apiCaseStepDO.setCaseId(apiCaseDO.getId());
            // 设置 projectId，确保步骤关联到正确的项目
            apiCaseStepDO.setProjectId(req.getProjectId());
            apiCaseStepMapper.insert(apiCaseStepDO);
        });

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
            stepQueryWrapper.eq(ApiCaseStepDO::getCaseId, apiCaseDO.getId())
                    .orderByAsc(ApiCaseStepDO::getNum)
                    .orderByDesc(ApiCaseStepDO::getGmtModified); // num相同时，按修改时间降序排序（修改时间越新的越先执行）
            List<ApiCaseStepDO> apiCaseStepDOS = apiCaseStepMapper.selectList(stepQueryWrapper);
            if(apiCaseStepDOS == null || apiCaseStepDOS.isEmpty()){
                throw new BizException(BizCodeEnum.API_CASE_STEP_IS_EMPTY);
            }
            //初始化测试报告
            try {
                ReportSaveReq reportSaveReq = ReportSaveReq.builder().projectId(apiCaseDO.getProjectId())
                        .caseId(apiCaseDO.getId())
                        .startTime(System.currentTimeMillis())
                        .executeState(ReportStateEnum.EXECUTING.name())
                        .name(apiCaseDO.getName())
                        .type(TestTypeEnum.API.name()).build();
                JsonData jsonData = reportFeignService.save(reportSaveReq);
                if(jsonData != null && jsonData.isSuccess()){
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
                    String errorMsg = jsonData != null ? jsonData.getMsg() : "Feign调用返回null";
                    log.error("API接口用例执行，初始化测试报告失败，用例ID：{}，项目ID：{}，错误信息：{}", 
                        apiCaseDO.getId(), apiCaseDO.getProjectId(), errorMsg);
                    return JsonData.buildError("API接口用例执行，初始化测试报告失败：" + errorMsg);
                }
            } catch (Exception e) {
                log.error("API接口用例执行，初始化测试报告异常，用例ID：{}，项目ID：{}，异常信息：{}", 
                    apiCaseDO.getId(), apiCaseDO.getProjectId(), e.getMessage(), e);
                return JsonData.buildError("API接口用例执行，初始化测试报告失败：" + e.getMessage() + "。请确保glen-data服务已正常运行。");
            }
        } else {
            return JsonData.buildError("用例不存在");
        }

    }

    /**
     * 批量执行用例
     * 
     * @param req 批量执行请求
     * @return 执行结果
     */
    @Override
    public JsonData batchExecute(ApiCaseBatchExecuteReq req) {
        if (req.getCaseIds() == null || req.getCaseIds().isEmpty()) {
            return JsonData.buildError("请选择要执行的用例");
        }

        log.info("开始批量执行接口用例，项目ID：{}，用例数量：{}", req.getProjectId(), req.getCaseIds().size());

        List<Map<String, Object>> results = new ArrayList<>();
        int successCount = 0;
        int failCount = 0;

        for (Long caseId : req.getCaseIds()) {
            Map<String, Object> result = new HashMap<>();
            result.put("caseId", caseId);
            
            try {
                // 查询用例名称
                LambdaQueryWrapper<ApiCaseDO> queryWrapper = new LambdaQueryWrapper<>();
                queryWrapper.eq(ApiCaseDO::getProjectId, req.getProjectId())
                           .eq(ApiCaseDO::getId, caseId);
                ApiCaseDO apiCaseDO = apiCaseMapper.selectOne(queryWrapper);
                
                if (apiCaseDO == null) {
                    result.put("caseName", "未知用例");
                    result.put("success", false);
                    result.put("message", "用例不存在");
                    failCount++;
                } else {
                    result.put("caseName", apiCaseDO.getName());
                    
                    // 执行单个用例
                    JsonData executeResult = execute(req.getProjectId(), caseId);
                    
                    if (executeResult.isSuccess()) {
                        result.put("success", true);
                        result.put("message", "执行成功");
                        result.put("data", executeResult.getData());
                        successCount++;
                    } else {
                        result.put("success", false);
                        result.put("message", executeResult.getMsg());
                        failCount++;
                    }
                }
            } catch (Exception e) {
                log.error("批量执行接口用例失败，用例ID：{}，异常信息：{}", caseId, e.getMessage(), e);
                result.put("success", false);
                result.put("message", "执行异常：" + e.getMessage());
                failCount++;
            }
            
            results.add(result);
        }

        Map<String, Object> summary = new HashMap<>();
        summary.put("total", req.getCaseIds().size());
        summary.put("success", successCount);
        summary.put("fail", failCount);
        summary.put("results", results);

        log.info("批量执行接口用例完成，项目ID：{}，总数：{}，成功：{}，失败：{}", 
                req.getProjectId(), req.getCaseIds().size(), successCount, failCount);

        return JsonData.buildSuccess(summary);
    }

    /**
     * 按模块执行用例
     * 
     * @param projectId 项目ID
     * @param moduleId 模块ID
     * @return 执行结果
     */
    @Override
    public JsonData executeByModule(Long projectId, Long moduleId) {
        log.info("开始按模块执行接口用例，项目ID：{}，模块ID：{}", projectId, moduleId);

        // 查询模块下的所有用例
        LambdaQueryWrapper<ApiCaseDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ApiCaseDO::getProjectId, projectId)
                   .eq(ApiCaseDO::getModuleId, moduleId);
        List<ApiCaseDO> apiCaseDOS = apiCaseMapper.selectList(queryWrapper);

        if (apiCaseDOS == null || apiCaseDOS.isEmpty()) {
            return JsonData.buildError("该模块下没有用例");
        }

        // 提取用例ID列表
        List<Long> caseIds = new ArrayList<>();
        for (ApiCaseDO apiCaseDO : apiCaseDOS) {
            caseIds.add(apiCaseDO.getId());
        }

        // 调用批量执行
        ApiCaseBatchExecuteReq req = new ApiCaseBatchExecuteReq();
        req.setProjectId(projectId);
        req.setCaseIds(caseIds);
        req.setModuleId(moduleId);

        return batchExecute(req);
    }
}
