package com.glen.autotest.service.dashboard;

import com.glen.autotest.dto.dashboard.DashboardStatisticsDTO;
import com.glen.autotest.dto.dashboard.RecentExecutionDTO;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description Dashboard服务接口
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public interface DashboardService {
    
    /**
     * 获取统计数据
     * @param projectId 项目ID
     * @return 统计数据
     */
    DashboardStatisticsDTO getStatistics(Long projectId);
    
    /**
     * 获取最近执行记录
     * @param projectId 项目ID
     * @param limit 限制数量
     * @return 执行记录列表
     */
    List<RecentExecutionDTO> getRecentExecutions(Long projectId, Integer limit);
}
