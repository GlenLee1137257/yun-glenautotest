package com.glen.autotest.service.api;

import com.glen.autotest.dto.api.ApiDTO;
import com.glen.autotest.req.api.ApiDelReq;
import com.glen.autotest.req.api.ApiSaveReq;
import com.glen.autotest.req.api.ApiUpdateReq;

public interface ApiService {

    ApiDTO getById(Long projectId, Long id);

    int save(ApiSaveReq req);

    int update(ApiUpdateReq req);

    int delete(ApiDelReq req);
}
