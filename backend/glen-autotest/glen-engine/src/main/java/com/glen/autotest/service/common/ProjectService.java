package com.glen.autotest.service.common;

import com.glen.autotest.dto.common.ProjectDTO;
import com.glen.autotest.req.common.ProjectSaveReq;
import com.glen.autotest.req.common.ProjectUpdateReq;

import java.util.List;

/**
 * 项目服务接口
 */
public interface ProjectService {
    List<ProjectDTO> list();
    int save(ProjectSaveReq projectSaveReq);
    int update(ProjectUpdateReq projectUpdateReq);
    int delete(Long id);
}
