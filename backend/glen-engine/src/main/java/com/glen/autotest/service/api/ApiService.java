package com.glen.autotest.service.api;

import com.glen.autotest.dto.api.ApiDTO;
import com.glen.autotest.req.api.ApiDelReq;
import com.glen.autotest.req.api.ApiSaveReq;
import com.glen.autotest.req.api.ApiUpdateReq;
import java.util.List;
import java.util.Map;

public interface ApiService {

    ApiDTO getById(Long projectId, Long id);

    int save(ApiSaveReq req);

    int update(ApiUpdateReq req);

    int delete(ApiDelReq req);

    /**
     * 批量查询接口（用于接口库同步）
     * @param projectId 项目ID
     * @param apiIds 接口ID列表
     * @return 接口ID -> 接口DTO 的映射
     */
    Map<Long, ApiDTO> findByIds(Long projectId, List<Long> apiIds);
}
