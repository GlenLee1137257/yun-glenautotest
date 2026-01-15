package com.glen.autotest.service.stress.core;

import com.glen.autotest.dto.KeyValueDTO;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.stress.CSVDataFileDTO;
import com.glen.autotest.dto.stress.StressAssertionDTO;
import com.glen.autotest.dto.stress.ThreadGroupConfigDTO;
import com.glen.autotest.enums.StressAssertActionEnum;
import com.glen.autotest.enums.StressAssertFieldFromEnum;
import com.glen.autotest.model.EnvironmentDO;
import com.glen.autotest.model.StressCaseDO;
import com.glen.autotest.service.common.FileService;
import com.glen.autotest.service.common.impl.KafkaSenderServiceImpl;
import com.glen.autotest.util.JsonUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.jmeter.assertions.ResponseAssertion;
import org.apache.jmeter.config.Arguments;
import org.apache.jmeter.config.CSVDataSet;
import org.apache.jmeter.config.gui.ArgumentsPanel;
import org.apache.jmeter.control.LoopController;
import org.apache.jmeter.control.gui.TestPlanGui;
import org.apache.jmeter.protocol.http.control.Header;
import org.apache.jmeter.protocol.http.control.HeaderManager;
import org.apache.jmeter.protocol.http.control.gui.HttpTestSampleGui;
import org.apache.jmeter.protocol.http.gui.HTTPArgumentsPanel;
import org.apache.jmeter.protocol.http.gui.HeaderPanel;
import org.apache.jmeter.protocol.http.sampler.HTTPSamplerProxy;
import org.apache.jmeter.protocol.http.util.HTTPArgument;
import org.apache.jmeter.testbeans.gui.TestBeanGUI;
import org.apache.jmeter.testelement.TestElement;
import org.apache.jmeter.testelement.TestPlan;
import org.apache.jmeter.testelement.property.StringProperty;
import org.apache.jmeter.threads.ThreadGroup;
import org.apache.jmeter.threads.gui.ThreadGroupGui;
import org.apache.jorphan.collections.HashTree;
import org.apache.jorphan.collections.ListedHashTree;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpMethod;

import java.util.ArrayList;
import java.util.List;

/**
 * 小滴课堂,愿景：让技术不再难学
 *
 * @Description
 * @Author 二当家小D
 * @Remark 有问题直接联系我，源码-笔记-技术交流群
 * @Version 1.0
 **/
public class StressSimpleEngine extends BaseStressEngine{

    private EnvironmentDO environmentDO;

    public StressSimpleEngine(EnvironmentDO environmentDO, StressCaseDO stressCaseDO, ReportDTO reportDTO, ApplicationContext applicationContext) {

        this.environmentDO = environmentDO;
        super.stressCaseDO = stressCaseDO;
        super.reportDTO = reportDTO;
        super.applicationContext = applicationContext;
    }

    @Override
    public void assembleTestPlan() {
        //获取压测结果收集器
        EngineSampleCollector engineSampleCollector = super.getEngineSampleCollector(applicationContext.getBean(KafkaSenderServiceImpl.class));

        //组装测试计划

        //创建hashTree
        ListedHashTree testHashTree = new ListedHashTree();

        //创建测试计划
        TestPlan testPlan = createTestPlan();

        //创建线程组
        ThreadGroup threadGroup = createTheadGroup();

        //请求头和参数等
        HeaderManager headerManager = createHeaderManager();

        //创建采样器
        HTTPSamplerProxy httpSamplerProxy = createHttpSamplerProxy();

        //创建断言列表
        List<ResponseAssertion> responseAssertionList = createResponseAssertionList();

        //创建参数化
        List<CSVDataSet> csvDataSetList = createCsvDataSetList();


        //组装到测试计划里面
        HashTree threadGroupHashTree = testHashTree.add(testPlan, threadGroup);

        //将http采样器添加到线程组下面
        threadGroupHashTree.add(httpSamplerProxy);

        //结果收集器添加到线程组下面
        threadGroupHashTree.add(engineSampleCollector);


        if(headerManager != null){
            threadGroupHashTree.add(headerManager);
        }
        if(responseAssertionList != null){
            threadGroupHashTree.add(responseAssertionList);
        }
        if(csvDataSetList != null){
            threadGroupHashTree.add(csvDataSetList);
        }

        super.setTestPlanHashTree(testHashTree);


    }

