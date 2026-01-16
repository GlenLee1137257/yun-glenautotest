package com.glen.autotest.dto.stress;

import lombok.Data;

/**
 * Glen AutoTest Platform
 *
 * @Description 映射 relation字段到这个对象
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Data
public class CSVDataFileDTO {

        /**
         * 必填，文件名 比如： CSV商品数据集合
         */
        private String name;

        /**
         * 必填，文件远程上传路径
         */
        private String remoteFilePath;

        /**
         * 下载到本地到临时文件路径
         */
        private String localFilePath;

        /**
         * 类型，目前只支持csv
         */
        private String sourceType = "csv";
        /**
         * 设置分隔符为逗号
         */
        private String delimiter = ",";
        /**
         * 设置是否忽略第一行
         */
        private Boolean ignoreFirstLine = false;
        /**
         * 是否循环读取数据
         */
        private Boolean recycle = true;

        /**
         * 变量名
         */
        private String variableNames;

}
