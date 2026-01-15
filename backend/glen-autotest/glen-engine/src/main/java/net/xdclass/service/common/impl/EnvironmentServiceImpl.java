package com.glen.autotest.service.common.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.common.EnvironmentDTO;
import com.glen.autotest.mapper.EnvironmentMapper;
import com.glen.autotest.mapper.ProjectMapper;
import com.glen.autotest.model.EnvironmentDO;
import com.glen.autotest.model.ProjectDO;
import com.glen.autotest.req.common.EnvironmentSaveReq;
import com.glen.autotest.req.common.EnvironmentUpdateReq;
import com.glen.autotest.service.common.EnvironmentService;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
 * @Version 1.0
 **/
@Service
@Slf4j
public class EnvironmentServiceImpl implements EnvironmentService {

    @Resource
    private ProjectMapper projectMapper;
    @Resource
    private EnvironmentMapper environmentMapper;

    @Override
    public List<EnvironmentDTO> list(Long projectId) {

        LambdaQueryWrapper<EnvironmentDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(EnvironmentDO::getProjectId,projectId);
        List<EnvironmentDO> environmentDOS = environmentMapper.selectList(queryWrapper);
        return SpringBeanUtil.copyProperties(environmentDOS,EnvironmentDTO.class);
    }

    @Override
    public int save(EnvironmentSaveReq req) {
        ProjectDO projectDO = projectMapper.selectById(req.getProjectId());
        if (projectDO !=null){
            EnvironmentDO environmentDO = SpringBeanUtil.copyProperties(req, EnvironmentDO.class);
            return environmentMapper.insert(environmentDO);
        }
        return 0;
    }

    @Override
    public int update(EnvironmentUpdateReq req) {
        ProjectDO projectDO = projectMapper.selectById(req.getProjectId());
        if (projectDO !=null){
            EnvironmentDO environmentDO = SpringBeanUtil.copyProperties(req, EnvironmentDO.class);
            return environmentMapper.updateById(environmentDO);
        }
        return 0;
    }

    @Override
    public int delete(Long projectId, Long id) {
        LambdaQueryWrapper<EnvironmentDO> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(EnvironmentDO::getProjectId,projectId);
        queryWrapper.eq(EnvironmentDO::getId,id);
        return environmentMapper.delete(queryWrapper);
    }
}
