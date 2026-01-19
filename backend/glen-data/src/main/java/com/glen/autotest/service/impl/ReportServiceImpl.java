package com.glen.autotest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.config.KafkaTopicConfig;
import com.glen.autotest.controller.req.ReportBatchDelReq;
import com.glen.autotest.controller.req.ReportDelReq;
import com.glen.autotest.controller.req.ReportExportReq;
import com.glen.autotest.controller.req.ReportPageReq;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.ReportExcelDTO;
import com.glen.autotest.enums.ReportStateEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.mapper.ReportDetailApiMapper;
import com.glen.autotest.mapper.ReportDetailStressMapper;
import com.glen.autotest.mapper.ReportDetailUiMapper;
import com.glen.autotest.mapper.ReportMapper;
import com.glen.autotest.model.ReportDO;
import com.glen.autotest.model.ReportDetailApiDO;
import com.glen.autotest.model.ReportDetailStressDO;
import com.glen.autotest.model.ReportDetailUiDO;
import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.req.ReportUpdateReq;
import com.glen.autotest.service.ReportService;
import com.glen.autotest.util.JsonUtil;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Service
@Slf4j
public class ReportServiceImpl implements ReportService {

    @Resource
    private ReportMapper reportMapper;

    @Resource
    private ReportDetailStressMapper reportDetailStressMapper;

    @Resource
    private ReportDetailUiMapper reportDetailUiMapper;

    @Resource
    private ReportDetailApiMapper reportDetailApiMapper;

    @Resource
    private KafkaTemplate<String,String> kafkaTemplate;

    @Override
    public ReportDTO save(ReportSaveReq req) {

        ReportDO reportDO = SpringBeanUtil.copyProperties(req, ReportDO.class);
        reportMapper.insert(reportDO);

        ReportDTO reportDTO = ReportDTO.builder().id(reportDO.getId())
                .projectId(reportDO.getProjectId())
                .name(reportDO.getName()).build();

        return reportDTO;
    }

    @Override
    public void updateReportState(ReportUpdateReq req) {

        ReportDTO reportDTO = ReportDTO.builder().id(req.getId()).executeState(req.getExecuteState()).endTime(req.getEndTime()).build();

        ReportDO reportDO = reportMapper.selectById(reportDTO.getId());
        //查找数据库测试报告明细
        LambdaQueryWrapper<ReportDetailStressDO> queryWrapper = new LambdaQueryWrapper<>(ReportDetailStressDO.class);
        queryWrapper.eq(ReportDetailStressDO::getReportId, reportDTO.getId());
        queryWrapper.orderByDesc(ReportDetailStressDO::getSamplerCount).last("limit 1");

        ReportDetailStressDO oldReportDetailStressDO = reportDetailStressMapper.selectOne(queryWrapper);
        try {
            TimeUnit.SECONDS.sleep(5);
        } catch (InterruptedException e) {
            log.error("超时等待错误");
            reportDO.setExecuteState(ReportStateEnum.EXECUTE_FAIL.name());
        }
        ReportDetailStressDO newReportDetailStressDO = reportDetailStressMapper.selectOne(queryWrapper);

        if(newReportDetailStressDO.getSamplerCount() > oldReportDetailStressDO.getSamplerCount()){
            //有新数据，则重新发送MQ消息
            reportDO.setExecuteState(ReportStateEnum.COUNTING_REPORT.name());
            kafkaTemplate.send(KafkaTopicConfig.REPORT_STATE_TOPIC_NAME,"report_id_"+reportDTO.getId(), JsonUtil.obj2Json(req));
        }else {
            //没更新，则处理完成测试报告
            reportDO.setExecuteState(ReportStateEnum.EXECUTE_SUCCESS.name());
        }
        //处理聚合统计信息
        reportDO.setEndTime(reportDTO.getEndTime());
        reportDO.setExpandTime(reportDTO.getEndTime()-reportDO.getStartTime());
        reportDO.setQuantity(newReportDetailStressDO.getSamplerCount());
        reportDO.setFailQuantity(newReportDetailStressDO.getErrorCount());
        reportDO.setPassQuantity(reportDO.getQuantity()-reportDO.getFailQuantity());

        Map<String,Object> summmaryMap = new HashMap<>();
        summmaryMap.put("QPS",newReportDetailStressDO.getRequestRate());
        summmaryMap.put("错误请求百分比",newReportDetailStressDO.getErrorPercentage());
        summmaryMap.put("平均响应时间(毫秒)",newReportDetailStressDO.getMeanTime());
        summmaryMap.put("最大响应时间(毫秒)",newReportDetailStressDO.getMaxTime());
        summmaryMap.put("最小响应时间(毫秒)",newReportDetailStressDO.getMinTime());

        reportDO.setSummary(JsonUtil.obj2Json(summmaryMap));

        //更新测试报告
        reportMapper.updateById(reportDO);
    }

