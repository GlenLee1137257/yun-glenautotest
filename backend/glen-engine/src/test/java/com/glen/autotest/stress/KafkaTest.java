package com.glen.autotest.stress;

import jakarta.annotation.Resource;
import com.glen.autotest.config.KafkaTopicConfig;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.kafka.core.KafkaTemplate;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@SpringBootTest
public class KafkaTest {

    @Resource
    private KafkaTemplate<String,String> kafkaTemplate;


    @Test
    public void testSendMsg(){
        kafkaTemplate.send(KafkaTopicConfig.STRESS_TOPIC_NAME,"case_id_"+1,"test 6666 8888 xdclass");
    }

}

