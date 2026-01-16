package com.glen.autotest.service.common;

import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.enums.TestTypeEnum;

public interface ResultSenderService {

    /**
     * 发送测试结果
     * @param caseInfoDTO 用例信息
     * @param testTypeEnum 测试类型
     * @param result 测试结果
     */
    void sendResult(CaseInfoDTO caseInfoDTO, TestTypeEnum testTypeEnum, String result);
}
