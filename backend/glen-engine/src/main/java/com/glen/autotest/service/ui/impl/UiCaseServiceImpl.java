package com.glen.autotest.service.ui.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.dto.UiCaseDTO;
import com.glen.autotest.dto.UiCaseStepDTO;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.dto.UiCaseResultDTO;
import com.glen.autotest.enums.ReportStateEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.feign.ReportFeignService;
import com.glen.autotest.mapper.UiCaseMapper;
import com.glen.autotest.mapper.UiCaseStepMapper;
import com.glen.autotest.model.UiCaseDO;
import com.glen.autotest.model.UiCaseStepDO;
import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.req.ui.UiCaseBatchExecuteReq;
import com.glen.autotest.req.ui.UiCaseDelReq;
import com.glen.autotest.req.ui.UiCaseSaveReq;
import com.glen.autotest.req.ui.UiCaseUpdateReq;
import com.glen.autotest.service.ui.UiCaseService;
import com.glen.autotest.service.ui.core.UiExecuteEngine;
import com.glen.autotest.util.JsonData;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class UiCaseServiceImpl implements UiCaseService {

    @Resource
    private UiCaseMapper uiCaseMapper;

    @Resource
    private UiCaseStepMapper uiCaseStepMapper;

    @Resource
    private ReportFeignService reportFeignService;

    @Override
    public UiCaseDTO find(Long projectId, Long caseId) {
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        queryWrapper.eq(UiCaseDO::getProjectId, projectId).eq(UiCaseDO::getId, caseId);
        UiCaseDO uiCaseDO = uiCaseMapper.selectOne(queryWrapper);
        
        if (uiCaseDO == null) {
            return null;
        }
        
        UiCaseDTO uiCaseDTO = SpringBeanUtil.copyProperties(uiCaseDO, UiCaseDTO.class);
        List<UiCaseStepDO> stepList = getStepList(uiCaseDO.getId());
        List<UiCaseStepDTO> stepDTOList = SpringBeanUtil.copyProperties(stepList, UiCaseStepDTO.class);
        uiCaseDTO.setList(stepDTOList);
        return uiCaseDTO;
    }

    @Override
    public Integer update(UiCaseUpdateReq req) {
        UiCaseDO uiCaseDO = SpringBeanUtil.copyProperties(req, UiCaseDO.class);
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        queryWrapper.eq(UiCaseDO::getId, req.getId()).eq(UiCaseDO::getProjectId, req.getProjectId());
        return uiCaseMapper.update(uiCaseDO, queryWrapper);
    }

    @Override
    public Integer save(UiCaseSaveReq req) {
        UiCaseDO uiCaseDO = SpringBeanUtil.copyProperties(req, UiCaseDO.class);
        int insert = uiCaseMapper.insert(uiCaseDO);
        if(req.getList()!=null){
             req.getList().forEach(uiCaseStepSaveReq -> {
                 UiCaseStepDO uiCaseStepDO = SpringBeanUtil.copyProperties(uiCaseStepSaveReq, UiCaseStepDO.class);
                 uiCaseStepDO.setCaseId(uiCaseDO.getId());
                 uiCaseStepMapper.insert(uiCaseStepDO);
             });
         }
        return insert;
    }

    @Override
    public JsonData execute(Long projectId, Long caseId) {
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        queryWrapper.eq(UiCaseDO::getProjectId, projectId).eq(UiCaseDO::getId, caseId);
        UiCaseDO uiCaseDO = uiCaseMapper.selectOne(queryWrapper);

        if(uiCaseDO!=null){
            List<UiCaseStepDO> stepList = getStepList(uiCaseDO.getId());
            if(stepList.isEmpty()){
                throw new IllegalArgumentException("用例步骤为空");
            }
            ReportSaveReq reportSaveReq = ReportSaveReq.builder().projectId(uiCaseDO.getProjectId())
                    .caseId(uiCaseDO.getId())
                    .startTime(System.currentTimeMillis())
                    .executeState(ReportStateEnum.EXECUTING.name())
                    .name(uiCaseDO.getName())
                    .type(TestTypeEnum.UI.name()).build();
            JsonData jsonData = reportFeignService.save(reportSaveReq);
            if(jsonData.isSuccess()){
                ReportDTO reportDTO = jsonData.getData(ReportDTO.class);
                CaseInfoDTO caseInfoDTO = new CaseInfoDTO();
                caseInfoDTO.setId(uiCaseDO.getId());
                caseInfoDTO.setModuleId(uiCaseDO.getModuleId());
                caseInfoDTO.setName(uiCaseDO.getName());

                UiExecuteEngine uiExecuteEngine = new UiExecuteEngine(reportDTO);
                UiCaseResultDTO uiCaseResultDTO = uiExecuteEngine.execute(caseInfoDTO,uiCaseDO.getBrowser(),stepList,uiCaseDO.getHeadlessMode());

                return JsonData.buildSuccess(uiCaseResultDTO);
            }else {
                log.error("初始化测试报告失败，原因：{}",jsonData.getMsg());
                return JsonData.buildError("初始化测试报告失败");
            }
        }else {
            return JsonData.buildError("用例不存在");
        }
    }

    private List<UiCaseStepDO> getStepList(Long uiCaseId) {
        LambdaQueryWrapper<UiCaseStepDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseStepDO.class);
        queryWrapper.eq(UiCaseStepDO::getCaseId, uiCaseId)
                .orderByAsc(UiCaseStepDO::getNum)
                .orderByDesc(UiCaseStepDO::getGmtModified);
        return uiCaseStepMapper.selectList(queryWrapper);
    }

    @Override
    public Integer delete(UiCaseDelReq req) {
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        queryWrapper.eq(UiCaseDO::getProjectId, req.getProjectId()).eq(UiCaseDO::getId, req.getId());
        int delete = uiCaseMapper.delete(queryWrapper);

        LambdaQueryWrapper<UiCaseStepDO> stepQueryWrapper = new LambdaQueryWrapper<>(UiCaseStepDO.class);
        stepQueryWrapper.eq(UiCaseStepDO::getCaseId, req.getId());
        uiCaseStepMapper.delete(stepQueryWrapper);
        
        return delete;
    }

    /**
     * 批量执行用例
     * 
     * @param req 批量执行请求
     * @return 执行结果
     */
    @Override
    public JsonData batchExecute(UiCaseBatchExecuteReq req) {
        if (req.getCaseIds() == null || req.getCaseIds().isEmpty()) {
            return JsonData.buildError("请选择要执行的用例");
        }

        log.info("开始批量执行UI用例，项目ID：{}，用例数量：{}", req.getProjectId(), req.getCaseIds().size());

        List<Map<String, Object>> results = new ArrayList<>();
        int successCount = 0;
        int failCount = 0;

        for (Long caseId : req.getCaseIds()) {
            Map<String, Object> result = new HashMap<>();
            result.put("caseId", caseId);
            
            try {
                // 查询用例名称
                LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>();
                queryWrapper.eq(UiCaseDO::getProjectId, req.getProjectId())
                           .eq(UiCaseDO::getId, caseId);
                UiCaseDO uiCaseDO = uiCaseMapper.selectOne(queryWrapper);
                
                if (uiCaseDO == null) {
                    result.put("caseName", "未知用例");
                    result.put("success", false);
                    result.put("message", "用例不存在");
                    failCount++;
                } else {
                    result.put("caseName", uiCaseDO.getName());
                    
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
                log.error("批量执行UI用例失败，用例ID：{}，异常信息：{}", caseId, e.getMessage(), e);
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

        log.info("批量执行UI用例完成，项目ID：{}，总数：{}，成功：{}，失败：{}", 
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
        log.info("开始按模块执行UI用例，项目ID：{}，模块ID：{}", projectId, moduleId);

        // 查询模块下的所有用例
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(UiCaseDO::getProjectId, projectId)
                   .eq(UiCaseDO::getModuleId, moduleId);
        List<UiCaseDO> uiCaseDOS = uiCaseMapper.selectList(queryWrapper);

        if (uiCaseDOS == null || uiCaseDOS.isEmpty()) {
            return JsonData.buildError("该模块下没有用例");
        }

        // 提取用例ID列表
        List<Long> caseIds = new ArrayList<>();
        for (UiCaseDO uiCaseDO : uiCaseDOS) {
            caseIds.add(uiCaseDO.getId());
        }

        // 调用批量执行
        UiCaseBatchExecuteReq req = new UiCaseBatchExecuteReq();
        req.setProjectId(projectId);
        req.setCaseIds(caseIds);
        req.setModuleId(moduleId);

        return batchExecute(req);
    }
}
