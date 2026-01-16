package com.glen.autotest.service.ui.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.mapper.UiCaseStepMapper;
import com.glen.autotest.model.UiCaseStepDO;
import com.glen.autotest.req.ui.UiCaseStepDelReq;
import com.glen.autotest.req.ui.UiCaseStepSaveReq;
import com.glen.autotest.req.ui.UiCaseStepUpdateReq;
import com.glen.autotest.service.ui.UiCaseStepService;
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
@Slf4j
public class UiCaseStepServiceImpl implements UiCaseStepService {

    @Resource
    private UiCaseStepMapper uiCaseStepMapper;


    @Override
    public Integer save(UiCaseStepSaveReq req) {
        UiCaseStepDO uiCaseStepDO = SpringBeanUtil.copyProperties(req, UiCaseStepDO.class);
        return uiCaseStepMapper.insert(uiCaseStepDO);
    }

    @Override
    public Integer update(UiCaseStepUpdateReq req) {
        UiCaseStepDO uiCaseStepDO = SpringBeanUtil.copyProperties(req, UiCaseStepDO.class);
        LambdaQueryWrapper<UiCaseStepDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseStepDO.class);
        queryWrapper.eq(UiCaseStepDO::getId, uiCaseStepDO.getId()).eq(UiCaseStepDO::getProjectId, req.getProjectId());
        return uiCaseStepMapper.update(uiCaseStepDO, queryWrapper);
    }

    @Override
    public Integer delete(UiCaseStepDelReq req) {
        LambdaQueryWrapper<UiCaseStepDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseStepDO.class);
        queryWrapper.eq(UiCaseStepDO::getId, req.getId()).eq(UiCaseStepDO::getProjectId, req.getProjectId());
        return uiCaseStepMapper.delete(queryWrapper);
    }
}
