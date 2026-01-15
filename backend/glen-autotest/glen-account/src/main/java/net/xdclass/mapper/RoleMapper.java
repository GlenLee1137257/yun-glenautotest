package com.glen.autotest.mapper;

import com.glen.autotest.dto.AccountDTO;
import com.glen.autotest.dto.RoleDTO;
import com.glen.autotest.model.RoleDO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author 小滴课堂-二当家小D,
 * @since 2024-03-18
 */
public interface RoleMapper extends BaseMapper<RoleDO> {

    List<RoleDTO> listRoleWithPermission();


    AccountDTO findAccountWithRoleAndPermission(@Param("accountId") Long accountId);
}
