package com.glen.autotest.controller.api;

import jakarta.annotation.Resource;
import com.glen.autotest.req.api.ApiDelReq;
import com.glen.autotest.req.api.ApiSaveReq;
import com.glen.autotest.req.api.ApiUpdateReq;
import com.glen.autotest.service.api.ApiService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;
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
@RestController
@RequestMapping("/api/v1/api")
public class ApiController {

    @Resource
    private ApiService apiService;


    /**
     * 根据projectId和id查找
     */
    @GetMapping("/find")
    public JsonData find(@RequestParam("projectId") Long projectId, @RequestParam("id") Long id) {
        return JsonData.buildSuccess(apiService.getById(projectId, id));
    }

    /**
     * 保存接口
     */
    @PostMapping("/save")
    public JsonData save(@RequestBody ApiSaveReq req) {
        return JsonData.buildSuccess(apiService.save(req));
    }

    /**
     * 修改接口
     */
    @PostMapping("/update")
    public JsonData update(@RequestBody ApiUpdateReq req) {
        return JsonData.buildSuccess(apiService.update(req));
    }

    /**
     * 删除接口
     */
    @PostMapping("/del")
    public JsonData delete(@RequestBody ApiDelReq req) {
        return JsonData.buildSuccess(apiService.delete(req));
    }

    /**
     * 批量查询接口（用于接口库同步）
     * 参考 UiElementController 的 findByIds 实现
     * 前端的 beforeFetch 钩子会自动将 projectId 添加到 body 中
     */
    @PostMapping("/findByIds")
    public JsonData findByIds(@RequestBody Map<String, Object> requestBody) {
        Long projectId = Long.valueOf(requestBody.get("projectId").toString());
        
        // 从 Object 转换为 List，处理 JSON 反序列化时可能出现的 Integer/Long 类型问题
        @SuppressWarnings("unchecked")
        List<Object> rawIds = (List<Object>) requestBody.get("apiIds");
        List<Long> apiIds = new java.util.ArrayList<>();
        if (rawIds != null) {
            for (Object id : rawIds) {
                if (id instanceof Integer) {
                    apiIds.add(((Integer) id).longValue());
                } else if (id instanceof Long) {
                    apiIds.add((Long) id);
                } else {
                    apiIds.add(Long.valueOf(id.toString()));
                }
            }
        }
        
        return JsonData.buildSuccess(apiService.findByIds(projectId, apiIds));
    }
}
