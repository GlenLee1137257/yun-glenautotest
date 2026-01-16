package com.glen.autotest.stress.template;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public class BClass extends AbstractClass{
    @Override
    public void abstractMethod1() {
        System.out.println("类B的abstractMethod1 被调用");
    }

    @Override
    public void abstractMethod2() {
        System.out.println("类B的abstractMethod2 被调用");
    }
}
