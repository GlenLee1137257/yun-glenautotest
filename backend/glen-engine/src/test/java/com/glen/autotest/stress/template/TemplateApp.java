package com.glen.autotest.stress.template;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public class TemplateApp {
    public static void main(String[] args) {
        AbstractClass a = new AClass();
        a.templateMethod();

        AbstractClass b = new BClass();
        b.templateMethod();
    }
}
