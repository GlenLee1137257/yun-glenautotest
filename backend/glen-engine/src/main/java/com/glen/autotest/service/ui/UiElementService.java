package com.glen.autotest.service.ui;

import com.glen.autotest.dto.dto.UiElementDTO;
import com.glen.autotest.req.ui.UiElementSaveReq;
import com.glen.autotest.req.ui.UiElementUpdateReq;
import com.glen.autotest.req.ui.UiElementDelReq;

import java.util.List;
import java.util.Map;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素Service接口
 * @Author Glen Team
 * @Version 1.0
 **/
public interface UiElementService {
    UiElementDTO find(Long projectId, Long id);

    Integer save(UiElementSaveReq req);

    Integer update(UiElementUpdateReq req);

    Integer delete(UiElementDelReq req);

    /**
     * 批量查询UI元素（用于前端显示元素库最新定位信息）
     * @param projectId 项目ID
     * @param elementIds 元素ID列表
     * @return Map<元素ID, 元素DTO>
     */
    Map<Long, UiElementDTO> findByIds(Long projectId, List<Long> elementIds);
}
