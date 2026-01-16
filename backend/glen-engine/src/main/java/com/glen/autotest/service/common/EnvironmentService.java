package com.glen.autotest.service.common;

import com.glen.autotest.dto.common.EnvironmentDTO;
import com.glen.autotest.req.common.EnvironmentSaveReq;
import com.glen.autotest.req.common.EnvironmentUpdateReq;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public interface EnvironmentService {

    List<EnvironmentDTO> list(Long projectId);

    int save(EnvironmentSaveReq req);

    int update(EnvironmentUpdateReq req);

    int delete(Long projectId, Long id);
}
