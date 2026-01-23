package com.glen.autotest.service.common.impl;

import cn.hutool.core.util.IdUtil;
import io.minio.GetPresignedObjectUrlArgs;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.StatObjectArgs;
import io.minio.StatObjectResponse;
import io.minio.http.Method;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.glen.autotest.config.MinIoConfig;
import com.glen.autotest.service.common.FileService;
import com.glen.autotest.util.CustomFileUtil;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.concurrent.TimeUnit;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Service
@Slf4j
public class FileServiceImpl implements FileService {

    @Resource
    private MinIoConfig minIoConfig;

    @Resource
    private MinioClient minioClient;

    /**
     * 获取文件名称
     * 生成随机名称
     * 文件上传
     * 拼接路径返回
     *
     * @param file
     * @return
     */
    @Override
    public String upload(MultipartFile file) {

        String filename = CustomFileUtil.getFilename(file.getOriginalFilename());

        //上传 TODO 异步上传，改成线程池上传
        new Thread(() -> {
            upload(file, filename);
        }).start();

        String url = minIoConfig.getEndpoint() + "/" + minIoConfig.getBucketName() + "/" + filename;

        return url;
    }

    @Override
    public String getTempAccessFileUrl(String remoteFilePath) {
        try {
            if (remoteFilePath == null || remoteFilePath.isEmpty()) {
                log.error("获取临时文件访问链接失败：文件路径为空");
                throw new RuntimeException("文件路径为空");
            }
            
            // 从完整URL中提取文件名
            String filename;
            if (remoteFilePath.contains("/")) {
                filename = remoteFilePath.substring(remoteFilePath.lastIndexOf("/") + 1);
            } else {
                filename = remoteFilePath;
            }
            
            // 如果文件名包含查询参数，需要移除
            if (filename.contains("?")) {
                filename = filename.substring(0, filename.indexOf("?"));
            }
            
            if (filename == null || filename.isEmpty()) {
                log.error("获取临时文件访问链接失败：无法从路径中提取文件名，路径：{}", remoteFilePath);
                throw new RuntimeException("无法从路径中提取文件名");
            }
            
            log.info("获取临时文件访问链接：bucket={}, filename={}, endpoint={}", 
                    minIoConfig.getBucketName(), filename, minIoConfig.getEndpoint());
            
            // 先检查文件是否存在
            try {
                StatObjectResponse stat = minioClient.statObject(
                    StatObjectArgs.builder()
                        .bucket(minIoConfig.getBucketName())
                        .object(filename)
                        .build()
                );
                log.info("文件存在，大小：{} bytes, 最后修改时间：{}", stat.size(), stat.lastModified());
            } catch (Exception e) {
                // 先检查是否是认证错误（优先级最高）
                String errorMsg = e.getMessage();
                if (errorMsg != null) {
                    if (errorMsg.contains("Access Key") || errorMsg.contains("InvalidAccessKeyId") || 
                        errorMsg.contains("SignatureDoesNotMatch") || 
                        errorMsg.contains("provided does not exist") ||
                        errorMsg.contains("does not exist in our records")) {
                        log.error("MinIO 认证失败：bucket={}, filename={}, 错误：{}", minIoConfig.getBucketName(), filename, errorMsg);
                        throw new RuntimeException("MinIO 认证失败，请检查访问密钥配置（当前配置：endpoint=" + minIoConfig.getEndpoint() + ", accessKey=" + minIoConfig.getAccessKey() + "）。错误详情：" + errorMsg);
                    }
                    // 再检查是否是文件不存在的错误
                    if (errorMsg.contains("NoSuchKey") || 
                        errorMsg.contains("Not Found") ||
                        errorMsg.contains("404") ||
                        (errorMsg.contains("does not exist") && !errorMsg.contains("Access Key") && !errorMsg.contains("records"))) {
                        log.error("文件不存在：bucket={}, filename={}, 错误：{}", minIoConfig.getBucketName(), filename, errorMsg);
                        throw new RuntimeException("文件不存在：bucket=" + minIoConfig.getBucketName() + ", filename=" + filename + "，请检查文件是否已成功上传到MinIO");
                    }
                }
                // 其他错误继续抛出
                throw e;
            }
            
            GetPresignedObjectUrlArgs objectUrlArgs = GetPresignedObjectUrlArgs.builder()
                    .bucket(minIoConfig.getBucketName())
                    .object(filename)
                    .expiry(60, TimeUnit.MINUTES)
                    .method(Method.GET)
                    .build();
            
            String presignedObjectUrl = minioClient.getPresignedObjectUrl(objectUrlArgs);
            log.info("成功生成临时访问链接：{}", presignedObjectUrl);

            return presignedObjectUrl;
        } catch (RuntimeException e) {
            // 重新抛出RuntimeException，保持原始错误信息
            throw e;
        } catch (Exception e) {
            log.error("获取临时文件访问链接失败，文件路径：{}，错误信息：{}", remoteFilePath, e.getMessage(), e);
            // 检查是否是 MinIO 连接问题
            String errorMsg = e.getMessage();
            if (errorMsg != null) {
                if (errorMsg.contains("Connection") || errorMsg.contains("ConnectException") || 
                    errorMsg.contains("Connection refused") || errorMsg.contains("Connection timed out")) {
                    throw new RuntimeException("无法连接到 MinIO 服务，请检查 MinIO 服务是否正常运行（当前配置：endpoint=" + minIoConfig.getEndpoint() + "）");
                }
                if (errorMsg.contains("Access Key") || errorMsg.contains("InvalidAccessKeyId") || 
                    errorMsg.contains("SignatureDoesNotMatch") || errorMsg.contains("provided does not exist")) {
                    throw new RuntimeException("MinIO 认证失败，请检查访问密钥配置（当前配置：endpoint=" + minIoConfig.getEndpoint() + ", accessKey=" + minIoConfig.getAccessKey() + "）");
                }
                if (errorMsg.contains("does not exist") || errorMsg.contains("NoSuchKey") || 
                    errorMsg.contains("Not Found") || errorMsg.contains("NoSuchBucket")) {
                    throw new RuntimeException("文件或存储桶不存在：bucket=" + minIoConfig.getBucketName() + ", filename=" + (remoteFilePath.contains("/") ? remoteFilePath.substring(remoteFilePath.lastIndexOf("/") + 1) : remoteFilePath));
                }
            }
            throw new RuntimeException("获取临时文件访问链接失败：" + (errorMsg != null ? errorMsg : e.getClass().getSimpleName()));
        }
    }

