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
     * UI操作相关
     */
    UI_DRIVER_NOT_INITIALIZED(140001, "WebDriver未初始化"),
    UI_ELEMENT_NOT_EXIST(140002, "元素不存在"),
    UI_OPERATION_UNSUPPORTED(140003, "不支持的UI操作"),
    UI_OPERATION_UNSUPPORTED_ELEMENT(140004, "不支持的元素定位类型"),
    UI_OPERATION_UNSUPPORTED_BROWSER(140005, "不支持的浏览器操作"),
    UI_OPERATION_UNSUPPORTED_MOUSE(140006, "不支持的鼠标操作"),
    UI_OPERATION_UNSUPPORTED_WAIT(140007, "不支持的等待操作"),
    UI_OPERATION_UNSUPPORTED_ASSERTION(140008, "不支持的断言操作"),

    /**
     * 系统错误
     */
    SYSTEM_ERROR(999999, "系统错误");

    private final int code;
    private final String message;
}
