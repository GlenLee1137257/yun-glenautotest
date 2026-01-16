package com.glen.autotest.config;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public class KafkaTopicConfig {

    /**
     * 压测
     */
    public static final String STRESS_TOPIC_NAME = "stress_report_topic1";

    /**
     * 接口自动化
     */
    public static final String API_TOPIC_NAME = "api_report_topic2";

    /**
     * ui自动化
     */
    public static final String UI_TOPIC_NAME = "ui_report_topic333";

    /**
     * 报告状态的topic
     */
    public static final String REPORT_STATE_TOPIC_NAME = "report_state_topic";
}
