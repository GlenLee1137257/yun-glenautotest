package com.glen.autotest.service.common;

import com.glen.autotest.dto.ReportDTO;

/**
 * 结果发送服务接口
 */
public interface ResultSenderService {
    void sendResult(ReportDTO reportDTO);
}
