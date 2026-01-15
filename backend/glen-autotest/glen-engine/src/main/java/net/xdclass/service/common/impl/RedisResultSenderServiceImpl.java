package com.glen.autotest.service.common.impl;

import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.service.common.ResultSenderService;
import org.springframework.stereotype.Service;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
 * @Version 1.0
 **/
//@Service
public class RedisResultSenderServiceImpl implements ResultSenderService {
    @Override
    public void sendResult(CaseInfoDTO caseInfoDTO, TestTypeEnum testTypeEnum, String result) {

    }
}
