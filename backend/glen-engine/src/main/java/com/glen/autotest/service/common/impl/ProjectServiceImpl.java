package com.glen.autotest.service.common.impl;

import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.common.ProjectDTO;
import com.glen.autotest.mapper.ProjectMapper;
import com.glen.autotest.model.ProjectDO;
import com.glen.autotest.req.common.ProjectSaveReq;
import com.glen.autotest.req.common.ProjectUpdateReq;
import com.glen.autotest.service.common.ProjectService;
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
public class ProjectServiceImpl implements ProjectService {


    @Resource
    private ProjectMapper projectMapper;

    @Override
    public List<ProjectDTO> list() {
        List<ProjectDO> projectDOS = projectMapper.selectList(null);
        return SpringBeanUtil.copyProperties(projectDOS, ProjectDTO.class);
    }

    @Override
    public int save(ProjectSaveReq projectSaveReq) {
        ProjectDO projectDO = SpringBeanUtil.copyProperties(projectSaveReq, ProjectDO.class);
        return projectMapper.insert(projectDO);
    }

    @Override
    public int update(ProjectUpdateReq projectUpdateReq) {

        ProjectDO projectDO = SpringBeanUtil.copyProperties(projectUpdateReq, ProjectDO.class);
        return projectMapper.updateById(projectDO);
    }

    @Override
    public int delete(Long id) {
        return projectMapper.deleteById(id);
    }
}
