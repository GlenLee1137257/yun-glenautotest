package com.glen.autotest.stress.template;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public abstract class AbstractClass {

    /**
     * 模版方法
     */
    public void templateMethod(){

        specialMethod();
        abstractMethod1();
        abstractMethod2();

    }


    public void specialMethod(){
        System.out.println("抽象类的具体方法被调用");
    }

    public abstract void abstractMethod1();

    public abstract void abstractMethod2();
}
