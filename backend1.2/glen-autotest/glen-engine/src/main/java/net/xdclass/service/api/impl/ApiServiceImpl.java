package com.glen.autotest.service.api.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import com.glen.autotest.dto.api.ApiDTO;
import com.glen.autotest.mapper.ApiMapper;
import com.glen.autotest.model.ApiDO;
import com.glen.autotest.req.api.ApiDelReq;
import com.glen.autotest.req.api.ApiSaveReq;
import com.glen.autotest.req.api.ApiUpdateReq;
import com.glen.autotest.service.api.ApiService;
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
public class ApiServiceImpl implements ApiService {

    @Resource
    private ApiMapper apiMapper;

    @Override
    public ApiDTO getById(Long projectId, Long id) {
        //根据projectId和id查找api对象
        LambdaQueryWrapper<ApiDO> queryWrapper = new LambdaQueryWrapper<ApiDO>();
        queryWrapper.eq(ApiDO::getProjectId, projectId).eq(ApiDO::getId, id);
        ApiDO apiDO = apiMapper.selectOne(queryWrapper);
        // 如果查询结果为空，返回 null
        if (apiDO == null) {
            return null;
        }
        return SpringBeanUtil.copyProperties(apiDO, ApiDTO.class);
    }

    @Override
    public int save(ApiSaveReq req) {
        ApiDO apiDO = SpringBeanUtil.copyProperties(req, ApiDO.class);
        return apiMapper.insert(apiDO);
    }

    @Override
    public int update(ApiUpdateReq req) {
        ApiDO apiDO = SpringBeanUtil.copyProperties(req, ApiDO.class);
        LambdaQueryWrapper<ApiDO> queryWrapper = new LambdaQueryWrapper<ApiDO>();
        queryWrapper.eq(ApiDO::getProjectId, apiDO.getProjectId()).eq(ApiDO::getId, apiDO.getId());
        return apiMapper.update(apiDO,queryWrapper);
    }

    @Override
    public int delete(ApiDelReq req) {

        LambdaQueryWrapper<ApiDO> queryWrapper = new LambdaQueryWrapper<ApiDO>();
        queryWrapper.eq(ApiDO::getProjectId, req.getProjectId()).eq(ApiDO::getId, req.getId());
        return apiMapper.delete(queryWrapper);
    }
}
