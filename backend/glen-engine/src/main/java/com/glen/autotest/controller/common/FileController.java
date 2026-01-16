package com.glen.autotest.controller.common;
import jakarta.annotation.Resource;
import com.glen.autotest.service.common.FileService;
import com.glen.autotest.util.JsonData;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@RestController
@RequestMapping("/api/v1/file")
public class FileController {

    @Resource
    private FileService fileService;

    /**
     * 文件上传接口
     * @param file
     * @return
     */
    @PostMapping("/upload")
    public JsonData upload(@RequestParam("file") MultipartFile file){

        String path = fileService.upload(file);

        return JsonData.buildSuccess(path);
    }


    /**
     * 获取临时访问url
     * @param fileUrl
     * @return
     */
    @GetMapping("get_temp_url")
    public JsonData getTempUrl(@RequestParam("fileUrl") String fileUrl){
        String tempAccessFileUrl = fileService.getTempAccessFileUrl(fileUrl);
        return JsonData.buildSuccess(tempAccessFileUrl);
    }


}
