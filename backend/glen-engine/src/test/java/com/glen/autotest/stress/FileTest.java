package com.glen.autotest.stress;

import jakarta.annotation.Resource;
import com.glen.autotest.EngineApplication;
import com.glen.autotest.service.common.FileService;
import com.glen.autotest.util.CustomFileUtil;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@SpringBootTest(classes = EngineApplication.class)
public class FileTest {

    @Resource
    private FileService fileService;

    @Test
    public void testTempFileApi(){
        String tempAccessFileUrl = fileService.getTempAccessFileUrl("http://120.79.56.211:9000/bucket/1704451097378-1872c826-3087-4167-b52c-9d70770d242epay_json_sleep.jmx");
        System.out.println(tempAccessFileUrl);
    }

    @Test
    public void testReadRemoteFile(){
        String content = CustomFileUtil.readRemoteFile("http://120.79.56.211:9000/bucket/1704451097378-1872c826-3087-4167-b52c-9d70770d242epay_json_sleep.jmx?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio_root%2F20240105%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240105T115617Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=dd43b5c55cf1a5da1299d4c6f7421182143013668e9134ecfdd66f9b703e0c4d");
        System.out.println(content);
    }

}
