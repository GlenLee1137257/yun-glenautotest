package com.glen.autotest.controller.ui;

import jakarta.annotation.Resource;
import com.glen.autotest.dto.dto.UiElementDTO;
import com.glen.autotest.req.ui.UiElementDelReq;
import com.glen.autotest.req.ui.UiElementSaveReq;
import com.glen.autotest.req.ui.UiElementUpdateReq;
import com.glen.autotest.service.ui.UiElementService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

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
    @PostMapping("/del")
    public JsonData delete(@RequestBody UiElementDelReq req) {
        return JsonData.buildSuccess(uiElementService.delete(req));
    }

    /**
     * 批量查询UI元素（用于前端显示元素库最新定位信息）
     * 注意：projectId 和 elementIds 都从 request body 中获取
     * 前端的 beforeFetch 钩子会自动将 projectId 添加到 body 中
     */
    @PostMapping("/findByIds")
    public JsonData findByIds(@RequestBody Map<String, Object> requestBody) {
        Long projectId = Long.valueOf(requestBody.get("projectId").toString());
        
        // 从 Object 转换为 List，处理 JSON 反序列化时可能出现的 Integer/Long 类型问题
        @SuppressWarnings("unchecked")
        List<Object> rawIds = (List<Object>) requestBody.get("elementIds");
        List<Long> elementIds = new java.util.ArrayList<>();
        if (rawIds != null) {
            for (Object id : rawIds) {
                if (id instanceof Integer) {
                    elementIds.add(((Integer) id).longValue());
                } else if (id instanceof Long) {
                    elementIds.add((Long) id);
                } else {
                    elementIds.add(Long.valueOf(id.toString()));
                }
            }
        }
        
        Map<Long, UiElementDTO> elements = uiElementService.findByIds(projectId, elementIds);
        return JsonData.buildSuccess(elements);
    }
}
