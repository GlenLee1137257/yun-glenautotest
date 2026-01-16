package com.glen.autotest.controller.api;

import jakarta.annotation.Resource;
import com.glen.autotest.req.api.ApiDelReq;
import com.glen.autotest.req.api.ApiSaveReq;
import com.glen.autotest.req.api.ApiUpdateReq;
import com.glen.autotest.service.api.ApiService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;

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
    @PostMapping("/delete")
    public JsonData delete(@RequestBody ApiDelReq req) {
        return JsonData.buildSuccess(apiService.delete(req));
    }
}
