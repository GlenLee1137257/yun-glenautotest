package com.glen.autotest.controller.ui;

import jakarta.annotation.Resource;
import com.glen.autotest.dto.dto.UiCaseModuleDTO;
import com.glen.autotest.req.ui.UiCaseModuleDelReq;
import com.glen.autotest.req.ui.UiCaseModuleSaveReq;
import com.glen.autotest.req.ui.UiCaseModuleUpdateReq;
import com.glen.autotest.service.ui.UiCaseModuleService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/ui_case_module")
public class UiCaseModuleController {


    @Resource
    private UiCaseModuleService caseModuleService;

    /**
     * 获取项目模块列表
     * @param projectId 项目ID
     * @return JsonData 返回项目模块列表
     */
    @RequestMapping("/list")
    public JsonData list(@RequestParam("projectId") Long projectId)
    {
        List<UiCaseModuleDTO> list = caseModuleService.list(projectId);
        return JsonData.buildSuccess(list);
    }

    /**
     * 获取项目模块详情
     * @param projectId 项目ID
     * @param moduleId 模块ID
     * @return JsonData 返回项目模块详情
     */
    @RequestMapping("/find")
    public JsonData find(@RequestParam("projectId") Long projectId, @RequestParam("moduleId") Long moduleId)
    {
        UiCaseModuleDTO uiCaseModuleDTO =  caseModuleService.getById(projectId,moduleId);
        return JsonData.buildSuccess(uiCaseModuleDTO);
    }

    /**
     * 保存项目模块
     * @param req 项目模块保存请求对象
     * @return JsonData 返回保存结果
     */
    @RequestMapping("/save")
    public JsonData save(@RequestBody UiCaseModuleSaveReq req)
    {
        return JsonData.buildSuccess(caseModuleService.save(req));
    }

    /**
     * 更新项目模块
     * @param req 项目模块更新请求对象
     * @return JsonData 返回更新结果
     */
    @RequestMapping("/update")
    public JsonData update(@RequestBody UiCaseModuleUpdateReq req){
        return JsonData.buildSuccess(caseModuleService.update(req));
    }

    /**
     * 删除项目模块
     * @param req 项目模块删除请求对象
     * @return JsonData 返回删除结果
     */
    @RequestMapping("/del")
    public JsonData delete(@RequestBody UiCaseModuleDelReq req)
    {
        return JsonData.buildSuccess(caseModuleService.delete(req.getProjectId(),req.getId()));
    }

}



