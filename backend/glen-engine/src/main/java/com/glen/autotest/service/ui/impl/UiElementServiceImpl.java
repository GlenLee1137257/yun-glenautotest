package com.glen.autotest.service.ui.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.dto.UiElementDTO;
import com.glen.autotest.mapper.UiElementMapper;
import com.glen.autotest.model.UiElementDO;
import com.glen.autotest.req.ui.UiElementDelReq;
import com.glen.autotest.req.ui.UiElementSaveReq;
import com.glen.autotest.req.ui.UiElementUpdateReq;
import com.glen.autotest.service.ui.UiElementService;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素Service实现
 * @Author Glen Team
 * @Version 1.0
 **/
@Service
@Slf4j
public class UiElementServiceImpl implements UiElementService {

    @Resource
    private UiElementMapper uiElementMapper;

    @Override
    public UiElementDTO find(Long projectId, Long id) {
        LambdaQueryWrapper<UiElementDO> queryWrapper = new LambdaQueryWrapper<>(UiElementDO.class);
        queryWrapper.eq(UiElementDO::getProjectId, projectId).eq(UiElementDO::getId, id);
        UiElementDO uiElementDO = uiElementMapper.selectOne(queryWrapper);
        
        // 如果查询结果为空，返回 null
        if (uiElementDO == null) {
            return null;
        }
        
        return SpringBeanUtil.copyProperties(uiElementDO, UiElementDTO.class);
    }

    @Override
    public Integer save(UiElementSaveReq req) {
        UiElementDO uiElementDO = SpringBeanUtil.copyProperties(req, UiElementDO.class);
        return uiElementMapper.insert(uiElementDO);
    }

    @Override
    public Integer update(UiElementUpdateReq req) {
        UiElementDO uiElementDO = SpringBeanUtil.copyProperties(req, UiElementDO.class);
        LambdaQueryWrapper<UiElementDO> queryWrapper = new LambdaQueryWrapper<>(UiElementDO.class);
        queryWrapper.eq(UiElementDO::getId, req.getId())
                    .eq(UiElementDO::getProjectId, req.getProjectId());
        return uiElementMapper.update(uiElementDO, queryWrapper);
    }

    @Override
    public Integer delete(UiElementDelReq req) {
        LambdaQueryWrapper<UiElementDO> queryWrapper = new LambdaQueryWrapper<>(UiElementDO.class);
        queryWrapper.eq(UiElementDO::getProjectId, req.getProjectId())
                    .eq(UiElementDO::getId, req.getId());
        return uiElementMapper.delete(queryWrapper);
    }

    @Override
    public Map<Long, UiElementDTO> findByIds(Long projectId, List<Long> elementIds) {
        if (elementIds == null || elementIds.isEmpty()) {
            return new HashMap<>();
        }
        
        // 查询元素列表
        LambdaQueryWrapper<UiElementDO> queryWrapper = new LambdaQueryWrapper<>(UiElementDO.class);
        queryWrapper.eq(UiElementDO::getProjectId, projectId)
                    .in(UiElementDO::getId, elementIds);
        List<UiElementDO> elements = uiElementMapper.selectList(queryWrapper);
        
        // 转换为 Map<元素ID, 元素DTO>
        return elements.stream()
                .map(element -> SpringBeanUtil.copyProperties(element, UiElementDTO.class))
                .collect(Collectors.toMap(UiElementDTO::getId, element -> element));
    }
}
