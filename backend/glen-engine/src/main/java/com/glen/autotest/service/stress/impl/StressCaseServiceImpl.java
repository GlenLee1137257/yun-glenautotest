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
import com.glen.autotest.req.stress.StressCaseSaveReq;
import com.glen.autotest.req.stress.StressCaseUpdateReq;
import com.glen.autotest.service.stress.StressCaseService;
import com.glen.autotest.service.stress.core.BaseStressEngine;
import com.glen.autotest.service.stress.core.StressJmxEngine;
import com.glen.autotest.service.stress.core.StressSimpleEngine;
import com.glen.autotest.util.JsonData;
import com.glen.autotest.util.SpringBeanUtil;
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

        if (stressCaseDO != null) {
            //初始化测试报告
            ReportSaveReq reportSaveReq = ReportSaveReq.builder().projectId(stressCaseDO.getProjectId())
                    .caseId(stressCaseDO.getId())
                    .startTime(System.currentTimeMillis())
                    .executeState(ReportStateEnum.EXECUTING.name())
                    .name(stressCaseDO.getName())
                    .type(TestTypeEnum.STRESS.name())
                    .build();
            JsonData jsonData = reportFeignService.save(reportSaveReq);
            if (jsonData.isSuccess()) {
                ReportDTO reportDTO = jsonData.getData(ReportDTO.class);

                //判断压测类型 JMX、SIMPLE
                if (StressSourceTypeEnum.JMX.name().equalsIgnoreCase(stressCaseDO.getStressSourceType())) {
                    runJmxStressCase(stressCaseDO, reportDTO);
                } else if (StressSourceTypeEnum.SIMPLE.name().equalsIgnoreCase(stressCaseDO.getStressSourceType())) {

                    runSimpleStressCase(stressCaseDO, reportDTO);

                } else {
                    throw new BizException(BizCodeEnum.STRESS_UNSUPPORTED);
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
        //创建引擎
        BaseStressEngine stressEngine = new StressSimpleEngine(environmentDO,stressCaseDO,reportDTO,applicationContext);

        //运行压测
        stressEngine.startStressTest();
    }
}
