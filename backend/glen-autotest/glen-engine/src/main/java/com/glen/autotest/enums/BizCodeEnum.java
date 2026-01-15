package com.glen.autotest.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 业务状态码枚举类
 */
@Getter
@AllArgsConstructor
public enum BizCodeEnum {
    /**
     * 通用操作码
     */
    OPS_REPEAT(110001, "重复操作"),
    OPS_NETWORK_ADDRESS_ERROR(110002, "网络地址错误"),

    /**
     * 文件操作相关
     */
    FILE_UPLOAD_USER_IMG_FAIL(600101, "用户头像文件上传失败"),

    /**
     * 账号相关
     */
    ACCOUNT_REPEAT(110003, "账号已存在"),
    ACCOUNT_UNREGISTER(110004, "账号不存在"),
    ACCOUNT_PWD_ERROR(110005, "账号或密码错误"),

    /**
     * 项目相关
     */
    PROJECT_NOT_EXIST(120001, "项目不存在"),
    PROJECT_ACCESS_DENIED(120002, "无权限访问该项目"),

    /**
     * 测试用例相关
     */
    CASE_NOT_EXIST(130001, "测试用例不存在"),
    CASE_EXECUTE_FAIL(130002, "测试用例执行失败"),

    /**
     * 系统错误
     */
    SYSTEM_ERROR(999999, "系统错误");

    private final int code;
    private final String message;
}
