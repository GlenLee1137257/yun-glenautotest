package com.glen.autotest.service.common;

import com.glen.autotest.dto.common.PlanJobDTO;
import com.glen.autotest.req.common.PlanJobDelReq;
import com.glen.autotest.req.common.PlanJobPageReq;
import com.glen.autotest.req.common.PlanJobSaveReq;
import com.glen.autotest.req.common.PlanJobUpdateReq;

import java.util.List;
import java.util.Map;

public interface PlanJobService {
    int save(PlanJobSaveReq req);

    int update(PlanJobUpdateReq req);

    int del(PlanJobDelReq req);

    Map<String, Object> page(PlanJobPageReq req);

    List<PlanJobDTO> listAvailableJobs();

    void processJobs();

}
