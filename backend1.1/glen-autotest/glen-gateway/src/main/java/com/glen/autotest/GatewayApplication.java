package com.glen.autotest;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Lee
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@SpringBootApplication
@MapperScan("com.glen.autotest.mapper")
@EnableDiscoveryClient
public class GatewayApplication {
    public static void main(String[] args) {

         SpringApplication.run(GatewayApplication.class, args);
    }
}
