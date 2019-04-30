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

- (void)testLeptTrue{
    lept_value v;
    v.type = LEPT_TRUE;
    XCTAssertEqual(LEPT_PARSE_OK, lept_parser(&v, "true"));
    XCTAssertEqual(LEPT_TRUE, lept_get_type(&v));
}

- (void)testLeptFalse{
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
