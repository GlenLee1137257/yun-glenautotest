package com.glen.autotest.service.ui.core;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.*;
import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.mapper.UiCaseStepMapper;
import com.glen.autotest.mapper.UiElementMapper;
import com.glen.autotest.model.UiCaseStepDO;
import com.glen.autotest.model.UiElementDO;
import com.glen.autotest.service.common.FileService;
import com.glen.autotest.service.common.ResultSenderService;
import com.glen.autotest.service.ui.SeleniumDispatcherService;
import com.glen.autotest.util.*;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.springframework.mock.web.MockMultipartFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.nio.file.Files;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
@Slf4j
public class UiExecuteEngine {

    private ReportDTO reportDTO;

    private ResultSenderService resultSenderService;

    private SeleniumDispatcherService seleniumDispatcherService;


    private FileService fileService;

    public UiExecuteEngine(ReportDTO reportDTO){
        this.reportDTO = reportDTO;
        resultSenderService = SpringContextHolder.getBean(ResultSenderService.class);
        seleniumDispatcherService = SpringContextHolder.getBean(SeleniumDispatcherService.class);
        fileService = SpringContextHolder.getBean(FileService.class);
    }

    /**
     * 用例执行
     * @param caseInfoDTO
     * @param browser
     * @param stepList
     * @param headlessMode 无头模式 0-显示窗口 1-无头模式
     * @return
     */
    public UiCaseResultDTO execute(CaseInfoDTO caseInfoDTO, String browser, List<UiCaseStepDO> stepList, Integer headlessMode) {
        //获取浏览器驱动，并且配置上下文
        WebDriver webDriver = SeleniumFetchUtil.getWebDriver(browser, headlessMode);
        SeleniumWebdriverContext.set(webDriver);
        try {
            //获取步骤数量
            int quantity = stepList.size();
            //记录开始时间
            long startTime = System.currentTimeMillis();
            UiCaseResultDTO result = doExecute(null,stepList);
            long endTime = System.currentTimeMillis();

            result.setReportId(reportDTO.getId());
            result.setStartTime(startTime);
            result.setEndTime(endTime);
            result.setExpendTime(endTime - startTime);
            result.setQuantity(quantity);

            int passQuantity = result.getList().stream().filter(item -> {
                item.setReportId(reportDTO.getId());
                return item.getExecuteState() && item.getAssertionState();
            }).toList().size();
            result.setPassQuantity(passQuantity);
            result.setFailQuantity(quantity-passQuantity);
            result.setExecuteState(Objects.equals(result.getQuantity(),result.getPassQuantity()));

            //发送测试报告
            resultSenderService.sendResult(caseInfoDTO, TestTypeEnum.UI, JsonUtil.obj2Json(result));

            return result;
        }finally {
            try {
                if(webDriver!=null){
                    //方便本地测试查看，临时加个慢退出 TODO
                    TimeUnit.SECONDS.sleep(5);
                    webDriver.quit();
                }
            }catch (Exception e){
                log.error("关闭浏览器驱动失败",e);
            }
            SeleniumWebdriverContext.remove();
        }
    }

