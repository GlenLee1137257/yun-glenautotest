package com.glen.autotest.service.api.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import com.glen.autotest.dto.api.ApiDTO;
import com.glen.autotest.dto.api.ApiModuleDTO;
import com.glen.autotest.mapper.ApiMapper;
import com.glen.autotest.mapper.ApiModuleMapper;
import com.glen.autotest.model.ApiDO;
import com.glen.autotest.model.ApiModuleDO;
import com.glen.autotest.req.api.ApiModuleSaveReq;
import com.glen.autotest.req.api.ApiModuleUpdateReq;
import com.glen.autotest.service.api.ApiModuleService;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Service
public class ApiModuleServiceImpl implements ApiModuleService {

    @Resource
    private ApiModuleMapper apiModuleMapper;

    @Resource
    private ApiMapper apiMapper;


    /**
     * 根据项目ID获取ApiModuleDTO列表
     *
     * @param projectId 项目ID
     * @return ApiModuleDTO列表
     */
    @Override
    public List<ApiModuleDTO> list(Long projectId) {

        // 创建查询封装对象
        LambdaQueryWrapper<ApiModuleDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ApiModuleDO::getProjectId, projectId);

        // 查询ApiModuleDO列表
        List<ApiModuleDO> apiModuleDOS = apiModuleMapper.selectList(queryWrapper);

        // 将ApiModuleDO列表转换为ApiModuleDTO列表
        List<ApiModuleDTO> list = SpringBeanUtil.copyProperties(apiModuleDOS, ApiModuleDTO.class);

        // 遍历ApiModuleDTO列表
        list.forEach(apiModuleDTO -> {
            // 创建查询封装对象
            LambdaQueryWrapper<ApiDO> apiQueryWrapper = new LambdaQueryWrapper<>();
            apiQueryWrapper.eq(ApiDO::getModuleId, apiModuleDTO.getId()).orderByDesc(ApiDO::getId);

            // 查询ApiDO列表
            List<ApiDO> apiDOS = apiMapper.selectList(apiQueryWrapper);

            // 将ApiDO列表转换为ApiDTO列表，并设置给ApiModuleDTO的list属性
            apiModuleDTO.setList(SpringBeanUtil.copyProperties(apiDOS, ApiDTO.class));

        });

        // 返回ApiModuleDTO列表
        return list;
    }

    @Override
    public ApiModuleDTO getById(Long projectId, Long moduleId) {
        LambdaQueryWrapper<ApiModuleDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ApiModuleDO::getProjectId, projectId).eq(ApiModuleDO::getId, moduleId);

        ApiModuleDO apiModuleDO = apiModuleMapper.selectOne(queryWrapper);

        // 如果查询结果为空，返回 null
        if (apiModuleDO == null) {
            return null;
        }

        ApiModuleDTO apiModuleDTO = SpringBeanUtil.copyProperties(apiModuleDO, ApiModuleDTO.class);

        //查询模块下面对关联接口
        LambdaQueryWrapper<ApiDO> apiQueryWrapper = new LambdaQueryWrapper<>();
        apiQueryWrapper.eq(ApiDO::getModuleId, apiModuleDTO.getId()).orderByDesc(ApiDO::getId);
        List<ApiDO> apiDOS = apiMapper.selectList(apiQueryWrapper);
        apiModuleDTO.setList(SpringBeanUtil.copyProperties(apiDOS, ApiDTO.class));
        
        return apiModuleDTO;
    }

    /**
     * 根据projectId和moduleId删除用例模块
     *
     * @param id
     * @param projectId
     * @return
     */
    @Override
    public int delete(Long id, Long projectId) {

        LambdaQueryWrapper<ApiModuleDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ApiModuleDO::getProjectId, projectId).eq(ApiModuleDO::getId, id);
        int deleted = apiModuleMapper.delete(queryWrapper);
        if (deleted != 0) {
            //删除模块下面的api
            LambdaQueryWrapper<ApiDO> apiQueryWrapper = new LambdaQueryWrapper<>();
            apiQueryWrapper.eq(ApiDO::getModuleId, id).eq(ApiDO::getProjectId, projectId);
            apiMapper.delete(apiQueryWrapper);
        }
        return deleted;

    }

    /**
     * 保存模块对象
     *
     * @param req
     * @return
     */
    @Override
    public int save(ApiModuleSaveReq req) {

        ApiModuleDO apiModuleDO = SpringBeanUtil.copyProperties(req, ApiModuleDO.class);
        return apiModuleMapper.insert(apiModuleDO);

    }

    /**
     * 更新
     *
     * @param req
     * @return
     */
    @Override
    public int update(ApiModuleUpdateReq req) {
        ApiModuleDO apiModuleDO = SpringBeanUtil.copyProperties(req, ApiModuleDO.class);
        LambdaQueryWrapper<ApiModuleDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ApiModuleDO::getId, apiModuleDO.getId()).eq(ApiModuleDO::getProjectId, apiModuleDO.getProjectId());
        return apiModuleMapper.update(apiModuleDO, queryWrapper);
    }

}
