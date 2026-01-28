package com.glen.autotest.req.stress;

import lombok.Data;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description 压测用例批量执行请求
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class StressCaseBatchExecuteReq {
    /**
     * 项目ID
     */
    private Long projectId;

    /**
     * 用例ID列表
     */
    private List<Long> caseIds;

    /**
     * 模块ID（按模块执行时使用）
     */
    private Long moduleId;
}
