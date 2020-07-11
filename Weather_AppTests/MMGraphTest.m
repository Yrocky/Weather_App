//
//  MMGraphTest.m
//  Weather_AppTests
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMGraph.h"
#import "MMEdge.h"
#import "MMVertex.h"

#define MMVertexInit(name, value) MMVertex<NSString *> * name = [MMVertex vertex:value];

#define MMEdgeInit(name, v1, v2) MMEdge * name = [MMEdge edgeFrom:v1 to:v2];

@interface MMGraphTest : XCTestCase

@end

@implementation MMGraphTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testVertex {
    
    MMVertexInit(a, @"a");
    MMVertexInit(b, @"b");
    MMVertexInit(c, @"c");
    MMVertexInit(d, @"d");
    //MMVertexInit(e, @"e");

    MMEdgeInit(a2b, a, b);
    MMEdgeInit(a2d, a, d);
    MMEdgeInit(b2c, b, c);
    MMEdgeInit(c2a, c, a);
    MMEdgeInit(d2a, d, a);
    MMEdgeInit(d2b, d, b);
    
    MMGraph * graph = [MMGraph graphStart:a];
    [graph addEdges:@[a2b, a2d, b2c, c2a, d2a, d2b]];
    
    NSSet * bd = [NSSet setWithObjects:b,d, nil];
    XCTAssertEqualObjects(bd, [graph findAdjacents:a]);
    NSLog(@"a.adjacents:%@",a.adjacents);
}

- (void) testCircleGraph{
    
    MMVertexInit(a, @"a");
    MMVertexInit(b, @"b");
    MMVertexInit(c, @"c");

    [a addAdjacent:b];
    [b addAdjacent:c];
    [c addAdjacent:a];
    
    MMGraph * graph = [MMGraph graphStart:a];
    [graph addVertex:b];
    [graph addVertex:c];
}

- (NSString *) someString{
    return @"a";
}

- (void) testVertexEqual{
    MMVertexInit(aa, @"a");
    MMVertexInit(bb, @"a");
    
    XCTAssert([aa isEqual:bb]);
    XCTAssert(aa != bb);///< “==”比较的是两个对象的地址，因此这里为NO
}

- (void) testStringEqual{
    
    XCTAssert(@"a" == @"a");///<由于字符串如果字面量相同，会共用同一个地址
    XCTAssert([@"a" isEqual:@"a"]);
    XCTAssert([@"a" isEqualToString:@"a"]);
    
    XCTAssert(@"a" == [self someString]);///<这里就是模拟不同堆栈中创建的字符串进行的比较
    
    //
}

- (void) testCopyStringEqual{

    XCTAssert([@"a" copy] == [self someString]);// 进行copy，只是copy了指针，地址还是没有发生变化
    XCTAssert([[@"a" copy] isEqual: [self someString]]);
    XCTAssert([[@"a" copy] isEqualToString: [self someString]]);
    
    XCTAssert([@"a" copy] == @"a");
    XCTAssert([[@"a" copy] isEqual: @"a"]);
    XCTAssert([[@"a" copy] isEqualToString: @"a"]);

}

- (void) testMutableCopyStringEqual{
    
    XCTAssert([@"a" mutableCopy] != [self someString]);// 由于进行了mutableCopy，地址已经发生了变化
    XCTAssert([[@"a" mutableCopy] isEqual: [self someString]]);
    XCTAssert([[@"a" mutableCopy] isEqualToString: [self someString]]);
    
    XCTAssert([@"a" mutableCopy] != @"a");
    XCTAssert([[@"a" mutableCopy] isEqual: @"a"]);// 这个方法先比较地址上的字面量，这个时候虽然是地址不同了，但是字面量是相同的
    XCTAssert([[@"a" mutableCopy] isEqualToString: @"a"]);// 这个方法同上面，只不过是对字符串的一个便捷比较
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
