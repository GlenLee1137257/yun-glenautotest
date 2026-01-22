package com.glen.autotest.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Glen AutoTest Platform
 *
 * @Description 最近执行记录DTO
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RecentExecutionDTO {
    
    /**
     * 报告ID
     */
    private Long id;
    
    /**
     * 用例名称
     */
    private String caseName;
    
    /**
     * 测试类型
     */
    private String type;
    
    /**
     * 执行状态
     */
    private String status;
    
    /**
     * 状态文本
     */
    private String statusText;
    
    /**
     * 执行时间
     */
    private String executeTime;
    
    /**
     * 耗时（秒）
     */
    private String duration;
}
