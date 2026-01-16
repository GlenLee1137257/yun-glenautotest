package com.glen.autotest.service.impl;

import jakarta.annotation.Resource;
import com.glen.autotest.mapper.PermissionMapper;
import com.glen.autotest.service.PermissionService;
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
public class PermissionServiceImpl implements PermissionService {

    @Resource
    private PermissionMapper permissionMapper;

    @Override
    public List<String> findPermissionCodeList(Long accountId) {

        return permissionMapper.findPermissionCodeList(accountId);
    }
}
