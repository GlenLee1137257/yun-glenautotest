package com.glen.autotest.service.common;

import org.springframework.mock.web.MockMultipartFile;

/**
 * 文件服务接口
 */
public interface FileService {
  String uploadFile(byte[] fileBytes, String fileName);

  byte[] downloadFile(String filePath);

  void deleteFile(String filePath);

  /**
   * 上传 MultipartFile 文件
   */
  String upload(MockMultipartFile file);
}
