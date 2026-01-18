package com.glen.autotest.controller.ui;

import jakarta.annotation.Resource;
import com.glen.autotest.dto.dto.UiElementModuleDTO;
import com.glen.autotest.req.ui.UiElementModuleDelReq;
import com.glen.autotest.req.ui.UiElementModuleSaveReq;
import com.glen.autotest.req.ui.UiElementModuleUpdateReq;
import com.glen.autotest.service.ui.UiElementModuleService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description UI元素模块Controller
 * @Author Glen Team
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/ui_element_module")
public class UiElementModuleController {

    @Resource
    private UiElementModuleService uiElementModuleService;

    /**
     * 获取项目UI元素模块列表
     */
    @RequestMapping("/list")
    public JsonData list(@RequestParam("projectId") Long projectId) {
        List<UiElementModuleDTO> list = uiElementModuleService.list(projectId);
        return JsonData.buildSuccess(list);
    }

    /**
     * 获取UI元素模块详情
     */
    @RequestMapping("/find")
    public JsonData find(@RequestParam("projectId") Long projectId, @RequestParam("moduleId") Long moduleId) {
        UiElementModuleDTO uiElementModuleDTO = uiElementModuleService.getById(projectId, moduleId);
        return JsonData.buildSuccess(uiElementModuleDTO);
    }

    /**
     * 保存UI元素模块
     */
    @RequestMapping("/save")
    public JsonData save(@RequestBody UiElementModuleSaveReq req) {
        return JsonData.buildSuccess(uiElementModuleService.save(req));
    }

    /**
     * 更新UI元素模块
     */
    @RequestMapping("/update")
    public JsonData update(@RequestBody UiElementModuleUpdateReq req) {
        return JsonData.buildSuccess(uiElementModuleService.update(req));
    }

    /**
     * 删除UI元素模块
     */
    @RequestMapping("/del")
    public JsonData delete(@RequestBody UiElementModuleDelReq req) {
        return JsonData.buildSuccess(uiElementModuleService.delete(req.getProjectId(), req.getId()));
    }
}
