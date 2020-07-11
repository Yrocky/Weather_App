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
// 对于null、true、false这些值固定的类型可以直接使用type来表示，但是对于number、string、array、object就需要使用一个属性来存储解析后的结果
typedef struct {
    union{// 使用union来节约内存，因为一个value不能同时是number又是string
        struct { char* s; size_t len; } s;// 添加一个字符串类型的数据存储属性
        double n;//为number的时候的数值
    };
    lept_type type;
} lept_value;

#pragma mark - func

// 解析json这里接受const char*的意思是这个json不可以修改
lept_parser_result lept_parser(lept_value* v, const char* json);

// 获取类型
lept_type lept_get_type(const lept_value* v);

#pragma mark - type setter&getter

void lept_set_string(lept_value* v, const char* s, size_t len);
const char* lept_get_string(const lept_value* v);
const size_t lept_get_string_len(const lept_value* v);

double lept_get_number(const lept_value* v);
void lept_set_number(lept_value* v, double n);
#endif /* lept_json_h */