    private UiCaseResultDTO doExecute(UiCaseResultDTO result, List<UiCaseStepDO> stepList) {
        if(result == null){
            result = new UiCaseResultDTO();
            result.setList(new ArrayList<>());
        }
        //递归到这个为空的时候，就返回结果
        if (stepList == null || stepList.isEmpty()){
            return result;
        }
        UiCaseStepDO uiCaseStepDO = stepList.get(0);
        
        // 步骤复用功能：判断步骤类型
        // 如果是 REFER 类型，则根据 refer_step_id 查找被引用的步骤内容
        if(uiCaseStepDO.getStepType() != null && "REFER".equals(uiCaseStepDO.getStepType())){
            if(uiCaseStepDO.getReferStepId() == null){
                throw new IllegalArgumentException("引用步骤的referStepId不能为空");
            }
            
            // 循环引用检测：防止A引用B，B引用A的情况
            Set<Long> visitedStepIds = new HashSet<>();
            UiCaseStepMapper uiCaseStepMapper = SpringContextHolder.getBean(UiCaseStepMapper.class);
            UiCaseStepDO referStep = resolveReferStep(uiCaseStepMapper, uiCaseStepDO.getReferStepId(), visitedStepIds);
            
            // 保留原步骤的ID、num等信息，但使用被引用步骤的操作内容
            Long originalId = uiCaseStepDO.getId();
            Long originalNum = uiCaseStepDO.getNum();
            String originalName = uiCaseStepDO.getName();
            uiCaseStepDO = referStep;
            uiCaseStepDO.setId(originalId);
            uiCaseStepDO.setNum(originalNum);
            // 如果引用步骤有自定义名称，则使用自定义名称，否则使用被引用步骤的名称
            if(originalName != null && !originalName.isEmpty()){
                uiCaseStepDO.setName(originalName);
            }
        }
        
        // 元素库关联功能：如果步骤关联了元素库，则从元素库读取最新定位信息
        // 优先使用元素库，如果元素不存在或被删除，则降级使用步骤中保存的定位信息（备用方案）
        resolveElementLibrary(uiCaseStepDO);

        //用例步骤初始化
        UiCaseResultItemDTO resultItem = new UiCaseResultItemDTO();
        result.getList().add(resultItem);
        UiCaseStepDTO uiCaseStepDTO = SpringBeanUtil.copyProperties(uiCaseStepDO, UiCaseStepDTO.class);

        resultItem.setUiCaseStep(uiCaseStepDTO);
        resultItem.setAssertionState(true);
        resultItem.setExecuteState(true);

        try {
            long startTime = System.currentTimeMillis();
            //分发器，根据操作类型，分发到不同的类进行处理
            UiOperationResultDTO uiOperationResultDTO = seleniumDispatcherService.operationDispatcher(uiCaseStepDO);
            uiOperationResultDTO.setOperationType(uiCaseStepDO.getOperationType());
            long endTime = System.currentTimeMillis();

            //步骤需要截图
            if(uiCaseStepDO.getIsScreenshot()){
                resultItem.setScreenshotUrl(getScreenshot());
            }

            //配置当前步骤结束信息
            resultItem.setAssertionState(uiOperationResultDTO.getOperationState());
            if(!uiOperationResultDTO.getOperationState()){
                resultItem.setExceptionMsg("动作:"+uiOperationResultDTO.getOperationType()+",实际内容："+uiOperationResultDTO.getActualValue()+",期望内容："+uiOperationResultDTO.getExpectValue());
            }

            resultItem.setExpendTime(endTime-startTime);
            if(!uiOperationResultDTO.getOperationState() && !uiCaseStepDO.getIsContinue()){
                //操作失败后且不再继续
                return result;
            }
        }catch (Exception e){
            resultItem.setExecuteState(false);
            resultItem.setAssertionState(false);

            //记录异常
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            resultItem.setExceptionMsg(sw.toString());

            //步骤需要截图
            if(uiCaseStepDO.getIsScreenshot()){
                resultItem.setScreenshotUrl(getScreenshot());
            }
            if(!uiCaseStepDO.getIsContinue()){
                return result;
            }
        }
        stepList.remove(0);
        return doExecute(result,stepList);
    }


    private String getScreenshot(){
        WebDriver webDriver = SeleniumWebdriverContext.get();
        File file = ((TakesScreenshot) webDriver).getScreenshotAs(OutputType.FILE);
        try {

            MockMultipartFile multipartFile = new MockMultipartFile(file.getName(),file.getName(), Files.probeContentType(file.toPath()),new FileInputStream(file));
            return fileService.upload(multipartFile);
        }catch (Exception e){
            log.error("截图失败",e);
            throw new RuntimeException(e);
        }
    }

    /**
     * 递归解析引用步骤，并检测循环引用
     * @param uiCaseStepMapper 步骤Mapper
     * @param stepId 要解析的步骤ID
     * @param visitedStepIds 已访问的步骤ID集合（用于检测循环引用）
     * @return 解析后的步骤
     */
    private UiCaseStepDO resolveReferStep(UiCaseStepMapper uiCaseStepMapper, Long stepId, Set<Long> visitedStepIds){
        // 检测循环引用
        if(visitedStepIds.contains(stepId)){
            throw new IllegalArgumentException("检测到循环引用，步骤ID: " + stepId + "，引用链: " + visitedStepIds);
        }
        
        visitedStepIds.add(stepId);
        
        UiCaseStepDO step = uiCaseStepMapper.selectById(stepId);
        if(step == null){
            throw new IllegalArgumentException("引用的步骤不存在，stepId: " + stepId);
        }
        
        // 如果被引用的步骤本身也是引用类型，则继续解析
        if(step.getStepType() != null && "REFER".equals(step.getStepType())){
            if(step.getReferStepId() == null){
                throw new IllegalArgumentException("引用步骤的referStepId不能为空，stepId: " + stepId);
            }
            return resolveReferStep(uiCaseStepMapper, step.getReferStepId(), visitedStepIds);
        }
        
        return step;
    }

