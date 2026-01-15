package com.glen.autotest.exception;

import lombok.Getter;

/**
 * 业务异常类
 */
@Getter
public class BizException extends RuntimeException {
    private final int code;
    private final String msg;

    public BizException(int code, String msg) {
        super(msg);
        this.code = code;
        this.msg = msg;
    }

    public BizException(String msg) {
        super(msg);
        this.code = -1;
        this.msg = msg;
    }
}
