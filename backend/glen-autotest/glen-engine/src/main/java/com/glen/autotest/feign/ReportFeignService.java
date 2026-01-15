package com.glen.autotest.feign;

import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.util.JsonData;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * 报告服务 Feign 客户端
 */
@FeignClient(name = "data-service", path = "/api/v1/report")
public interface ReportFeignService {
    
    @PostMapping("/save")
    JsonData save(@RequestBody ReportSaveReq req);
}
