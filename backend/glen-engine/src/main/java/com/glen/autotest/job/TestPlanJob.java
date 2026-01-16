package com.glen.autotest.job;

import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.service.common.PlanJobService;
import org.redisson.api.RLock;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.redisson.api.RedissonClient;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@EnableScheduling
@Configuration
@Slf4j
public class TestPlanJob {

    @Resource
    private PlanJobService planJobService;


    @Resource
    private RedissonClient redissonClient;

    private static final String LOCK_KEY_NAME = "plan_job:key";



    /**
     * 每分钟执行1次定时调度
     */
    @Scheduled(cron = "0 * * * * ?")
    public void start(){

        RLock lock = redissonClient.getLock(LOCK_KEY_NAME);
        try {
            lock.lock();
            planJobService.processJobs();
        }catch (Exception e){
            log.error("定时任务执行异常",e);
        }finally {
            lock.unlock();
        }

    }

}
