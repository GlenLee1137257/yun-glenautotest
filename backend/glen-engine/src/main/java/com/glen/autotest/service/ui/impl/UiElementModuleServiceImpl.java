package com.glen.autotest.service.ui.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.dto.UiElementDTO;
import com.glen.autotest.dto.dto.UiElementModuleDTO;
import com.glen.autotest.mapper.UiElementMapper;
import com.glen.autotest.mapper.UiElementModuleMapper;
import com.glen.autotest.model.UiElementDO;
import com.glen.autotest.model.UiElementModuleDO;
import com.glen.autotest.req.ui.UiElementModuleSaveReq;
import com.glen.autotest.req.ui.UiElementModuleUpdateReq;
import com.glen.autotest.service.ui.UiElementModuleService;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素模块Service实现
 * @Author Glen Team
 * @Version 1.0
 **/
@Service
@Slf4j
public class UiElementModuleServiceImpl implements UiElementModuleService {

    @Resource
    private UiElementModuleMapper uiElementModuleMapper;

    @Resource
    private UiElementMapper uiElementMapper;

    @Override
    public List<UiElementModuleDTO> list(Long projectId) {
        LambdaQueryWrapper<UiElementModuleDO> queryWrapper = new LambdaQueryWrapper<>(UiElementModuleDO.class);
        queryWrapper.eq(UiElementModuleDO::getProjectId, projectId);
        List<UiElementModuleDO> list = uiElementModuleMapper.selectList(queryWrapper);
        List<UiElementModuleDTO> uiElementModuleDTOS = SpringBeanUtil.copyProperties(list, UiElementModuleDTO.class);
        
        for (UiElementModuleDTO uiElementModuleDTO : uiElementModuleDTOS) {
            Long moduleId = uiElementModuleDTO.getId();
            LambdaQueryWrapper<UiElementDO> elementQueryWrapper = new LambdaQueryWrapper<>(UiElementDO.class);
            elementQueryWrapper.eq(UiElementDO::getModuleId, moduleId);
            List<UiElementDO> uiElementDOS = uiElementMapper.selectList(elementQueryWrapper);
            List<UiElementDTO> uiElementDTOS = SpringBeanUtil.copyProperties(uiElementDOS, UiElementDTO.class);
            uiElementModuleDTO.setList(uiElementDTOS);
        }
        return uiElementModuleDTOS;
    }

    @Override
    public UiElementModuleDTO getById(Long projectId, Long moduleId) {
        LambdaQueryWrapper<UiElementModuleDO> queryWrapper = new LambdaQueryWrapper<>(UiElementModuleDO.class);
        queryWrapper.eq(UiElementModuleDO::getProjectId, projectId).eq(UiElementModuleDO::getId, moduleId);
        UiElementModuleDO uiElementModuleDO = uiElementModuleMapper.selectOne(queryWrapper);
        
        if (uiElementModuleDO == null) {
            return null;
        }
        
        UiElementModuleDTO uiElementModuleDTO = SpringBeanUtil.copyProperties(uiElementModuleDO, UiElementModuleDTO.class);

        LambdaQueryWrapper<UiElementDO> elementQueryWrapper = new LambdaQueryWrapper<>(UiElementDO.class);
        elementQueryWrapper.eq(UiElementDO::getModuleId, moduleId);
        List<UiElementDO> uiElementDOS = uiElementMapper.selectList(elementQueryWrapper);
        List<UiElementDTO> uiElementDTOS = SpringBeanUtil.copyProperties(uiElementDOS, UiElementDTO.class);
        uiElementModuleDTO.setList(uiElementDTOS);

        return uiElementModuleDTO;
    }

    @Override
    public Integer save(UiElementModuleSaveReq req) {
        UiElementModuleDO uiElementModuleDO = SpringBeanUtil.copyProperties(req, UiElementModuleDO.class);
        return uiElementModuleMapper.insert(uiElementModuleDO);
    }

    @Override
    public Integer update(UiElementModuleUpdateReq req) {
        UiElementModuleDO uiElementModuleDO = SpringBeanUtil.copyProperties(req, UiElementModuleDO.class);
        LambdaQueryWrapper<UiElementModuleDO> queryWrapper = new LambdaQueryWrapper<>(UiElementModuleDO.class);
        queryWrapper.eq(UiElementModuleDO::getId, uiElementModuleDO.getId())
                    .eq(UiElementModuleDO::getProjectId, uiElementModuleDO.getProjectId());
        return uiElementModuleMapper.update(uiElementModuleDO, queryWrapper);
    }

    @Override
    public Integer delete(Long projectId, Long id) {
        LambdaQueryWrapper<UiElementModuleDO> queryWrapper = new LambdaQueryWrapper<>(UiElementModuleDO.class);
        queryWrapper.eq(UiElementModuleDO::getProjectId, projectId).eq(UiElementModuleDO::getId, id);
        
        // 删除模块
        int result = uiElementModuleMapper.delete(queryWrapper);
        
        // 删除模块下的所有元素
        LambdaQueryWrapper<UiElementDO> elementQueryWrapper = new LambdaQueryWrapper<>(UiElementDO.class);
        elementQueryWrapper.eq(UiElementDO::getModuleId, id);
        uiElementMapper.delete(elementQueryWrapper);
        
        return result;
    }
}
