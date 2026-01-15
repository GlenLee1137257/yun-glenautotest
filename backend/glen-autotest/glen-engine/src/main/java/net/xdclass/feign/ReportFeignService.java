package com.glen.autotest.feign;

import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.req.ReportUpdateReq;
import com.glen.autotest.util.JsonData;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient("data-service")
public interface ReportFeignService {

    /**
     * 初始化测试报告接口
     */
    @PostMapping("/api/v1/report/save")
    JsonData save(@RequestBody ReportSaveReq req);



    /**
     * 更新测试报告接口
     */
    @PostMapping("/api/v1/report/update")
    void update(@RequestBody ReportUpdateReq req);

}
