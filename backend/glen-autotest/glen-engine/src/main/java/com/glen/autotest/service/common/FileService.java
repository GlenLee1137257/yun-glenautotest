package com.glen.autotest.service.common;

/**
 * 文件服务接口
 */
public interface FileService {
    String uploadFile(byte[] fileBytes, String fileName);
    byte[] downloadFile(String filePath);
    void deleteFile(String filePath);
}
