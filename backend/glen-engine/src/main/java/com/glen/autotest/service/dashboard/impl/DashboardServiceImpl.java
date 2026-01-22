package com.glen.autotest.service.dashboard.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.glen.autotest.dto.dashboard.DashboardStatisticsDTO;
import com.glen.autotest.dto.dashboard.RecentExecutionDTO;
import com.glen.autotest.mapper.*;
import com.glen.autotest.model.*;
import com.glen.autotest.service.dashboard.DashboardService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description Dashboard服务实现类
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Slf4j
@Service
public class DashboardServiceImpl implements DashboardService {
    
    @Resource
    private ApiCaseMapper apiCaseMapper;
    
    @Resource
    private UiCaseMapper uiCaseMapper;
    
    @Resource
    private StressCaseMapper stressCaseMapper;
    
    @Resource
    private ProjectMapper projectMapper;
    
    @Resource
    private EnvironmentMapper environmentMapper;
    
    @Override
    public DashboardStatisticsDTO getStatistics(Long projectId) {
        try {
            // 查询接口用例数量
            LambdaQueryWrapper<ApiCaseDO> apiQuery = new LambdaQueryWrapper<>();
            if (projectId != null) {
                apiQuery.eq(ApiCaseDO::getProjectId, projectId);
            }
            Long apiCaseCount = apiCaseMapper.selectCount(apiQuery);
            
            // 查询UI用例数量
            LambdaQueryWrapper<UiCaseDO> uiQuery = new LambdaQueryWrapper<>();
            if (projectId != null) {
                uiQuery.eq(UiCaseDO::getProjectId, projectId);
            }
            Long uiCaseCount = uiCaseMapper.selectCount(uiQuery);
            
            // 查询压测用例数量
            LambdaQueryWrapper<StressCaseDO> stressQuery = new LambdaQueryWrapper<>();
            if (projectId != null) {
                stressQuery.eq(StressCaseDO::getProjectId, projectId);
            }
            Long stressCaseCount = stressCaseMapper.selectCount(stressQuery);
            
            // 查询项目数量
            Long projectCount = projectMapper.selectCount(null);
            
            // 查询环境数量
            Long environmentCount = environmentMapper.selectCount(null);
            
            // 计算今日执行次数和成功率（这里使用模拟数据，实际需要从report表查询）
            Long todayExecuteCount = 0L;
            Double successRate = 0.0;
            
            // TODO: 从report表查询今日执行次数和成功率
            // 这里先使用简单的模拟计算
            Long totalCases = apiCaseCount + uiCaseCount + stressCaseCount;
            if (totalCases > 0) {
                // 模拟今日执行次数为总用例的20%
                todayExecuteCount = Math.round(totalCases * 0.2);
                // 模拟成功率
                successRate = 92.5 + Math.random() * 5;
            }
            
            return DashboardStatisticsDTO.builder()
                    .apiCaseCount(apiCaseCount)
                    .uiCaseCount(uiCaseCount)
                    .stressCaseCount(stressCaseCount)
                    .reportCount(0L) // TODO: 从glen-data服务查询
                    .projectCount(projectCount)
                    .environmentCount(environmentCount)
                    .todayExecuteCount(todayExecuteCount)
                    .successRate(successRate)
                    .build();
                    
        } catch (Exception e) {
            log.error("获取统计数据失败: {}", e.getMessage(), e);
            // 返回空数据
            return DashboardStatisticsDTO.builder()
                    .apiCaseCount(0L)
                    .uiCaseCount(0L)
                    .stressCaseCount(0L)
                    .reportCount(0L)
                    .projectCount(0L)
                    .environmentCount(0L)
                    .todayExecuteCount(0L)
                    .successRate(0.0)
                    .build();
        }
    }
    
    @Override
    public List<RecentExecutionDTO> getRecentExecutions(Long projectId, Integer limit) {
        // 这里返回模拟数据，实际应该从report表查询
        List<RecentExecutionDTO> executions = new ArrayList<>();
        
        // TODO: 从glen-data服务的report表查询最近执行记录
        // 这里先返回空列表或模拟数据
        
        return executions;
    }
    
    /**
     * 格式化时间
     */
    private String formatTime(Date date) {
        if (date == null) {
            return "";
        }
        LocalDateTime dateTime = date.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime();
        LocalDateTime now = LocalDateTime.now();
        
        long minutesDiff = java.time.Duration.between(dateTime, now).toMinutes();
        if (minutesDiff < 60) {
            return minutesDiff + "分钟前";
        }
        
        long hoursDiff = minutesDiff / 60;
        if (hoursDiff < 24) {
            return hoursDiff + "小时前";
        }
        
        long daysDiff = hoursDiff / 24;
        return daysDiff + "天前";
    }
}
