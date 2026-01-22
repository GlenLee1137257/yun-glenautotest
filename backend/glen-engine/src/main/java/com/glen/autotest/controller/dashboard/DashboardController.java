package com.glen.autotest.controller.dashboard;

import com.glen.autotest.dto.dashboard.DashboardStatisticsDTO;
import com.glen.autotest.dto.dashboard.RecentExecutionDTO;
import com.glen.autotest.service.dashboard.DashboardService;
import com.glen.autotest.util.JsonData;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description Dashboard控制器
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/dashboard")
public class DashboardController {
    
    @Resource
    private DashboardService dashboardService;
    
    /**
     * 获取统计数据
     * @param projectId 项目ID
     * @return 统计数据
     */
    @GetMapping("/statistics")
    public JsonData getStatistics(@RequestParam(required = false) Long projectId) {
        DashboardStatisticsDTO statistics = dashboardService.getStatistics(projectId);
        return JsonData.buildSuccess(statistics);
    }
    
    /**
     * 获取最近执行记录
     * @param projectId 项目ID
     * @param limit 限制数量，默认5条
     * @return 执行记录列表
     */
    @GetMapping("/recent-executions")
    public JsonData getRecentExecutions(
            @RequestParam(required = false) Long projectId,
            @RequestParam(defaultValue = "5") Integer limit) {
        List<RecentExecutionDTO> executions = dashboardService.getRecentExecutions(projectId, limit);
        return JsonData.buildSuccess(executions);
    }
}
