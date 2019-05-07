//
//  MMLexrParserText.m
//  Weather_AppTests
//
//  Created by 洛奇 on 2019/4/30.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMInterpreter.h"
#import "MMParserr.h"

#define MMInterpreterExpr(text) [[MMInterpreter interpreterWith:text] expr]

@interface MMLexrParserText : XCTestCase

@end

@implementation MMLexrParserText

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void) testDotNumber{
    MMLexer * lexer = [MMLexer lexer:@"4.+2"];
    XCTAssertEqual(4., [lexer floatString].floatValue);
}

- (void) testDoubleAdd{
    MMInterpreter * interpreter = [MMInterpreter interpreterWith:@"8.2+3.1-6.6"];
    XCTAssertEqual(8.2+3.1-6.6, [interpreter expr]);
}

- (void) testDoubleAdd2{
    MMInterpreter * interpreter = [MMInterpreter interpreterWith:@"8.2+.1-6."];
    XCTAssertEqual(8.2+0.1-6, [interpreter expr]);
}

- (void) testDoublePlus{
//    XCTAssertEqual(8.2*3.1-6.6, [[MMInterpreter interpreterWith:@"8.2*3.1-6.6"] expr]);
    XCTAssertEqual(6.5*3, MMInterpreterExpr(@"6.5*3"));
    XCTAssertEqual((13.1-6.6), MMInterpreterExpr(@"13.1-6.6"));
    XCTAssertEqual((13.1-6.6)*3.0, MMInterpreterExpr(@"(13.1-6.6)*3"));
}

- (void) testDoublePlus2{
    // 不支持负数 的乘除
    // 不支持
    XCTAssertEqual(3.1-6.6, [[MMInterpreter interpreterWith:@"3.1-6.6"] expr]);
    XCTAssertEqual(10+3.1-6.6, [[MMInterpreter interpreterWith:@"10+3.1-6.6"] expr]);
    XCTAssertEqual((13.1-6.6)*3.0, [[MMInterpreter interpreterWith:@"(13.1-6.6)*3.0"] expr]);
    XCTAssertEqual((13.6-6.6)*3.0, [[MMInterpreter interpreterWith:@"(13.6-6.6)*3.0"] expr]);
    XCTAssertEqual(2*(3.1-6.6), [[MMInterpreter interpreterWith:@"(3.1-6.6)*2"] expr]);
}

- (void)testAdd1 {
    MMInterpreter * interpreter = [MMInterpreter interpreterWith:@"8+3-6"];
    XCTAssertEqual(8+3-6, [interpreter expr]);
}
- (void) testHaveDot{
    MMInterpreter * interpreter = [MMInterpreter interpreterWith:@"8+3.2*6+4-2"];
    XCTAssertEqual(8+3.2*6+4-2, [interpreter expr]);
}
- (void) testAll{
    MMLexer * lexer = [MMLexer lexer:@"8+(3-6)*4/2"];
    MMInterpreter * interpreter = [MMInterpreter interpreter:lexer];
    XCTAssertEqual(8+(3-6)*4/2, [interpreter expr]);
}

- (void) testAllPlus{
    MMLexer * lexer = [MMLexer lexer:@"(8+(3-6)/2)*(4-6)/(2+5)"];
    MMInterpreter * interpreter = [MMInterpreter interpreter:lexer];
    XCTAssertEqual((8+(3-6)/2)*(4-6)/(2+5), [interpreter expr]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
