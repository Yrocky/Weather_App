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

@interface MMLexrParserText : XCTestCase

@end

@implementation MMLexrParserText

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAdd1 {
    MMInterpreter * interpreter = [MMInterpreter interpreterWith:@"8++3-6+4-2"];
    XCTAssertEqual(8+3-6+4-2, [interpreter expr]);
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
