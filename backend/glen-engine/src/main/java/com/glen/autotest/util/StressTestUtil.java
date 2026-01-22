package com.glen.autotest.util;

import lombok.extern.slf4j.Slf4j;
import org.apache.jmeter.engine.StandardJMeterEngine;
import org.apache.jmeter.util.JMeterUtils;

import java.io.File;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Slf4j
public class StressTestUtil {

    /**
     * 获取Jmeter的home路径，临时写法，后续部署上线会调整
     * @return JMeter安装目录路径
     */
    public static String getJmeterHome(){
        String osName = System.getProperty("os.name");
        try {
            if(osName.contains("Mac")){
                return "/Users/xdclass/Desktop/jmeter";
            }else {
                //生产环境 - 使用项目内的相对路径
                String projectDir = System.getProperty("user.dir");
                // user.dir 通常指向 backend/glen-engine
                String jmeterHome = projectDir + File.separator + "source" + File.separator + "apache-jmeter-5.5";
                
                // 验证路径是否存在
                File jmeterHomeFile = new File(jmeterHome);
                if (!jmeterHomeFile.exists() || !jmeterHomeFile.isDirectory()) {
                    log.error("JMeter路径不存在: {}", jmeterHome);
                    throw new RuntimeException("JMeter路径不存在: " + jmeterHome + 
                        "，请确保JMeter已正确部署在项目source目录下");
                }
                
                log.info("使用JMeter路径: {}", jmeterHome);
                return jmeterHome;
            }
        }catch (Exception e){
            log.error("获取JMeter路径失败: {}", e.getMessage(), e);
            throw new RuntimeException("获取JMeter路径失败: " + e.getMessage(), e);
        }
    }


    /**
     * 获取jmeter bin目录
     * @return
     */
    public static String getJmeterHomeBin(){
        return getJmeterHome() + File.separator + "bin";
    }


    /**
     * 初始化jmeter的配置文件
     */
    public static void initJmeterProperties(){
        try {
        String jmeterHome = getJmeterHome();
        String jmeterHomeBin = getJmeterHomeBin();
            String jmeterPropertiesPath = jmeterHomeBin + File.separator + "jmeter.properties";

            // 验证jmeter.properties文件是否存在
            File jmeterPropertiesFile = new File(jmeterPropertiesPath);
            if (!jmeterPropertiesFile.exists()) {
                log.error("JMeter配置文件不存在: {}", jmeterPropertiesPath);
                throw new RuntimeException("JMeter配置文件不存在: " + jmeterPropertiesPath);
            }

        //加载jmeter的配置文件
            JMeterUtils.loadJMeterProperties(jmeterPropertiesPath);

        //设置jmeter的安装目录
        JMeterUtils.setJMeterHome(jmeterHome);

        //避免中文响应乱码
        JMeterUtils.setProperty("sampleresult.default.encoding","UTF-8");

        //初始化本地环境
        JMeterUtils.initLocale();
            
            log.info("JMeter初始化成功，Home目录: {}", jmeterHome);
        } catch (Exception e) {
            log.error("初始化JMeter配置失败: {}", e.getMessage(), e);
            throw new RuntimeException("初始化JMeter配置失败: " + e.getMessage(), e);
        }
    }


    public static StandardJMeterEngine getJmeterEngine(){
        //初始化配置
        initJmeterProperties();
        StandardJMeterEngine jmeterEngine = new StandardJMeterEngine();
        return jmeterEngine;
    }

}
