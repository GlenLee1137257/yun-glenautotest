package com.glen.autotest.controller.common;

import jakarta.annotation.Resource;
import com.glen.autotest.dto.common.SysDictDTO;
import com.glen.autotest.service.common.SysDictService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
@RequestMapping("/api/v1/dict")
public class SysDictController {

    @Resource
    private SysDictService sysDictService;


    /**
     * 根据分类获取字典，支持传递多个，参数格式: xxx,aaa,bbb
     * @param category
     * @return
     */
    @GetMapping("list")
    public JsonData listByCategory(@RequestParam String [] category){

        Map<String, List<SysDictDTO>> stringListMap =  sysDictService.listByCategory(category);
        return JsonData.buildSuccess(stringListMap);
    }

}
