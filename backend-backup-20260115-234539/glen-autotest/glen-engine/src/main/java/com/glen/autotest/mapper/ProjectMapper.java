package com.glen.autotest.mapper;

import com.glen.autotest.dto.common.ProjectDTO;
import com.glen.autotest.model.ProjectDO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Glen Lee
 * @since 2023-12-22
 */
public interface ProjectMapper extends BaseMapper<ProjectDO> {

    /**
     * 查询项目列表，包含项目管理员用户名
     * @return 项目列表
     */
    List<ProjectDTO> selectListWithAdminName();
}
