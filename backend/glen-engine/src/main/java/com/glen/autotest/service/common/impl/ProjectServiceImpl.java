package com.glen.autotest.service.common.impl;

import cn.dev33.satoken.stp.StpUtil;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.common.ProjectDTO;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.mapper.ProjectMapper;
import com.glen.autotest.model.ProjectDO;
import com.glen.autotest.req.common.ProjectSaveReq;
import com.glen.autotest.req.common.ProjectUpdateReq;
import com.glen.autotest.service.common.ProjectService;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.List;
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
@Slf4j
public class ProjectServiceImpl implements ProjectService {


    @Resource
    private ProjectMapper projectMapper;

    @Override
    public List<ProjectDTO> list() {
        List<ProjectDO> projectDOS = projectMapper.selectList(null);
        List<ProjectDTO> projectDTOList = SpringBeanUtil.copyProperties(projectDOS, ProjectDTO.class);
        
        // 设置项目管理员名称
        for (ProjectDTO projectDTO : projectDTOList) {
            if (projectDTO.getProjectAdmin() != null) {
                String adminName = projectMapper.getAccountUsernameById(projectDTO.getProjectAdmin());
                projectDTO.setProjectAdminName(adminName);
            }
        }
        
        return projectDTOList;
    }

    @Override
    public int save(ProjectSaveReq projectSaveReq) {
        // 验证必填字段：名字和描述都必须填写
        if (projectSaveReq.getName() == null || projectSaveReq.getName().trim().isEmpty()) {
            throw new BizException(-1, "项目名称不能为空");
        }
        if (projectSaveReq.getDescription() == null || projectSaveReq.getDescription().trim().isEmpty()) {
            throw new BizException(-1, "项目描述不能为空");
        }
        
        ProjectDO projectDO = SpringBeanUtil.copyProperties(projectSaveReq, ProjectDO.class);
        
        // 设置项目管理员为当前登录用户
        try {
            Object loginId = StpUtil.getLoginId();
            if (loginId != null) {
                Long accountId = Long.parseLong(loginId.toString());
                projectDO.setProjectAdmin(accountId);
                log.info("设置项目管理员: accountId={}", accountId);
            } else {
                log.warn("未获取到登录用户ID，项目管理员将为空");
            }
        } catch (Exception e) {
            log.error("获取登录用户ID失败: {}", e.getMessage(), e);
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
