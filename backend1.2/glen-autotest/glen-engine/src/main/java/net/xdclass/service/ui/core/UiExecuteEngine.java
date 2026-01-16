package com.glen.autotest.service.ui.core;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.*;
import com.glen.autotest.dto.common.CaseInfoDTO;
import com.glen.autotest.enums.TestTypeEnum;
import com.glen.autotest.mapper.UiCaseStepMapper;
import com.glen.autotest.model.UiCaseStepDO;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
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
     * @return
     */
    public UiCaseResultDTO execute(CaseInfoDTO caseInfoDTO, String browser, List<UiCaseStepDO> stepList) {
        //获取浏览器驱动，并且配置上下文
        WebDriver webDriver = SeleniumFetchUtil.getWebDriver(browser);
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
        //TODO 加餐拓展
        // 判断 step_type 类型，
        // 如果是local则照常进行；
        // 如果是refer类型，则根据refer_step_id查找步骤表其他内容，进行执行
//        if(uiCaseStepDO.getStepType().equals("REFER")){
//            UiCaseStepMapper uiCaseStepMapper = SpringContextHolder.getBean(UiCaseStepMapper.class);
//            uiCaseStepDO = uiCaseStepMapper.selectById(uiCaseStepDO.getReferStepId());
//        }

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
                resultItem.setExceptionMsg("动作:"+uiOperationResultDTO.getOperationType()+",实际内容："+uiOperationResultDTO.getActualValue()+",期望内容："+uiOperationResultDTO.getActualValue());
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



}