    private List<CSVDataSet> createCsvDataSetList() {

        if(StringUtils.isBlank(stressCaseDO.getRelation())){
            return null;
        }
        FileService fileService = applicationContext.getBean(FileService.class);

        List<CSVDataFileDTO> csvDataFileDTOS = JsonUtil.json2List(stressCaseDO.getRelation(), CSVDataFileDTO.class);

        //定义一个list，存储CSVDataSet
        List<CSVDataSet> csvDataSetList = new ArrayList<>(csvDataFileDTOS.size());

        //不能直接操作属性名称一样的Api,导致不生效，目前一个bug
        for(CSVDataFileDTO csvDataFileDTO : csvDataFileDTOS){

            CSVDataSet csvDataSet = new CSVDataSet();
            csvDataSet.setName(csvDataFileDTO.getName());
            csvDataSet.setProperty(TestElement.TEST_CLASS, CSVDataSet.class.getName());
            csvDataSet.setProperty(TestElement.GUI_CLASS, TestBeanGUI.class.getName());
            csvDataSet.setEnabled(true);

            csvDataSet.setProperty("delimiter", csvDataFileDTO.getDelimiter());
            csvDataSet.setProperty("quotedData", false);
            csvDataSet.setProperty("recycle", csvDataFileDTO.getRecycle());
            csvDataSet.setProperty("ignoreFirstLine", csvDataFileDTO.getIgnoreFirstLine());
            csvDataSet.setProperty("variableNames", csvDataFileDTO.getVariableNames());

            csvDataSet.setProperty("filename", fileService.copyRemoteFileToLocalTempFile(csvDataFileDTO.getRemoteFilePath()));
            csvDataSet.setProperty("fileEncoding", "UTF-8");
            csvDataSet.setProperty("stopThread", false);
            csvDataSet.setProperty("shareMode", "shareMode.all");
            csvDataSetList.add(csvDataSet);
        }

        return csvDataSetList;
    }

    private List<ResponseAssertion> createResponseAssertionList() {
        if(StringUtils.isBlank(stressCaseDO.getAssertion())){
            return null;
        }
        //将断言转成DTO
        List<StressAssertionDTO> stressAssertionDTOS = JsonUtil.json2List(stressCaseDO.getAssertion(), StressAssertionDTO.class);

        //创建list存储ResponseAssertion
        List<ResponseAssertion> responseAssertionList = new ArrayList<>(stressAssertionDTOS.size());

        for(StressAssertionDTO stressAssertionDTO : stressAssertionDTOS){
            //创建响应断言对象
            ResponseAssertion responseAssertion = new ResponseAssertion();
            responseAssertion.setName(stressAssertionDTO.getName());
            responseAssertion.setAssumeSuccess(false);
            //获取断言规则
            String action = stressAssertionDTO.getAction();
            StressAssertActionEnum stressAssertActionEnum = StressAssertActionEnum.valueOf(action);

            //匹配规则 包括，匹配
            switch (stressAssertActionEnum){
                case CONTAIN -> responseAssertion.setToContainsType();
                case EQUAL -> responseAssertion.setToEqualsType();
                default -> throw new RuntimeException("不支持的断言规则");
            }
            //断言字段类型来源，响应头，响应体
            StressAssertFieldFromEnum fieldFromEnum = StressAssertFieldFromEnum.valueOf(stressAssertionDTO.getFrom());
            switch (fieldFromEnum){
                case RESPONSE_CODE -> responseAssertion.setTestFieldResponseCode();
                case RESPONSE_HEADER -> responseAssertion.setTestFieldResponseHeaders();
                case RESPONSE_DATA -> responseAssertion.setTestFieldResponseData();
                default -> throw new RuntimeException("不支持的断言字段来源");
            }

            //增加用户期望的值
            responseAssertion.addTestString(stressAssertionDTO.getValue());
            responseAssertionList.add(responseAssertion);
        }

        return responseAssertionList;
    }

    private HTTPSamplerProxy createHttpSamplerProxy() {
        // 设置HTTP请求的名称、协议、域名、端口、路径和方法
        HTTPSamplerProxy httpSampler = new HTTPSamplerProxy();
        httpSampler.setProperty(TestElement.TEST_CLASS, HTTPSamplerProxy.class.getName());
        httpSampler.setProperty(TestElement.GUI_CLASS, HttpTestSampleGui.class.getName());
        httpSampler.setEnabled(true);

        httpSampler.setName(stressCaseDO.getName());
        httpSampler.setProtocol(environmentDO.getProtocol());
        httpSampler.setDomain(environmentDO.getDomain());
        httpSampler.setPort(environmentDO.getPort());
        //httpSampler.setPath("/api/v1/test/query"); 等同下面
        httpSampler.setProperty("HTTPSampler.path",stressCaseDO.getPath());
        httpSampler.setMethod(stressCaseDO.getMethod());

        httpSampler.setAutoRedirects(false);
        httpSampler.setUseKeepAlive(true);
        httpSampler.setFollowRedirects(true);
        httpSampler.setPostBodyRaw(true);

        //处理请求参数
        if(HttpMethod.GET.name().equals(stressCaseDO.getMethod()) && StringUtils.isNotBlank(stressCaseDO.getQuery())){
            List<KeyValueDTO> keyValueList = JsonUtil.json2List(stressCaseDO.getQuery(), KeyValueDTO.class);
            for(KeyValueDTO keyValueDTO : keyValueList){
                httpSampler.addArgument(keyValueDTO.getKey(),keyValueDTO.getValue());
            }
        }else {
            Arguments arguments = createArguments();
            httpSampler.setArguments(arguments);
        }
        return httpSampler;
    }

