package com.glen.autotest.service;

import com.glen.autotest.controller.req.*;
import com.glen.autotest.dto.AccountDTO;

import java.util.Map;

public interface AccountService {
    Map<String, Object> page(AccountPageReq req);

    int del(AccountDelReq req);

    int updateAccountStatus(AccountUpdateReq req);

    int register(AccountRegisterReq req);

    AccountDTO login(AccountLoginReq req);
}
