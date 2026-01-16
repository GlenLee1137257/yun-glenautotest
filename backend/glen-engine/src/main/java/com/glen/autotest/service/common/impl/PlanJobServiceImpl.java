package com.glen.autotest.service.common.impl;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.unit.DataUnit;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.common.PlanJobDTO;
import com.glen.autotest.enums.BizCodeEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.mapper.PlanJobLogMapper;
import com.glen.autotest.mapper.PlanJobMapper;
import com.glen.autotest.model.PlanJobDO;
import com.glen.autotest.model.PlanJobLogDO;
import com.glen.autotest.req.common.PlanJobDelReq;
import com.glen.autotest.req.common.PlanJobPageReq;
import com.glen.autotest.req.common.PlanJobSaveReq;
import com.glen.autotest.req.common.PlanJobUpdateReq;
import com.glen.autotest.service.api.ApiCaseService;
import com.glen.autotest.service.common.PlanJobService;
import com.glen.autotest.service.stress.StressCaseService;
import com.glen.autotest.service.ui.UiCaseService;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.Instant;
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
public class PlanJobServiceImpl implements PlanJobService {

    @Resource
    private PlanJobMapper planJobMapper;

    @Resource
    private PlanJobLogMapper planJobLogMapper;

    @Resource
    private ThreadPoolTaskScheduler threadPoolTaskScheduler;


    @Resource
    private ApiCaseService apiCaseService;

    @Resource
    private UiCaseService uiCaseService;

    @Resource
    private StressCaseService stressCaseService;

    @Resource
    private TransactionTemplate transactionTemplate;

    @Override
    public int save(PlanJobSaveReq req) {
        PlanJobDO planJobDO = SpringBeanUtil.copyProperties(req, PlanJobDO.class);
        return planJobMapper.insert(planJobDO);
    }

    @Override
    public int update(PlanJobUpdateReq req) {
        PlanJobDO planJobDO = SpringBeanUtil.copyProperties(req, PlanJobDO.class);
        LambdaQueryWrapper<PlanJobDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(PlanJobDO::getId, req.getId()).eq(PlanJobDO::getProjectId, req.getProjectId());
        return planJobMapper.update(planJobDO, queryWrapper);
    }

    @Override
    public int del(PlanJobDelReq req) {
        LambdaQueryWrapper<PlanJobDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(PlanJobDO::getId, req.getId()).eq(PlanJobDO::getProjectId, req.getProjectId());
        return planJobMapper.delete(queryWrapper);
    }

    @Override
    public Map<String, Object> page(PlanJobPageReq req) {
        LambdaQueryWrapper<PlanJobDO> queryWrapper = new LambdaQueryWrapper<>();
        //组合条件
        if (req.getProjectId() != null) {
            queryWrapper.eq(PlanJobDO::getProjectId, req.getProjectId());
        }
        if (req.getName() != null) {
            queryWrapper.like(PlanJobDO::getName, req.getName());
        }
        queryWrapper.orderByDesc(PlanJobDO::getId);
        Page<PlanJobDO> page = new Page<>(req.getPage(), req.getSize());
        Page<PlanJobDO> planJobDOPage = planJobMapper.selectPage(page, queryWrapper);
        List<PlanJobDO> records = planJobDOPage.getRecords();
        List<PlanJobDTO> planJobDTOS = SpringBeanUtil.copyProperties(records, PlanJobDTO.class);
        Map<String, Object> pageMap = new HashMap<>(3);
        pageMap.put("total_record", planJobDOPage.getTotal());
        pageMap.put("total_page", planJobDOPage.getPages());
        pageMap.put("current_data", planJobDTOS);
        return pageMap;
    }

    @Override
    public List<PlanJobDTO> listAvailableJobs() {
        LambdaQueryWrapper<PlanJobDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(PlanJobDO::getIsDisabled, 0);
        List<PlanJobDO> planJobDOS = planJobMapper.selectList(queryWrapper);
        List<PlanJobDTO> planJobDTOS = SpringBeanUtil.copyProperties(planJobDOS, PlanJobDTO.class);
        return planJobDTOS;
    }

    @Override
    public void processJobs() {
        List<PlanJobDTO> planJobDTOS = listAvailableJobs();
        for (PlanJobDTO planJobDTO : planJobDTOS) {
            long currentTimeMillis = System.currentTimeMillis();
            long jobExecuteTimeMillis = DateUtil.parse(planJobDTO.getExecuteTime(), "yyyy-MM-dd HH:mm:ss").toInstant().toEpochMilli();
            long leftTimeMillis = jobExecuteTimeMillis - currentTimeMillis;
            if (leftTimeMillis > 0 && leftTimeMillis <= 60000) {
                log.info("计划任务开始执行：{}", planJobDTO);
                //去执行记录log表查询是否执行过
                LambdaQueryWrapper<PlanJobLogDO> queryWrapper = new LambdaQueryWrapper<>();
                queryWrapper.eq(PlanJobLogDO::getPlanJobId, planJobDTO.getId()).eq(PlanJobLogDO::getExecuteTime, planJobDTO.getExecuteTime());
                Long selectCount = planJobLogMapper.selectCount(queryWrapper);
                if (selectCount == 0) {
                    //放到本地定时调度任务里面
                    threadPoolTaskScheduler.schedule(getRunableTask(planJobDTO), Instant.ofEpochMilli(jobExecuteTimeMillis));
                }
            }
        }

    }


    private Runnable getRunableTask(PlanJobDTO planJobDTO) {
        return () -> {
            transactionTemplate.execute(status -> {
                log.info("计划任务开始执行：{}", planJobDTO);
                TestTypeEnum testTypeEnum = TestTypeEnum.valueOf(planJobDTO.getTestType());
                Long caseId = planJobDTO.getCaseId();
                Long projectId = planJobDTO.getProjectId();
                PlanJobLogDO planJobLogDO = PlanJobLogDO.builder().planJobName(planJobDTO.getName()).planJobId(planJobDTO.getId()).executeTime(planJobDTO.getExecuteTime()).build();
                int rows = planJobLogMapper.insert(planJobLogDO);
                if (rows == 1) {
                    switch (testTypeEnum) {
                        case UI:
                            uiCaseService.execute(projectId, caseId);
                            break;
                        case API:
                            apiCaseService.execute(projectId, caseId);
                            break;
                        case STRESS:
                            stressCaseService.execute(projectId, caseId);
                            break;
                        default:
                            throw new BizException(BizCodeEnum.TEST_TYPE_UNSUPPORTED);
                    }
                }
                return Boolean.TRUE;
            });
        };
    }

}
