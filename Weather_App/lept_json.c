//
//  lept_json.c
//  Weather_App
//
//  Created by 洛奇 on 2019/4/30.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#include "lept_json.h"
#include <stdlib.h>  /* NULL, strtod() */
#include <string.h>

#define EXPECT(c, ch) do {  c->json++; } while(0)

#define ISDIGIT(ch)         ((ch) >= '0' && (ch) <= '9')
#define ISDIGIT1TO9(ch)     ((ch) >= '1' && (ch) <= '9')

#define lept_init(v) do { (v)->type = LEPT_NULL; } while(0)

#define lept_set_null(v) lept_free(v)

#ifndef LEPT_PARSE_STACK_INIT_SIZE
#define LEPT_PARSE_STACK_INIT_SIZE 256
#endif


// 声明
typedef struct {
    const char* json;///<要解析的json字符串，char* 表示不可以修改
    char* stack;// 一个动态堆栈数据结构，用于解析字符串的时候存储的临时缓冲区
    size_t size, top;// size为堆栈的容量，top为栈顶的位置
} lept_context;


// 去除c->json中的空白字符，相当于将字符串压缩
static void lept_parse_whitespace(lept_context* c) {
    const char *p = c->json;
    while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r'){
        p++;
    }
    c->json = p;
}

#pragma mark - private

void lept_free(lept_value* v){
    
    if (v->type == LEPT_STRING) {
        free(v->s.s);
    }
    lept_init(v);
}

static void* lept_context_push(lept_context* c, size_t size){

    void* result;
    if (c->top + size >= c->size) {
        if (c->size == 0)
            c->size = LEPT_PARSE_STACK_INIT_SIZE;
        while (c->top + size >= c->size) {
            c->size += c->size >> 1;  /* c->size * 1.5 */
        }
        c->stack = (char*)realloc(c->stack, c->size);
    }
    result = c->stack + c->top;
    c->top += size;
    return result;
}

static void* lept_context_pop(lept_context* c, size_t size){
    return c->stack + (c->top -= size);
}
#pragma mark - 解析不同情况下的内容

// 重构解析null、true、false这些字面量的方法
static lept_parser_result lept_parse_literal(lept_context* c, lept_value* v, const char* literal, lept_type type){

    c->json++;
    size_t i;
    for (i = 0; literal[i+1]!='\0'; i++) {
        if (c->json[i] != literal[i+1]) {
            return LEPT_PARSE_INVALID_VALUE;
        }
    }
    c->json += i;
    v->type = type;
    return LEPT_PARSE_OK;
}

// 解析数字
static lept_parser_result lept_parse_number(lept_context* c, lept_value* v){
    
    /*
     double strtod(const char *nptr,char **endptr);

     会扫描参数nptr字符串，跳过前面的空格字符，直到遇上数字或正负符号才开始做转换，到出现非数字或字符串结束时('\0')才结束转换，并将结果返回。
     若endptr不为NULL，则会将遇到不合条件而终止的nptr中的字符指针由endptr传回。
     参数nptr字符串可包含正负号、小数点或E(e)来表示指数部分。如123.456或123e-2
     */
    // 将10进制的数字转化成2进制的double
    const char *p = c->json;
    
    // 依次解析字符串，-34.3[e|E][-|+]22.3
    if (*p == '-') p++;
    if (*p == '0') {//如果有0，就跳过
        p++;
    } else {
        if (!ISDIGIT1TO9(*p)) return LEPT_PARSE_INVALID_VALUE;
        for (p++ ; ISDIGIT(*p); p++);
    }
    if (*p == '.') {
        p++;
        if (!ISDIGIT(*p)) return LEPT_PARSE_INVALID_VALUE;
        for (p++ ; ISDIGIT(*p); p++);
    }
    if (*p == 'e' || *p == 'E') {
        p++;
        if (*p == '+' || *p == '-') p++;
        if (!ISDIGIT(*p)) return LEPT_PARSE_INVALID_VALUE;
        for (p++ ; ISDIGIT(*p); p++);
    }
    
    if (c->json == p || p[0] != '\0') {
        return LEPT_PARSE_INVALID_VALUE;
    }
    // 如果c->json为【134er】，这里的end为【er】；如果是「1411」，这里就为空；如果是（sdfsd），这里为（sdfsd）
    v->n = strtod(c->json , NULL);// str to double?
    v->type = LEPT_NUMBER;
    c->json = p;
    return LEPT_PARSE_OK;
}

lept_parser_result lept_parse_string(lept_context* c, lept_value* v){
    
    return LEPT_PARSE_OK;
}

#pragma mark - getter & setter

void lept_set_string(lept_value* v, const char* s, size_t len){

    lept_free(v);
    v->s.s = (char*)malloc(len + 1);// 为v.s.s字符串申请内存长度
    memcpy(v->s.s, s, len);// 将入参s的内容copy到v.s.s中

    v->s.s[len] = '\0';
    v->s.len = len;
    v->type = LEPT_STRING;
}

const char* lept_get_string(const lept_value* v){
    return v->s.s;
}

const size_t lept_get_string_len(const lept_value* v){
    return v->s.len;
}

double lept_get_number(const lept_value* v){

    ///<确保是number类型的时候才可以调用这个来获取数值
    if (v->type == LEPT_NUMBER && v != NULL) {
        return v->n;
    }
    return 0.0f;
}

void lept_set_number(lept_value* v, double n){
    v->n = n;
}

//lexer
static lept_parser_result lept_parse_value(lept_context* c, lept_value* v) {
    switch (*c->json) {
        case 'n':  return lept_parse_literal(c, v, "null", LEPT_NULL);
        case 't':  return lept_parse_literal(c, v, "true", LEPT_TRUE);
        case 'f':  return lept_parse_literal(c, v, "false", LEPT_FALSE);
        default:   return lept_parse_number(c, v);
        case '\0': return LEPT_PARSE_EXPECT_VALUE;
    }
}


#pragma makr - api

lept_parser_result lept_parser(lept_value* v, const char* json){
    
    lept_context c;
    lept_parser_result result;
    c.json = json;//为context设置json文本
    c.stack = NULL;
    c.size = c.top = 0;
    lept_parse_whitespace(&c);//清除context中文本的空白字符
    result = lept_parse_value(&c, v);
    if (result == LEPT_PARSE_OK) {
        lept_parse_whitespace(&c);//防止 'null x'这样的字符串，因为json的文本语法格式为 ws value ws
        if (*c.json != '\0') {
            result = LEPT_PARSE_ROOT_NOT_SINGULAR;
        }
    }
    free(c.stack);// 释放缓存的区域
    return result;
}

lept_type lept_get_type(const lept_value* v){
    return v->type;
}

