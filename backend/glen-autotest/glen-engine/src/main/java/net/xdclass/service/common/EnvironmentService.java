package com.glen.autotest.service.common;

import com.glen.autotest.dto.common.EnvironmentDTO;
import com.glen.autotest.req.common.EnvironmentSaveReq;
import com.glen.autotest.req.common.EnvironmentUpdateReq;

import java.util.List;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
 * @Version 1.0
 **/
public interface EnvironmentService {

    List<EnvironmentDTO> list(Long projectId);

    int save(EnvironmentSaveReq req);

    int update(EnvironmentUpdateReq req);

    int delete(Long projectId, Long id);
}
