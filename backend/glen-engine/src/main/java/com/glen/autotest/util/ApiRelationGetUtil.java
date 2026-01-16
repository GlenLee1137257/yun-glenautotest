package com.glen.autotest.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
public class ApiRelationGetUtil {

    /**
     *  获取参数或者关联参数
     *  正则匹配是否为关联参数表达式，如果不是的话则返回原始参数
     * @param string
     * @return
     */
    public static String getParameter(String string){

        String newString = string;
        Pattern pattern = Pattern.compile(ApiRegexpUtil.REGEXP);
        Matcher matcher = pattern.matcher(string);
        if(matcher.find()){
            String parameter = matcher.group(1);

            //去容器取关联参数
            String fetched = ApiRelationContext.get(parameter);
            if(fetched == null){
                //关联参数不存在
                throw new RuntimeException("关联参数不存在");
            }
            newString  = string.replaceAll(ApiRegexpUtil.byName(parameter),fetched);
        }
        return newString;
    }



}
