//
//  XXXRPNTest.m
//  Weather_AppTests
//
//  Created by 洛奇 on 2019/5/7.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XXXRPN.h"

@interface XXXRPNTest : XCTestCase

@end

@implementation XXXRPNTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testRPNExpression {
    [XXXRPN rpnWithExpression:@"1*2+3-4"];
    [XXXRPN rpnWithExpression:@"2+(5-3)*4"];
    XCTAssertEqualObjects(@"12*3+4-",[[XXXRPN rpnWithExpression:@"1*2+3-4"] rpnString]);
    XCTAssertEqualObjects(@"253-4*+",[[XXXRPN rpnWithExpression:@"2+(5-3)*4"] rpnString]);
    XCTAssertEqualObjects(@"82-3/53-4*+",[[XXXRPN rpnWithExpression:@"(8-2)/3+(5-3)*4"] rpnString]);
    XCTAssertEqualObjects(@"82-3/53-+4*",[[XXXRPN rpnWithExpression:@"((8-2)/3+(5-3))*4"] rpnString]);
    XCTAssertEqualObjects(@"123+4*+5-",[[XXXRPN rpnWithExpression:@"1+((2+3)*4)-5"] rpnString]);
}

- (void) testRPNResult{
    
    XCTAssertEqual(1*2+3-4, [[XXXRPN rpnWithExpression:@"1*2+3-4"] result]);
    XCTAssertEqual(2+(5-3)*4, [[XXXRPN rpnWithExpression:@"2+(5-3)*4"] result]);
    XCTAssertEqual((8-2)/3+(5-3)*4, [[XXXRPN rpnWithExpression:@"(8-2)/3+(5-3)*4"] result]);
    XCTAssertEqual(((8-2)/3+(5-3))*4, [[XXXRPN rpnWithExpression:@"((8-2)/3+(5-3))*4"] result]);
    XCTAssertEqual(1+((2+3)*4)-5, [[XXXRPN rpnWithExpression:@"1+((2+3)*4)-5"] result]);
}

- (void) testRPNFloatResult{
    
    // 当遇到浮点数的时候，考虑到精度的问题，有时候会不准确，这个主要出现在倒数不是整数的时候
    XCTAssertEqual(1*2.2, [[XXXRPN rpnWithExpression:@"1*2.2"] result]);
    XCTAssertEqual(1+2.2, [[XXXRPN rpnWithExpression:@"1+2.2"] result]);
    XCTAssertEqual(1/0.3, [[XXXRPN rpnWithExpression:@"1/0.3"] result]);
    XCTAssertEqual(1-2.2, [[XXXRPN rpnWithExpression:@"1-2.2"] result]);
    
    XCTAssertEqual(5.1*2.2, [[XXXRPN rpnWithExpression:@"5.1*2.2"] result]);
    XCTAssertEqual(3.1+2.2, [[XXXRPN rpnWithExpression:@"3.1+2.2"] result]);
    XCTAssertEqual(4.5/0.2, [[XXXRPN rpnWithExpression:@"4.5/0.2"] result]);
    XCTAssertEqual(6.2-2.2, [[XXXRPN rpnWithExpression:@"6.2-2.2"] result]);
    
    XCTAssertEqual(1*2.2+3.5-4, [[XXXRPN rpnWithExpression:@"1*2.2+3.5-4"] result]);
    XCTAssertEqual(1.2+(5-3)*4, [[XXXRPN rpnWithExpression:@"1.2+(5-3)*4"] result]);
    XCTAssertEqual((8-2)/0.3+(5-3)*4.2, [[XXXRPN rpnWithExpression:@"(8-2)/0.3+(5-3)*4.2"] result]);
    XCTAssertEqual(((8-2)/3+(5.2-3))*1.4, [[XXXRPN rpnWithExpression:@"((8-2)/3+(5.2-3))*1.4"] result]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
