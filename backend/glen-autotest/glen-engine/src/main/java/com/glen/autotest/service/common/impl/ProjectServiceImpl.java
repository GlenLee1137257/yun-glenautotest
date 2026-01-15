package com.glen.autotest.service.common.impl;

import cn.dev33.satoken.stp.StpUtil;
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
 * @Author Glen Lee
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
        // 使用自定义查询方法，包含项目管理员用户名
        return projectMapper.selectListWithAdminName();
    }

    @Override
    public int save(ProjectSaveReq projectSaveReq) {
        ProjectDO projectDO = SpringBeanUtil.copyProperties(projectSaveReq, ProjectDO.class);
        // 自动设置当前登录用户为项目管理员
        try {
            Long accountId = Long.parseLong(StpUtil.getLoginId().toString());
            projectDO.setProjectAdmin(accountId);
        } catch (Exception e) {
            log.warn("获取当前登录用户ID失败，项目管理员字段将为空", e);
        }
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
