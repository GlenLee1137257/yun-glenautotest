package com.glen.autotest.service.common.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.common.SysDictDTO;
import com.glen.autotest.mapper.SysDictMapper;
import com.glen.autotest.model.SysDictDO;
import com.glen.autotest.service.common.SysDictService;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
public class SysDictServiceImpl implements SysDictService {

    @Resource
    private SysDictMapper sysDictMapper;


    @Override
    public Map<String, List<SysDictDTO>> listByCategory(String[] category) {
        Map<String, List<SysDictDTO>> map = new HashMap<>(category.length);

        for(String item: category){
            LambdaQueryWrapper<SysDictDO> queryWrapper = new LambdaQueryWrapper<>(SysDictDO.class);
            queryWrapper.eq(SysDictDO::getCategory, item);
            List<SysDictDO> sysDictDOList = sysDictMapper.selectList(queryWrapper);
            List<SysDictDTO> sysDictDTOList = SpringBeanUtil.copyProperties(sysDictDOList, SysDictDTO.class);
            map.put(item, sysDictDTOList);
        }
        return map;
    }
}
