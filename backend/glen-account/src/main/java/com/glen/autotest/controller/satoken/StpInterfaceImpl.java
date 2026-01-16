//package com.glen.autotest.controller.satoken;
//
//import cn.dev33.satoken.stp.StpInterface;
//import org.springframework.stereotype.Component;
//
//import java.util.ArrayList;
//import java.util.List;
//
///**
// * Glen AutoTest Platform
// *
// * @Description
// * @Author Glen Team
// * @Remark Glen AutoTest Platform
// * @Version 1.0
// **/
//@Component
//public class StpInterfaceImpl implements StpInterface {
//    //private AccountMapper accountMapper;
//
//    @Override
//    public List<String> getPermissionList(Object loginId, String loginType) {
//
//        System.out.println("触发权限查询方法");
//        List<String> list = new ArrayList<>();
//        list.add("user.add");
//        list.add("user.update");
//        list.add("user.get");
//        list.add("art.*");
//        return list;
//    }
//
//    @Override
//    public List<String> getRoleList(Object loginId, String loginType) {
//        System.out.println("触发角色查询方法");
//        List<String> list = new ArrayList<>();
//        list.add("admin");
//        list.add("super-admin");
//        list.add("super.*");
//        return list;
//    }
//}
