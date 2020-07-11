//
//  MMLeptTest.m
//  Weather_AppTests
//
//  Created by 洛奇 on 2019/4/30.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "lept_json.h"

@interface MMLeptTest : XCTestCase

@end

@implementation MMLeptTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLeptNull {
    lept_value v;
    v.type = LEPT_NULL;
    XCTAssertEqual(LEPT_PARSE_OK, lept_parser(&v, "null"));
    XCTAssertEqual(LEPT_NULL, lept_get_type(&v));
}

- (void) testLeptNullX{
    lept_value v;
    v.type = LEPT_NULL;
    XCTAssertEqual(LEPT_PARSE_ROOT_NOT_SINGULAR, lept_parser(&v, "null x"));
    XCTAssertEqual(LEPT_NULL, lept_get_type(&v));
}

- (void)testLeptTrue{
    lept_value v;
    v.type = LEPT_TRUE;
    XCTAssertEqual(LEPT_PARSE_OK, lept_parser(&v, "true"));
    XCTAssertEqual(LEPT_TRUE, lept_get_type(&v));
}

- (void)testLeptFalse{
    
    lept_value v;
    v.type = LEPT_FALSE;
    XCTAssertEqual(LEPT_PARSE_OK, lept_parser(&v, "false"));
    XCTAssertEqual(LEPT_FALSE, lept_get_type(&v));
}

- (void) testLeptNumber{
    lept_value v;
    v.type = LEPT_NUMBER;
    XCTAssertEqual(LEPT_PARSE_OK, lept_parser(&v, "1325"));
    XCTAssertEqual(LEPT_PARSE_OK, lept_parser(&v, "2.2250738585072014e-308"));
    lept_parser(&v, "2.2250738585072014e-308");
    XCTAssertEqual(2.2250738585072014e-308, v.n);
    XCTAssertEqual(LEPT_PARSE_OK, lept_parser(&v, "-1325"));
    XCTAssertEqual(LEPT_PARSE_OK, lept_parser(&v, "-1325.8"));
    
    XCTAssertEqual(LEPT_PARSE_INVALID_VALUE, lept_parser(&v, "-.3"));
    XCTAssertEqual(LEPT_PARSE_INVALID_VALUE, lept_parser(&v, ".3"));
    XCTAssertEqual(LEPT_PARSE_INVALID_VALUE, lept_parser(&v, "-1325."));
    XCTAssertEqual(LEPT_PARSE_INVALID_VALUE, lept_parser(&v, "1325qw"));
    XCTAssertEqual(LEPT_PARSE_INVALID_VALUE, lept_parser(&v, "qwer"));
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
