package com.glen.autotest.service.common;

import com.glen.autotest.dto.common.ProjectDTO;
import com.glen.autotest.req.common.ProjectSaveReq;
import com.glen.autotest.req.common.ProjectUpdateReq;

import java.util.List;

public interface ProjectService {

    /**
     * 获取用户的项目列表
     * @return
     */
    List<ProjectDTO> list();

    /**
     * 保存项目
     * @param projectSaveReq
     * @return
     */
    int save(ProjectSaveReq projectSaveReq);

    /**
     * 更新项目
     * @param projectUpdateReq
     * @return
     */
    int update(ProjectUpdateReq projectUpdateReq);

    /**
     * 删除项目
     * @param id
     * @return
     */
    int delete(Long id);
}
