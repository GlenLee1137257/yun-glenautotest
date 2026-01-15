package com.glen.autotest.service.stress;

import com.glen.autotest.dto.stress.StressCaseDTO;
import com.glen.autotest.req.stress.StressCaseSaveReq;
import com.glen.autotest.req.stress.StressCaseUpdateReq;

public interface StressCaseService {
    StressCaseDTO findById(Long projectId, Long caseId);

    int delete(Long projectId, Long id);

    int save(StressCaseSaveReq req);

    int update(StressCaseUpdateReq req);

    void execute(Long projectId, Long caseId);
}
