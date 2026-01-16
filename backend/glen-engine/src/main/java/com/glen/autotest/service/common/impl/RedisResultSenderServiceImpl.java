package com.glen.autotest.service.common.impl;

import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.service.common.ResultSenderService;
import org.springframework.stereotype.Service;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
//@Service
public class RedisResultSenderServiceImpl implements ResultSenderService {
    @Override
    public void sendResult(CaseInfoDTO caseInfoDTO, TestTypeEnum testTypeEnum, String result) {

    }
}