    private Arguments createArguments() {
        Arguments argumentManager = new Arguments();
        argumentManager.setProperty(TestElement.TEST_CLASS, Arguments.class.getName());
        argumentManager.setProperty(TestElement.GUI_CLASS, HTTPArgumentsPanel.class.getName());

        //类型，当前没用，后续可以根据content-type进行判断
        String bodyType = stressCaseDO.getBodyType();

        HTTPArgument httpArgument = new HTTPArgument();
        httpArgument.setValue(stressCaseDO.getBody());
        httpArgument.setAlwaysEncoded(false);
        argumentManager.addArgument(httpArgument);

        return argumentManager;
    }

    private HeaderManager createHeaderManager() {

        if(StringUtils.isBlank(stressCaseDO.getHeader())){
            return null;
        }
        List<KeyValueDTO> requestHeaders = JsonUtil.json2List(stressCaseDO.getHeader(), KeyValueDTO.class);
        HeaderManager headerManager = new HeaderManager();
        headerManager.setProperty(TestElement.TEST_CLASS, HeaderManager.class.getName());
        headerManager.setProperty(TestElement.GUI_CLASS, HeaderPanel.class.getName());
        headerManager.setEnabled(true);
        headerManager.setName(stressCaseDO.getName()+" headers ");
        requestHeaders.forEach(keyValueConfig->{
            headerManager.add(new Header(keyValueConfig.getKey(),keyValueConfig.getValue()));
        });
        return headerManager;
    }

    /**
     * 创建线程组
     * @return
     */
    private ThreadGroup createTheadGroup() {

        // 将线程组配置转换为DTO对象
        ThreadGroupConfigDTO configDTO = JsonUtil.json2Obj(stressCaseDO.getThreadGroupConfig(), ThreadGroupConfigDTO.class);
        ThreadGroup threadGroup = new ThreadGroup();
        threadGroup.setProperty(TestElement.TEST_CLASS, ThreadGroup.class.getName());
        threadGroup.setProperty(TestElement.GUI_CLASS, ThreadGroupGui.class.getName());

        // 设置线程组名称、线程数、梯度上升等属性
        threadGroup.setName(configDTO.getThreadGroupName());
        threadGroup.setNumThreads(configDTO.getNumThreads());
        threadGroup.setRampUp(configDTO.getRampUp());
        threadGroup.setIsSameUserOnNextIteration(true);
        threadGroup.setScheduler(false);
        threadGroup.setEnabled(true);
        threadGroup.setProperty(new StringProperty(ThreadGroup.ON_SAMPLE_ERROR, "continue"));

        // 判断调度器是否启用
        if(configDTO.getSchedulerEnabled()){
            threadGroup.setScheduler(true);
            threadGroup.setDuration(configDTO.getDuration());
            threadGroup.setDelay(configDTO.getDelay());
        }

        // 创建循环控制器
        LoopController loopController = createLoopController(configDTO.getLoopCount());
        threadGroup.setSamplerController(loopController);

        return threadGroup;
    }

    /**
     * 创建循环控制器
     * @param loopCount
     * @return
     */
    private LoopController createLoopController(Integer loopCount) {
        // 创建一个 LoopController 对象
        LoopController loopController = new LoopController();
        // 设置测试类的属性为 LoopController 类的名称
        loopController.setProperty(TestElement.TEST_CLASS, LoopController.class.getName());
        // 设置图形用户界面类的属性为 LoopController 类的名称
        loopController.setProperty(TestElement.GUI_CLASS, LoopController.class.getName());
        // 设置循环次数
        loopController.setLoops(loopCount);
        // 设置为第一次循环
        loopController.setFirst(true);
        // 启用 LoopController
        loopController.setEnabled(true);
        // 初始化 LoopController
        loopController.initialize();
        // 返回 LoopController 对象
        return loopController;
    }


    private TestPlan createTestPlan() {
        TestPlan testPlan = new TestPlan(stressCaseDO.getName());
        testPlan.setProperty(TestElement.TEST_CLASS, TestPlan.class.getName());
        testPlan.setProperty(TestElement.GUI_CLASS, TestPlanGui.class.getName());
        testPlan.setUserDefinedVariables((Arguments) new ArgumentsPanel().createTestElement());
        testPlan.setSerialized(true);
        testPlan.setTearDownOnShutdown(true);
        return testPlan;
    }
}