    @Override
    public List<ReportExcelDTO> exportReport(ReportExportReq req) {
        LambdaQueryWrapper<ReportDO> queryWrapper = new LambdaQueryWrapper<>(ReportDO.class);
        //构建查询条件
        if (req.getProjectId() != null){
            queryWrapper.eq(ReportDO::getProjectId,req.getProjectId());
        }
        if (req.getCaseId() != null){
            queryWrapper.eq(ReportDO::getCaseId,req.getCaseId());
        }
        if (req.getType() != null){
            queryWrapper.eq(ReportDO::getType,req.getType());
        }
        if (req.getName() != null){
            queryWrapper.like(ReportDO::getName,req.getName());
        }
        // 时间范围查询：使用 gmt_create 字段（创建时间）进行查询
        // 前端传递的是字符串格式的日期时间，需要转换为 Date 对象
        if (req.getStartTime() != null && !req.getStartTime().trim().isEmpty()){
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date startDate = sdf.parse(req.getStartTime());
                queryWrapper.ge(ReportDO::getGmtCreate, startDate);
            } catch (ParseException e) {
                log.error("导出报告时解析开始时间失败：{}，错误：{}", req.getStartTime(), e.getMessage());
            }
        }
        if (req.getEndTime() != null && !req.getEndTime().trim().isEmpty()){
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date endDate = sdf.parse(req.getEndTime());
                queryWrapper.le(ReportDO::getGmtCreate, endDate);
            } catch (ParseException e) {
                log.error("导出报告时解析结束时间失败：{}，错误：{}", req.getEndTime(), e.getMessage());
            }
        }
        queryWrapper.orderByDesc(ReportDO::getId);
        List<ReportDO> reportDOS = reportMapper.selectList(queryWrapper);
        List<ReportExcelDTO> reportExcelDTOS = SpringBeanUtil.copyProperties(reportDOS, ReportExcelDTO.class);
        return reportExcelDTOS;
    }

    @Override
    public Map<String, Object> page(ReportPageReq req) {

        LambdaQueryWrapper<ReportDO> queryWrapper = new LambdaQueryWrapper<>(ReportDO.class);
        //构建查询条件
        if (req.getProjectId() != null){
            queryWrapper.eq(ReportDO::getProjectId,req.getProjectId());
        }
        if (req.getCaseId() != null){
            queryWrapper.eq(ReportDO::getCaseId,req.getCaseId());
        }
        if (req.getType() != null){
            queryWrapper.eq(ReportDO::getType,req.getType());
        }
        if (req.getName() != null){
            queryWrapper.like(ReportDO::getName,req.getName());
        }
        // 时间范围查询：使用 gmt_create 字段（创建时间）进行查询
        // 前端传递的是字符串格式的日期时间，需要转换为 Date 对象
        if (req.getStartTime() != null && !req.getStartTime().trim().isEmpty()){
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date startDate = sdf.parse(req.getStartTime());
                queryWrapper.ge(ReportDO::getGmtCreate, startDate);
            } catch (ParseException e) {
                log.error("解析开始时间失败：{}，错误：{}", req.getStartTime(), e.getMessage());
            }
        }
        if (req.getEndTime() != null && !req.getEndTime().trim().isEmpty()){
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date endDate = sdf.parse(req.getEndTime());
                // 结束时间需要包含当天的23:59:59，所以加一天再减1秒
                queryWrapper.le(ReportDO::getGmtCreate, endDate);
            } catch (ParseException e) {
                log.error("解析结束时间失败：{}，错误：{}", req.getEndTime(), e.getMessage());
            }
        }
        queryWrapper.orderByDesc(ReportDO::getId);
        Page<ReportDO> page = new Page<>(req.getPage(),req.getSize());
        Page<ReportDO> reportDOPage = reportMapper.selectPage(page, queryWrapper);
        //获取测试报告列表
        List<ReportDO> reportDOS = reportDOPage.getRecords();
        List<ReportDTO> reportDTOList = SpringBeanUtil.copyProperties(reportDOS, ReportDTO.class);
        Map<String,Object> pageMap = new HashMap<>(3);
        pageMap.put("total_record",reportDOPage.getTotal());
        pageMap.put("total_page",reportDOPage.getPages());
        pageMap.put("current_data",reportDTOList);

        return pageMap;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int delete(ReportDelReq req) {
        // 参数验证
        if (req == null) {
            log.error("删除报告失败：请求参数为空");
            throw new IllegalArgumentException("请求参数不能为空");
        }
        if (req.getId() == null) {
            log.error("删除报告失败：报告ID为空");
            throw new IllegalArgumentException("报告ID不能为空");
        }
        if (req.getProjectId() == null) {
            log.error("删除报告失败：项目ID为空");
            throw new IllegalArgumentException("项目ID不能为空");
        }
        if (req.getType() == null || req.getType().trim().isEmpty()) {
            log.error("删除报告失败：报告类型为空");
            throw new IllegalArgumentException("报告类型不能为空");
        }

        // 转换报告类型，支持大小写
        TestTypeEnum testTypeEnum;
        try {
            testTypeEnum = TestTypeEnum.valueOf(req.getType().toUpperCase());
        } catch (IllegalArgumentException e) {
            log.error("删除报告失败：不支持的报告类型 {}", req.getType());
            throw new IllegalArgumentException("不支持的报告类型：" + req.getType());
        }

        LambdaQueryWrapper<ReportDO> queryWrapper = new LambdaQueryWrapper<>(ReportDO.class);
        queryWrapper.eq(ReportDO::getProjectId, req.getProjectId());
        queryWrapper.eq(ReportDO::getId, req.getId());
        int delete = reportMapper.delete(queryWrapper);
        
        // 根据不同的类型删除明细表
        try {
            switch (testTypeEnum) {
                case STRESS:
                    reportDetailStressMapper.delete(new LambdaQueryWrapper<ReportDetailStressDO>().eq(ReportDetailStressDO::getReportId, req.getId()));
                    break;
                case API:
                    reportDetailApiMapper.delete(new LambdaQueryWrapper<ReportDetailApiDO>().eq(ReportDetailApiDO::getReportId, req.getId()));
                    break;
                case UI:
                    reportDetailUiMapper.delete(new LambdaQueryWrapper<ReportDetailUiDO>().eq(ReportDetailUiDO::getReportId, req.getId()));
                    break;
                default:
                    log.error("不支持的类型：{}", testTypeEnum);
                    break;
            }
        } catch (Exception e) {
            log.error("删除报告明细失败，报告ID：{}，类型：{}，错误：{}", req.getId(), req.getType(), e.getMessage(), e);
            throw e;
        }
        return delete;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int batchDelete(ReportBatchDelReq req) {
        // 参数验证
        if (req == null) {
            log.error("批量删除报告失败：请求参数为空");
            throw new IllegalArgumentException("请求参数不能为空");
        }
        if (req.getIds() == null || req.getIds().isEmpty()) {
            log.warn("批量删除失败：报告ID列表为空");
            return 0;
        }
        if (req.getProjectId() == null) {
            log.error("批量删除报告失败：项目ID为空");
            throw new IllegalArgumentException("项目ID不能为空");
        }
        if (req.getType() == null || req.getType().trim().isEmpty()) {
            log.error("批量删除报告失败：报告类型为空");
            throw new IllegalArgumentException("报告类型不能为空");
        }

        // 转换报告类型，支持大小写
        TestTypeEnum testTypeEnum;
        try {
            testTypeEnum = TestTypeEnum.valueOf(req.getType().toUpperCase());
        } catch (IllegalArgumentException e) {
            log.error("批量删除报告失败：不支持的报告类型 {}", req.getType());
            throw new IllegalArgumentException("不支持的报告类型：" + req.getType());
        }
        
        // 批量删除测试报告主表
        LambdaQueryWrapper<ReportDO> queryWrapper = new LambdaQueryWrapper<>(ReportDO.class);
        queryWrapper.eq(ReportDO::getProjectId, req.getProjectId());
        queryWrapper.in(ReportDO::getId, req.getIds());
        int deletedCount = reportMapper.delete(queryWrapper);
        
        // 根据不同的类型批量删除明细表
        try {
            switch (testTypeEnum) {
                case STRESS:
                    LambdaQueryWrapper<ReportDetailStressDO> stressWrapper = new LambdaQueryWrapper<>();
                    stressWrapper.in(ReportDetailStressDO::getReportId, req.getIds());
                    reportDetailStressMapper.delete(stressWrapper);
                    log.info("批量删除 STRESS 测试报告明细，报告数：{}", deletedCount);
                    break;
                case API:
                    LambdaQueryWrapper<ReportDetailApiDO> apiWrapper = new LambdaQueryWrapper<>();
                    apiWrapper.in(ReportDetailApiDO::getReportId, req.getIds());
                    reportDetailApiMapper.delete(apiWrapper);
                    log.info("批量删除 API 测试报告明细，报告数：{}", deletedCount);
                    break;
                case UI:
                    LambdaQueryWrapper<ReportDetailUiDO> uiWrapper = new LambdaQueryWrapper<>();
                    uiWrapper.in(ReportDetailUiDO::getReportId, req.getIds());
                    reportDetailUiMapper.delete(uiWrapper);
                    log.info("批量删除 UI 测试报告明细，报告数：{}", deletedCount);
                    break;
                default:
                    log.error("批量删除失败：不支持的测试类型 {}", req.getType());
                    break;
            }
        } catch (Exception e) {
            log.error("批量删除报告明细失败，报告IDs：{}，类型：{}，错误：{}", req.getIds(), req.getType(), e.getMessage(), e);
            throw e;
        }
        
        return deletedCount;
    }
}
