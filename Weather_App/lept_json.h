//
//  lept_json.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/30.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#ifndef lept_json_h
#define lept_json_h

#include <stdio.h>

// 解析结果的枚举
typedef enum {
    LEPT_PARSE_OK = 0,
    LEPT_PARSE_EXPECT_VALUE,///<json为空白字符串
    LEPT_PARSE_INVALID_VALUE,///<存在无效的值
    LEPT_PARSE_ROOT_NOT_SINGULAR///<在空白之后还有其他字符串
} lept_parser_result;

// 声明json中的终结表达式，目前有以下几种，未来还会有大括号、中括号
typedef enum {
    LEPT_NULL,///<null
    LEPT_FALSE,///<false
    LEPT_TRUE,///<true
    LEPT_NUMBER,///<数字
    LEPT_STRING,///<字符串
    LEPT_ARRAY,///<数组
    LEPT_OBJECT///<对象（字典）
} lept_type;

// 声明json的数据结构，这里的lept_value其实就是词法分析之后获得的token，每一个节点使用lept_value表示，type用来表示它的类型
typedef struct {
    lept_type type;
} lept_value;

#pragma mark - func

// 解析json这里接受const char*的意思是这个json不可以修改
lept_parser_result lept_parser(lept_value* v, const char* json);

// 获取类型
lept_type lept_get_type(const lept_value* v);

#endif /* lept_json_h */
