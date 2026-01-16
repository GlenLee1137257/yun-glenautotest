package com.glen.autotest.service.impl;

import jakarta.annotation.Resource;
import com.glen.autotest.mapper.RoleMapper;
import com.glen.autotest.service.RoleService;
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
public class RoleServiceImpl implements RoleService {

    @Resource
    private RoleMapper roleMapper;

    @Override
    public List<String> findRoleCodeList(Long accountId) {
        return roleMapper.findRoleCodeList(accountId);
    }
}
