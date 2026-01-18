package com.glen.autotest.service.ui;

import com.glen.autotest.dto.dto.UiElementDTO;
import com.glen.autotest.req.ui.UiElementSaveReq;
import com.glen.autotest.req.ui.UiElementUpdateReq;
import com.glen.autotest.req.ui.UiElementDelReq;

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
}
