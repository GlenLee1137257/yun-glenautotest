package com.glen.autotest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.glen.autotest.model.UiElementDO;
import org.apache.ibatis.annotations.Mapper;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素Mapper
 * @Author Glen Team
 * @Version 1.0
 **/
@Mapper
public interface UiElementMapper extends BaseMapper<UiElementDO> {
}