    @Override
    public String copyRemoteFileToLocalTempFile(String remoteFilePath) {
        // 拼接本地临时文件路径
        String localTempFilePath = System.getProperty("user.dir")+ File.separator+"static"+File.separator
                + IdUtil.simpleUUID() + CustomFileUtil.getSuffix(remoteFilePath);
        // 创建临时文件夹
        CustomFileUtil.mkdir(localTempFilePath);
        try {
            // 获取临时访问文件的URL地址
            String tempAccessFileUrl = getTempAccessFileUrl(remoteFilePath);
            URL url =  new URL(tempAccessFileUrl);
            // 打开远程文件的输入流
            InputStream inputStream = url.openStream();

            // 创建本地文件对象
            Path localFile = Path.of(localTempFilePath);

            // 将远程文件复制到本地文件
            Files.copy(inputStream, localFile, StandardCopyOption.REPLACE_EXISTING);

            // 关闭输入流
            inputStream.close();
            // 返回本地文件路径
            return localFile.toFile().getPath();
        } catch (Exception e){
            // 记录错误日志
            log.error(e.getMessage());
            // 抛出异常：读取远程文件失败
            throw new RuntimeException("读取远程文件失败");
        }
    }


    /**
     * 文件上传方法
     *
     * @param file
     * @param filename
     */
    private void upload(MultipartFile file, String filename) {
        if (file == null || file.getSize() == 0) {
            throw new RuntimeException("文件为空");
        } else {
            try {
                InputStream inputStream = file.getInputStream();
                PutObjectArgs putObjectArgs = PutObjectArgs.builder().bucket(minIoConfig.getBucketName()).object(filename)
                        .stream(inputStream, file.getSize(), -1)
                        .contentType(file.getContentType()).build();
                minioClient.putObject(putObjectArgs);
            } catch (Exception e) {
                throw new RuntimeException("文件上传失败");
            }
        }
    }
}
