package com.glen.autotest.service.common;

import com.glen.autotest.dto.common.SysDictDTO;

import java.util.List;
import java.util.Map;

public interface SysDictService {

    Map<String, List<SysDictDTO>> listByCategory(String[] category);
}
