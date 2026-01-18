package com.glen.autotest.mapper;

import com.glen.autotest.model.ProjectDO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Select;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author 小滴课堂-二当家小D,
 * @since 2023-12-22
 */
public interface ProjectMapper extends BaseMapper<ProjectDO> {

    /**
     * 根据账号ID获取账号用户名（跨库查询）
     * @param accountId 账号ID
     * @return 账号用户名
     */
    @Select("SELECT username FROM glen_account.account WHERE id = #{accountId}")
    String getAccountUsernameById(Long accountId);
}
