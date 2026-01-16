package com.glen.autotest.service.ui.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.UiCaseResultDTO;
import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.dto.dto.UiCaseDTO;
import com.glen.autotest.dto.UiCaseStepDTO;
import com.glen.autotest.enums.ReportStateEnum;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.feign.ReportFeignService;
import com.glen.autotest.mapper.UiCaseMapper;
import com.glen.autotest.mapper.UiCaseStepMapper;
import com.glen.autotest.model.UiCaseDO;
import com.glen.autotest.model.UiCaseStepDO;
import com.glen.autotest.req.ReportSaveReq;
import com.glen.autotest.req.ui.UiCaseDelReq;
import com.glen.autotest.req.ui.UiCaseSaveReq;
import com.glen.autotest.req.ui.UiCaseUpdateReq;
import com.glen.autotest.service.ui.UiCaseService;
import com.glen.autotest.service.ui.core.UiExecuteEngine;
import com.glen.autotest.util.JsonData;
import com.glen.autotest.util.SpringBeanUtil;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
 * @Version 1.0
 **/
@Service
@Slf4j
public class UiCaseServiceImpl implements UiCaseService {

    @Resource
    private UiCaseMapper uiCaseMapper;

    @Resource
    private UiCaseStepMapper uiCaseStepMapper;

    @Resource
    private ReportFeignService reportFeignService;


    @Override
    public UiCaseDTO find(Long projectId, Long caseId) {
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        queryWrapper.eq(UiCaseDO::getProjectId, projectId).eq(UiCaseDO::getId, caseId);
        UiCaseDO uiCaseDO = uiCaseMapper.selectOne(queryWrapper);

        UiCaseDTO uiCaseDTO = SpringBeanUtil.copyProperties(uiCaseDO, UiCaseDTO.class);

        List<UiCaseStepDO> stepList = getStepList(caseId);
        uiCaseDTO.setList(SpringBeanUtil.copyProperties(stepList, UiCaseStepDTO.class));
        return uiCaseDTO;
    }

    @Override
    public Integer delete(UiCaseDelReq req) {
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        queryWrapper.eq(UiCaseDO::getProjectId, req.getProjectId()).eq(UiCaseDO::getId, req.getId());
        int delete = uiCaseMapper.delete(queryWrapper);


        //删除用例下的步骤
        LambdaQueryWrapper<UiCaseStepDO> stepQueryWrapper = new LambdaQueryWrapper<>(UiCaseStepDO.class);
        stepQueryWrapper.eq(UiCaseStepDO::getCaseId, req.getId());
         uiCaseStepMapper.delete(stepQueryWrapper);

        return delete;

    }

    @Override
    public Integer update(UiCaseUpdateReq req) {
        UiCaseDO uiCaseDO = SpringBeanUtil.copyProperties(req, UiCaseDO.class);
        //更新用例
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        queryWrapper.eq(UiCaseDO::getId, req.getId()).eq(UiCaseDO::getProjectId, req.getProjectId());
        return uiCaseMapper.update(uiCaseDO, queryWrapper);
    }

    @Override
    public Integer save(UiCaseSaveReq req) {
        UiCaseDO uiCaseDO = SpringBeanUtil.copyProperties(req, UiCaseDO.class);
        int insert = uiCaseMapper.insert(uiCaseDO);
        if(req.getList()!=null){
             req.getList().forEach(uiCaseStepSaveReq -> {
                 UiCaseStepDO uiCaseStepDO = SpringBeanUtil.copyProperties(uiCaseStepSaveReq, UiCaseStepDO.class);
                 uiCaseStepDO.setCaseId(uiCaseDO.getId());
                 uiCaseStepMapper.insert(uiCaseStepDO);
             });
         }
        return insert;
    }

    /**
     * 查询用例->查询用例关联的步骤->初始化测试报告->执行自动化测试->响应结果
     * @param projectId
     * @param caseId
     * @return
     */
    @Override
    public JsonData execute(Long projectId, Long caseId) {
        //查找用例
        LambdaQueryWrapper<UiCaseDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseDO.class);
        queryWrapper.eq(UiCaseDO::getProjectId, projectId).eq(UiCaseDO::getId, caseId);
        UiCaseDO uiCaseDO = uiCaseMapper.selectOne(queryWrapper);

        if(uiCaseDO!=null){

            //查找用例关联的步骤
            List<UiCaseStepDO> stepList = getStepList(uiCaseDO.getId());
            if(stepList.isEmpty()){
                throw new IllegalArgumentException("用例步骤为空");
            }
            //初始化测试报告
            ReportSaveReq reportSaveReq = ReportSaveReq.builder().projectId(uiCaseDO.getProjectId())
                    .caseId(uiCaseDO.getId())
                    .startTime(System.currentTimeMillis())
                    .executeState(ReportStateEnum.EXECUTING.name())
                    .name(uiCaseDO.getName())
                    .type(TestTypeEnum.UI.name()).build();
            JsonData jsonData = reportFeignService.save(reportSaveReq);
            if(jsonData.isSuccess()){
                ReportDTO reportDTO = jsonData.getData(ReportDTO.class);
                CaseInfoDTO caseInfoDTO = new CaseInfoDTO();
                caseInfoDTO.setId(uiCaseDO.getId());
                caseInfoDTO.setModuleId(uiCaseDO.getModuleId());
                caseInfoDTO.setName(uiCaseDO.getName());

                UiExecuteEngine uiExecuteEngine = new UiExecuteEngine(reportDTO);
                UiCaseResultDTO uiCaseResultDTO = uiExecuteEngine.execute(caseInfoDTO,uiCaseDO.getBrowser(),stepList);

                return JsonData.buildSuccess(uiCaseResultDTO);
            }else {
                log.error("初始化测试报告失败，原因：{}",jsonData.getMsg());
                return JsonData.buildError("初始化测试报告失败");
            }

        }else {
            return JsonData.buildError("用例不存在");
        }



    }

    /**
     * 查询用例关联的步骤
     * @param uiCaseId
     * @return
     */

    private List<UiCaseStepDO> getStepList(Long uiCaseId){
        LambdaQueryWrapper<UiCaseStepDO> queryWrapper = new LambdaQueryWrapper<>(UiCaseStepDO.class);
        queryWrapper.eq(UiCaseStepDO::getCaseId, uiCaseId).orderByAsc(UiCaseStepDO::getNum);
        return uiCaseStepMapper.selectList(queryWrapper);

    }


}
