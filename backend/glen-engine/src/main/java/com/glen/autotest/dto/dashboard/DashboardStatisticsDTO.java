package com.glen.autotest.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Glen AutoTest Platform
 *
 * @Description Dashboard统计数据DTO
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DashboardStatisticsDTO {
    
    /**
     * 接口用例数量
     */
    private Long apiCaseCount;
    
    /**
     * UI用例数量
     */
    private Long uiCaseCount;
    
    /**
     * 压测用例数量
     */
    private Long stressCaseCount;
    
    /**
     * 测试报告总数
     */
    private Long reportCount;
    
    /**
     * 项目数量
     */
    private Long projectCount;
    
    /**
     * 环境数量
     */
    private Long environmentCount;
    
    /**
     * 今日执行次数
     */
    private Long todayExecuteCount;
    
    /**
     * 成功率
     */
    private Double successRate;
}
