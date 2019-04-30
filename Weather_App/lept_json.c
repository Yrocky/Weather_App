//
//  lept_json.c
//  Weather_App
//
//  Created by 洛奇 on 2019/4/30.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#include "lept_json.h"

#define EXPECT(c, ch) do {  c->json++; } while(0)

// 声明
typedef struct {
    const char* json;///<要解析的json字符串，char* 表示不可以修改
} lept_context;


// 去除c->json中的空白字符，相当于将字符串压缩
static void lept_parse_whitespace(lept_context* c) {
    const char *p = c->json;
    while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r'){
        p++;
    }
    c->json = p;
}

//解析null
static lept_parser_result lept_parser_null(lept_context* c, lept_value* v) {
    
    if (*c->json != 'n') {
        return LEPT_PARSE_INVALID_VALUE;
    }
    c->json++;
    if (c->json[0] != 'u' || c->json[1] != 'l' || c->json[2] != 'l'){
        return LEPT_PARSE_INVALID_VALUE;
    }
    c->json += 3;
    v->type = LEPT_NULL;
    return LEPT_PARSE_OK;
}

static lept_parser_result lept_parser_true(lept_context* c, lept_value* v){
    if (*c->json != 't') {
        return LEPT_PARSE_INVALID_VALUE;
    }
    c->json++;
    if (c->json[0] != 'r' || c->json[1] != 'u' || c->json[2] != 'e'){
        return LEPT_PARSE_INVALID_VALUE;
    }
    c->json += 3;
    v->type = LEPT_NULL;
    return LEPT_PARSE_OK;
}

//lexer
static lept_parser_result lept_parse_value(lept_context* c, lept_value* v) {
    switch (*c->json) {
        case 'n':  return lept_parser_null(c, v);
        case 't':  return lept_parser_true(c, v);
        case '\0': return LEPT_PARSE_EXPECT_VALUE;
        default:   return LEPT_PARSE_INVALID_VALUE;
    }
}


#pragma makr - api

lept_parser_result lept_parser(lept_value* v, const char* json){
    
    lept_context c;
    //    (v != NULL);// 断言
    c.json = json;
    lept_parse_whitespace(&c);
    return lept_parse_value(&c, v);
}

lept_type lept_get_type(const lept_value* v){
    return v->type;
}

