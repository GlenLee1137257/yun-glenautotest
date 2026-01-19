package com.glen.autotest.service.api.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import com.glen.autotest.mapper.ApiCaseStepMapper;
import com.glen.autotest.model.ApiCaseStepDO;
import com.glen.autotest.req.api.ApiCaseStepSaveReq;
import com.glen.autotest.req.api.ApiCaseStepUpdateReq;
import com.glen.autotest.service.api.ApiCaseStepService;
import com.glen.autotest.util.SpringBeanUtil;
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
public class ApiCaseStepServiceImpl implements ApiCaseStepService {

    @Resource
    private ApiCaseStepMapper apiCaseStepMapper;

    @Override
    public int save(ApiCaseStepSaveReq req) {
        ApiCaseStepDO apiCaseStepDO = SpringBeanUtil.copyProperties(req, ApiCaseStepDO.class);
        return apiCaseStepMapper.insert(apiCaseStepDO);
    }

    @Override
    public int update(ApiCaseStepUpdateReq req) {
        ApiCaseStepDO apiCaseStepDO = SpringBeanUtil.copyProperties(req, ApiCaseStepDO.class);
        // 只使用 id 作为 WHERE 条件（id 是主键，已经唯一）
        // 不使用 project_id，因为旧数据中 project_id 可能为 null，导致匹配失败
        LambdaQueryWrapper<ApiCaseStepDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ApiCaseStepDO::getId, req.getId());
        return apiCaseStepMapper.update(apiCaseStepDO,queryWrapper);
    }

    @Override
    public int del(Long projectId, Long id) {
            LambdaQueryWrapper<ApiCaseStepDO> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(ApiCaseStepDO::getId, id).eq(ApiCaseStepDO::getProjectId,projectId);
            return apiCaseStepMapper.delete(queryWrapper);
    }
}
