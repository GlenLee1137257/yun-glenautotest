package com.glen.autotest.controller.ui;

import jakarta.annotation.Resource;
import com.glen.autotest.dto.dto.UiElementDTO;
import com.glen.autotest.req.ui.UiElementDelReq;
import com.glen.autotest.req.ui.UiElementSaveReq;
import com.glen.autotest.req.ui.UiElementUpdateReq;
import com.glen.autotest.service.ui.UiElementService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素Controller
 * @Author Glen Team
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/ui_element")
public class UiElementController {

    @Resource
    private UiElementService uiElementService;

    /**
     * 根据id查找UI元素
     */
    @GetMapping("/find")
    public JsonData find(@RequestParam("projectId") Long projectId, @RequestParam("id") Long id) {
        UiElementDTO uiElementDTO = uiElementService.find(projectId, id);
        return JsonData.buildSuccess(uiElementDTO);
    }

    /**
     * 保存UI元素
     */
    @PostMapping("/save")
    public JsonData save(@RequestBody UiElementSaveReq req) {
        return JsonData.buildSuccess(uiElementService.save(req));
    }

    /**
     * 更新UI元素
     */
    @PostMapping("/update")
    public JsonData update(@RequestBody UiElementUpdateReq req) {
        return JsonData.buildSuccess(uiElementService.update(req));
    }

    /**
     * 删除UI元素
     */
    @PostMapping("/delete")
    public JsonData delete(@RequestBody UiElementDelReq req) {
        return JsonData.buildSuccess(uiElementService.delete(req));
    }
}
