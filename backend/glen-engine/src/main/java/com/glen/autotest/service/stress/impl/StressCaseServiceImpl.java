package com.glen.autotest.service.stress.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.stress.StressCaseDTO;
import com.glen.autotest.enums.BizCodeEnum;
import com.glen.autotest.enums.ReportStateEnum;
import com.glen.autotest.enums.StressSourceTypeEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.feign.ReportFeignService;
import com.glen.autotest.mapper.EnvironmentMapper;
import com.glen.autotest.mapper.StressCaseMapper;
import com.glen.autotest.model.EnvironmentDO;
import com.glen.autotest.model.StressCaseDO;
import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.req.ReportUpdateReq;
import com.glen.autotest.req.stress.StressCaseSaveReq;
import com.glen.autotest.req.stress.StressCaseUpdateReq;
import com.glen.autotest.service.stress.StressCaseService;
import com.glen.autotest.service.stress.core.BaseStressEngine;
import com.glen.autotest.service.stress.core.StressJmxEngine;
import com.glen.autotest.service.stress.core.StressSimpleEngine;
import com.glen.autotest.util.JsonData;
import com.glen.autotest.util.SpringBeanUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Slf4j
@Service
public class StressCaseServiceImpl implements StressCaseService {

    @Resource
    private StressCaseMapper stressCaseMapper;

    @Resource
    private ReportFeignService reportFeignService;


    @Resource
    private ApplicationContext applicationContext;


    @Resource
    private EnvironmentMapper environmentMapper;

    @Override
    public StressCaseDTO findById(Long projectId, Long caseId) {
        LambdaQueryWrapper<StressCaseDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(StressCaseDO::getProjectId, projectId)
                .eq(StressCaseDO::getId, caseId);
        StressCaseDO stressCaseDO = stressCaseMapper.selectOne(queryWrapper);
        return SpringBeanUtil.copyProperties(stressCaseDO, StressCaseDTO.class);
    }

    @Override
    public int delete(Long projectId, Long id) {
        LambdaQueryWrapper<StressCaseDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(StressCaseDO::getProjectId, projectId)
                .eq(StressCaseDO::getId, id);
        return stressCaseMapper.delete(queryWrapper);
    }

    @Override
    public int save(StressCaseSaveReq req) {
        StressCaseDO stressCaseDO = SpringBeanUtil.copyProperties(req, StressCaseDO.class);
        return stressCaseMapper.insert(stressCaseDO);
    }

    @Override
    public int update(StressCaseUpdateReq req) {
        StressCaseDO stressCaseDO = SpringBeanUtil.copyProperties(req, StressCaseDO.class);
        LambdaQueryWrapper<StressCaseDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(StressCaseDO::getProjectId, stressCaseDO.getProjectId())
                .eq(StressCaseDO::getId, stressCaseDO.getId());
        return stressCaseMapper.update(stressCaseDO, queryWrapper);
    }

