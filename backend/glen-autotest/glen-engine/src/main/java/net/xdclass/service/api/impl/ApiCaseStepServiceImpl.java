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
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
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
        LambdaQueryWrapper<ApiCaseStepDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ApiCaseStepDO::getId, req.getId()).eq(ApiCaseStepDO::getProjectId,req.getProjectId());
        return apiCaseStepMapper.update(apiCaseStepDO,queryWrapper);
    }

    @Override
    public int del(Long projectId, Long id) {
            LambdaQueryWrapper<ApiCaseStepDO> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(ApiCaseStepDO::getId, id).eq(ApiCaseStepDO::getProjectId,projectId);
            return apiCaseStepMapper.delete(queryWrapper);
    }
}
