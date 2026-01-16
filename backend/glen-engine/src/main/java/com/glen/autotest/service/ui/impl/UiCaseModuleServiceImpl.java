package com.glen.autotest.service.ui.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.dto.UiCaseDTO;
import com.glen.autotest.dto.dto.UiCaseModuleDTO;
import com.glen.autotest.mapper.UiCaseMapper;
import com.glen.autotest.mapper.UiCaseModuleMapper;
import com.glen.autotest.mapper.UiCaseStepMapper;
import com.glen.autotest.model.UiCaseDO;
import com.glen.autotest.model.UiCaseModuleDO;
import com.glen.autotest.model.UiCaseStepDO;
import com.glen.autotest.req.ui.UiCaseModuleSaveReq;
import com.glen.autotest.req.ui.UiCaseModuleUpdateReq;
import com.glen.autotest.service.ui.UiCaseModuleService;
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
@Slf4j
public class UiCaseModuleServiceImpl implements UiCaseModuleService {

    @Resource
    private UiCaseModuleMapper uiCaseModuleMapper;

    @Resource
    private UiCaseMapper uiCaseMapper;

    @Resource
    private UiCaseStepMapper uiCaseStepMapper;


    /**
     * 根据项目找出全部模块
     * @param projectId
     * @return
     */
    @Override
    public List<UiCaseModuleDTO> list(Long projectId) {
        LambdaQueryWrapper<UiCaseModuleDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseModuleDO.class);
        queryWrapper.eq(UiCaseModuleDO::getProjectId, projectId);
        List<UiCaseModuleDO> list = uiCaseModuleMapper.selectList(queryWrapper);
        List<UiCaseModuleDTO> uiCaseModuleDTOS = SpringBeanUtil.copyProperties(list, UiCaseModuleDTO.class);
        for (UiCaseModuleDTO uiCaseModuleDTO : uiCaseModuleDTOS) {
            Long moduleId = uiCaseModuleDTO.getId();
            LambdaQueryWrapper<UiCaseDO> caseQueryWapper = new LambdaQueryWrapper<>(UiCaseDO.class);
            caseQueryWapper.eq(UiCaseDO::getModuleId, moduleId);
            List<UiCaseDO> uiCaseDOS = uiCaseMapper.selectList(caseQueryWapper);
            List<UiCaseDTO> uiCaseDTOS = SpringBeanUtil.copyProperties(uiCaseDOS, UiCaseDTO.class);
            uiCaseModuleDTO.setList(uiCaseDTOS);
        }
        return uiCaseModuleDTOS;
    }

    @Override
    public UiCaseModuleDTO getById(Long projectId, Long moduleId) {
        LambdaQueryWrapper<UiCaseModuleDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseModuleDO.class);
        queryWrapper.eq(UiCaseModuleDO::getProjectId, projectId).eq(UiCaseModuleDO::getId, moduleId);
        UiCaseModuleDO uiCaseModuleDO = uiCaseModuleMapper.selectOne(queryWrapper);
        
        // 如果查询结果为空，返回 null
        if (uiCaseModuleDO == null) {
            return null;
        }
        
        UiCaseModuleDTO uiCaseModuleDTO = SpringBeanUtil.copyProperties(uiCaseModuleDO, UiCaseModuleDTO.class);

        LambdaQueryWrapper<UiCaseDO> caseQueryWapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        caseQueryWapper.eq(UiCaseDO::getModuleId, moduleId);
        List<UiCaseDO> uiCaseDOS = uiCaseMapper.selectList(caseQueryWapper);
        List<UiCaseDTO> uiCaseDTOS = SpringBeanUtil.copyProperties(uiCaseDOS, UiCaseDTO.class);
        uiCaseModuleDTO.setList(uiCaseDTOS);

        return uiCaseModuleDTO;
    }

    @Override
    public Integer save(UiCaseModuleSaveReq req) {
        UiCaseModuleDO uiCaseModuleDO = SpringBeanUtil.copyProperties(req, UiCaseModuleDO.class);
        return uiCaseModuleMapper.insert(uiCaseModuleDO);
    }

    @Override
    public Integer update(UiCaseModuleUpdateReq req) {
        UiCaseModuleDO uiCaseModuleDO = SpringBeanUtil.copyProperties(req, UiCaseModuleDO.class);
        LambdaQueryWrapper<UiCaseModuleDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseModuleDO.class);
        queryWrapper.eq(UiCaseModuleDO::getId, uiCaseModuleDO.getId()).eq(UiCaseModuleDO::getProjectId, uiCaseModuleDO.getProjectId());
        return uiCaseModuleMapper.update(uiCaseModuleDO, queryWrapper);
    }

    @Override
    public Integer delete(Long projectId, Long id) {

        //删除模块
        LambdaQueryWrapper<UiCaseModuleDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseModuleDO.class);
        queryWrapper.eq(UiCaseModuleDO::getProjectId, projectId).eq(UiCaseModuleDO::getId, id);
        int delete = uiCaseModuleMapper.delete(queryWrapper);
        //删除模块下的用例
        LambdaQueryWrapper<UiCaseDO> caseQueryWapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        caseQueryWapper.select(UiCaseDO::getId).eq(UiCaseDO::getModuleId, id);
        List<Long> caseIdList = uiCaseMapper.selectList(caseQueryWapper).stream().map(UiCaseDO::getId).toList();
        if(!caseIdList.isEmpty()){
            uiCaseMapper.deleteBatchIds(caseIdList);
        }

        //删除用例下的步骤
        LambdaQueryWrapper<UiCaseStepDO> stepQueryWapper = new LambdaQueryWrapper<>(UiCaseStepDO.class);
        stepQueryWapper.select(UiCaseStepDO::getId).in(UiCaseStepDO::getCaseId, caseIdList);
        List<Long> stepIdList = uiCaseStepMapper.selectList(stepQueryWapper).stream().map(UiCaseStepDO::getId).toList();
        if(!stepIdList.isEmpty()){
            uiCaseStepMapper.deleteBatchIds(stepIdList);
        }



        return delete;
    }
}
