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
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
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

    @Override
    public Map<Long, ApiDTO> findByIds(Long projectId, List<Long> apiIds) {
        if (apiIds == null || apiIds.isEmpty()) {
            return Map.of();
        }

        LambdaQueryWrapper<ApiDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ApiDO::getProjectId, projectId)
                   .in(ApiDO::getId, apiIds);
        
        List<ApiDO> apiDOList = apiMapper.selectList(queryWrapper);
        
        // 转换为 Map<Long, ApiDTO>
        return apiDOList.stream()
                .map(apiDO -> SpringBeanUtil.copyProperties(apiDO, ApiDTO.class))
                .collect(Collectors.toMap(ApiDTO::getId, api -> api));
    }
}