    /**
     * 执行用例
     * 【1】查询用例详情
     * 【2】初始化测试报告
     * 【3】判断压测类型 JMX、SIMPLE
     * 【4】初始化测试引擎
     * 【5】组装测试计划
     * 【6】执行压测
     * 【7】发送压测结果明细
     * 【8】压测完成清理数据
     * 【9】通知压测结束
     */
    @Override
    @Async("testExecutor")
    public void execute(Long projectId, Long caseId) {
        LambdaQueryWrapper<StressCaseDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(StressCaseDO::getProjectId, projectId)
                .eq(StressCaseDO::getId, caseId);
        StressCaseDO stressCaseDO = stressCaseMapper.selectOne(queryWrapper);

        if (stressCaseDO == null) {
            log.error("压测用例不存在：projectId={}, caseId={}", projectId, caseId);
            return;
        }

        ReportDTO reportDTO = null;
        try {
            //初始化测试报告
            ReportSaveReq reportSaveReq = ReportSaveReq.builder().projectId(stressCaseDO.getProjectId())
                    .caseId(stressCaseDO.getId())
                    .startTime(System.currentTimeMillis())
                    .executeState(ReportStateEnum.EXECUTING.name())
                    .name(stressCaseDO.getName())
                    .type(TestTypeEnum.STRESS.name())
                    .build();
            JsonData jsonData = reportFeignService.save(reportSaveReq);
            
            if (!jsonData.isSuccess()) {
                log.error("创建压测报告失败：projectId={}, caseId={}, error={}", projectId, caseId, jsonData.getMsg());
                return;
            }
            
            reportDTO = jsonData.getData(ReportDTO.class);
            if (reportDTO == null || reportDTO.getId() == null) {
                log.error("压测报告创建失败，返回数据为空：projectId={}, caseId={}", projectId, caseId);
                return;
            }

            log.info("开始执行压测：projectId={}, caseId={}, reportId={}, type={}", 
                    projectId, caseId, reportDTO.getId(), stressCaseDO.getStressSourceType());

            //判断压测类型 JMX、SIMPLE
            if (StressSourceTypeEnum.JMX.name().equalsIgnoreCase(stressCaseDO.getStressSourceType())) {
                runJmxStressCase(stressCaseDO, reportDTO);
            } else if (StressSourceTypeEnum.SIMPLE.name().equalsIgnoreCase(stressCaseDO.getStressSourceType())) {
                runSimpleStressCase(stressCaseDO, reportDTO);
            } else {
                throw new BizException(BizCodeEnum.STRESS_UNSUPPORTED);
            }
            
            log.info("压测执行完成：projectId={}, caseId={}, reportId={}", projectId, caseId, reportDTO.getId());
            
        } catch (Exception e) {
            //捕获异常，更新报告状态为失败
            log.error("压测执行失败：projectId={}, caseId={}, reportId={}, error={}", 
                    projectId, caseId, reportDTO != null ? reportDTO.getId() : null, e.getMessage(), e);
            
            // 如果报告已创建，则更新状态为失败
            if (reportDTO != null && reportDTO.getId() != null) {
                try {
                    ReportUpdateReq reportUpdateReq = ReportUpdateReq.builder()
                            .id(reportDTO.getId())
                            .executeState(ReportStateEnum.EXECUTE_FAIL.name())
                            .endTime(System.currentTimeMillis())
                            .build();
                    reportFeignService.update(reportUpdateReq);
                    log.info("已更新压测报告状态为失败：reportId={}", reportDTO.getId());
                } catch (Exception updateException) {
                    log.error("更新压测报告状态失败：reportId={}, error={}", 
                            reportDTO.getId(), updateException.getMessage(), updateException);
                }
            }
        }
    }

    private void runJmxStressCase(StressCaseDO stressCaseDO, ReportDTO reportDTO) {
        //创建引擎
        BaseStressEngine stressEngine = new StressJmxEngine(stressCaseDO,reportDTO,applicationContext);

        //运行压测
        stressEngine.startStressTest();

    }

    private void runSimpleStressCase(StressCaseDO stressCaseDO, ReportDTO reportDTO) {

        EnvironmentDO environmentDO = environmentMapper.selectById(stressCaseDO.getEnvironmentId());
        
        // 校验环境是否存在
        if (environmentDO == null) {
            log.error("压测环境不存在：projectId={}, caseId={}, environmentId={}", 
                    stressCaseDO.getProjectId(), stressCaseDO.getId(), stressCaseDO.getEnvironmentId());
            throw new BizException(BizCodeEnum.STRESS_CASE_ID_NOT_EXIST.getCode(), 
                    "压测环境不存在，environmentId=" + stressCaseDO.getEnvironmentId() + "，请先配置正确的测试环境");
        }
        
        //创建引擎
        BaseStressEngine stressEngine = new StressSimpleEngine(environmentDO,stressCaseDO,reportDTO,applicationContext);

        //运行压测
        stressEngine.startStressTest();
    }
}
