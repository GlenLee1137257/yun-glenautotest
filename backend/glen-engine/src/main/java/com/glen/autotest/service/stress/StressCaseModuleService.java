package com.glen.autotest.service.stress;

import com.glen.autotest.dto.stress.StressCaseModuleDTO;
import com.glen.autotest.req.stress.StressCaseModuleSaveReq;
import com.glen.autotest.req.stress.StressCaseModuleUpdateReq;

import java.util.List;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public interface StressCaseModuleService {

    List<StressCaseModuleDTO> list(Long projectId);

    StressCaseModuleDTO findById(Long projectId, Long moduleId);

    int delete(Long projectId, Long id);

    int save(StressCaseModuleSaveReq req);

    int update(StressCaseModuleUpdateReq req);
}
