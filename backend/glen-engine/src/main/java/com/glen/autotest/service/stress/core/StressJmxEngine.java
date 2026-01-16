package com.glen.autotest.service.stress.core;

import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.dto.ReportDTO;
import com.glen.autotest.dto.stress.CSVDataFileDTO;
import com.glen.autotest.exception.BizException;
import com.glen.autotest.model.StressCaseDO;
import com.glen.autotest.service.common.FileService;
import com.glen.autotest.service.common.ResultSenderService;
import com.glen.autotest.service.common.impl.KafkaSenderServiceImpl;
import com.glen.autotest.util.CustomFileUtil;
import com.glen.autotest.util.JsonUtil;
import org.apache.jmeter.JMeter;
import org.apache.jmeter.config.CSVDataSet;
import org.apache.jmeter.save.SaveService;
import org.apache.jmeter.testelement.TestElement;
import org.apache.jorphan.collections.HashTree;
import org.apache.jorphan.collections.SearchByClass;
import org.springframework.context.ApplicationContext;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Objects;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Slf4j
public class StressJmxEngine extends BaseStressEngine{

    public StressJmxEngine(StressCaseDO stressCaseDO, ReportDTO reportDTO, ApplicationContext applicationContext) {

        this.stressCaseDO = stressCaseDO;
        this.reportDTO = reportDTO;
        this.applicationContext = applicationContext;
    }

    @Override
    public void assembleTestPlan() {

        File jmxFile = null;
        HashTree testPlanTree = null;

        try {
            jmxFile =  File.createTempFile("jemter-script",".jmx");
            try (FileWriter fileWriter = new FileWriter(jmxFile)){
                //读取远程文件的内容，写到本地文件
                FileService fileService = applicationContext.getBean(FileService.class);
                String tempAccessFileUrl = fileService.getTempAccessFileUrl(stressCaseDO.getJmxUrl());
                String content = CustomFileUtil.readRemoteFile(tempAccessFileUrl);
                fileWriter.write(content);
            }
            // 加载测试计划树 jmx脚本
            testPlanTree = SaveService.loadTree(jmxFile);

            // 转换测试计划树
            JMeter.convertSubTree(testPlanTree, false);

            //获取自定义结果收集器
            ResultSenderService resultSenderService = applicationContext.getBean(KafkaSenderServiceImpl.class);
            EngineSampleCollector engineSampleCollector = super.getEngineSampleCollector(resultSenderService);
            testPlanTree.add(testPlanTree.getArray()[0],engineSampleCollector);

            //处理参数化相关的逻辑
            parseParamFilesToScript(testPlanTree);

        }catch (Exception e){
            log.error("异常信息{}",e.getMessage());
            throw new RuntimeException("组装测试计划失败");
        }finally {
            //删除临时文件
            if(jmxFile != null){
                boolean flag = jmxFile.delete();
                log.info("临时本地jmx文件路径：{}",jmxFile.getAbsolutePath());
                if(!flag){
                    log.error("删除临时文件失败");
                }
            }
        }
        super.setTestPlanHashTree(testPlanTree);
    }

    /**
     * 获取远程的参数文件
     * 解析relation字段映射到DTO
     * 对jmx脚本进行遍历
     * 提取元素是csvdataset对象到容器里面
     * 根据名称匹配对应的路径，修改fileName属性
     * @param testPlanTree
     */
    public void parseParamFilesToScript(HashTree testPlanTree) {

        FileService fileService = applicationContext.getBean(FileService.class);

        //获取映射字段
        String relation = stressCaseDO.getRelation();
        List<CSVDataFileDTO> csvDataFileDTOS = JsonUtil.json2List(relation, CSVDataFileDTO.class);

        //定义一个容器List，存储CSVDataSet
        List<CSVDataSet> csvDataSetList = new ArrayList<>();

        //jmx脚本进行遍历
        SearchByClass<TestElement> testElementVisitor = new SearchByClass<>(TestElement.class);
        testPlanTree.traverse(testElementVisitor);
        Collection<TestElement> searchResults = testElementVisitor.getSearchResults();

        //提取jmx脚本里面的csv配置类，存储到list
        for(TestElement testElement : searchResults){
            if(testElement instanceof CSVDataSet csvDataSet){
                boolean enabled = csvDataSet.getProperty("TestElement.enabled").getBooleanValue();
                if(enabled){
                    //存储CSVDataSet
                    csvDataSetList.add(csvDataSet);
                }
            }
        }

        //通过列表遍历jmx中的csv数据集，然后根据filename进行关联
        for(CSVDataSet csvDataSet : csvDataSetList){
            String csvDataSetSlotName = csvDataSet.getProperty("TestElement.name").getStringValue();
            if(csvDataFileDTOS!=null){
                for(CSVDataFileDTO csvDataFileDTO : csvDataFileDTOS){
                    if(Objects.equals(csvDataSetSlotName,csvDataFileDTO.getName())){
                        String localTempFile = fileService.copyRemoteFileToLocalTempFile(csvDataFileDTO.getRemoteFilePath());
                        csvDataSet.setProperty("filename",localTempFile);
                    }
                }
            }
        }

    }
}
