package com.glen.autotest.config;

import io.minio.BucketExistsArgs;
import io.minio.MakeBucketArgs;
import io.minio.MinioClient;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Slf4j
@Data
@Component
@ConfigurationProperties(prefix = "minio")
public class MinIoConfig {
    private String endpoint;
    private String accessKey;
    private String secretKey;
    private String bucketName;

    @Bean
    public MinioClient minioClient(){
        // 解析endpoint，移除协议前缀（如果有）
        String cleanEndpoint = endpoint;
        if (cleanEndpoint.startsWith("http://")) {
            cleanEndpoint = cleanEndpoint.substring(7);
        } else if (cleanEndpoint.startsWith("https://")) {
            cleanEndpoint = cleanEndpoint.substring(8);
        }
        
        // 提取主机和端口
        String host = cleanEndpoint.split(":")[0];
        int port = cleanEndpoint.contains(":") ? 
            Integer.parseInt(cleanEndpoint.split(":")[1]) : 9000;
        
        return MinioClient.builder()
                .endpoint(host, port, false) // false表示不使用HTTPS
                .credentials(accessKey, secretKey)
                .build();
    }

    /**
     * 初始化时自动创建bucket（如果不存在）
     */
    @PostConstruct
    public void initBucket() {
        try {
            MinioClient client = minioClient();
            
            // 检查bucket是否存在
            boolean exists = client.bucketExists(
                BucketExistsArgs.builder()
                    .bucket(bucketName)
                    .build()
            );
            
            if (!exists) {
                // 创建bucket
                client.makeBucket(
                    MakeBucketArgs.builder()
                        .bucket(bucketName)
                        .build()
                );
                log.info("MinIO bucket '{}' 已自动创建", bucketName);
            } else {
                log.info("MinIO bucket '{}' 已存在", bucketName);
            }
        } catch (Exception e) {
            log.error("初始化 MinIO bucket 失败", e);
            // 不抛出异常，避免应用启动失败
        }
    }
}