    /**
     * 从元素库获取最新定位信息（关联模式）
     * 优先使用元素库，如果元素不存在或被删除，则使用步骤中保存的定位信息作为降级方案
     * @param uiCaseStepDO 用例步骤
     */
    private void resolveElementLibrary(UiCaseStepDO uiCaseStepDO){
        UiElementMapper uiElementMapper = SpringContextHolder.getBean(UiElementMapper.class);
        
        // 处理主元素定位
        // 只有当 useElementLibrary 为 true 时，才从元素库读取定位信息
        if(Boolean.TRUE.equals(uiCaseStepDO.getUseElementLibrary()) && uiCaseStepDO.getElementId() != null){
            try {
                UiElementDO element = uiElementMapper.selectById(uiCaseStepDO.getElementId());
                if(element != null){
                    // 从元素库读取最新定位信息（一处更新，全局生效）
                    uiCaseStepDO.setLocationType(element.getLocationType());
                    uiCaseStepDO.setLocationExpress(element.getLocationExpress());
                    if(element.getElementWait() != null){
                        uiCaseStepDO.setElementWait(element.getElementWait());
                    }
                    log.info("从元素库加载主元素定位信息：elementId={}, locationType={}, locationExpress={}", 
                            element.getId(), element.getLocationType(), element.getLocationExpress());
                } else {
                    // 降级处理：元素已被删除，使用步骤中保存的定位信息
                    log.warn("元素库中元素不存在（可能已删除），使用步骤中保存的备用定位信息：elementId={}, locationType={}, locationExpress={}", 
                            uiCaseStepDO.getElementId(), uiCaseStepDO.getLocationType(), uiCaseStepDO.getLocationExpress());
                }
            } catch (Exception e){
                // 异常处理：查询失败，使用步骤中保存的定位信息
                log.error("从元素库加载元素失败，使用步骤中保存的备用定位信息：elementId={}", uiCaseStepDO.getElementId(), e);
            }
        } else if(uiCaseStepDO.getElementId() != null){
            // 有 elementId 但 useElementLibrary 为 false，使用手动输入的定位信息
            log.info("步骤未启用元素库模式，使用手动输入的定位信息：locationType={}, locationExpress={}", 
                    uiCaseStepDO.getLocationType(), uiCaseStepDO.getLocationExpress());
        }
        
        // 处理目标元素定位（拖拽等操作需要）
        // 只有当 useTargetElementLibrary 为 true 时，才从元素库读取定位信息
        if(Boolean.TRUE.equals(uiCaseStepDO.getUseTargetElementLibrary()) && uiCaseStepDO.getTargetElementId() != null){
            try {
                UiElementDO targetElement = uiElementMapper.selectById(uiCaseStepDO.getTargetElementId());
                if(targetElement != null){
                    // 从元素库读取最新定位信息
                    uiCaseStepDO.setTargetLocationType(targetElement.getLocationType());
                    uiCaseStepDO.setTargetLocationExpress(targetElement.getLocationExpress());
                    if(targetElement.getElementWait() != null){
                        uiCaseStepDO.setTargetElementWait(targetElement.getElementWait());
                    }
                    log.info("从元素库加载目标元素定位信息：elementId={}, locationType={}, locationExpress={}", 
                            targetElement.getId(), targetElement.getLocationType(), targetElement.getLocationExpress());
                } else {
                    // 降级处理：元素已被删除，使用步骤中保存的定位信息
                    log.warn("元素库中目标元素不存在（可能已删除），使用步骤中保存的备用定位信息：targetElementId={}, targetLocationType={}, targetLocationExpress={}", 
                            uiCaseStepDO.getTargetElementId(), uiCaseStepDO.getTargetLocationType(), uiCaseStepDO.getTargetLocationExpress());
                }
            } catch (Exception e){
                // 异常处理：查询失败，使用步骤中保存的定位信息
                log.error("从元素库加载目标元素失败，使用步骤中保存的备用定位信息：targetElementId={}", uiCaseStepDO.getTargetElementId(), e);
            }
        } else if(uiCaseStepDO.getTargetElementId() != null){
            // 有 targetElementId 但 useTargetElementLibrary 为 false，使用手动输入的定位信息
            log.info("步骤未启用目标元素库模式，使用手动输入的定位信息：targetLocationType={}, targetLocationExpress={}", 
                    uiCaseStepDO.getTargetLocationType(), uiCaseStepDO.getTargetLocationExpress());
        }
    }

}
