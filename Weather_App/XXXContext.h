//
//  XXXContext.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 在解释器模式中，它的任务一般是用来存放文法中各个终结符所对应的具体值
@interface XXXContext : NSObject{
    NSMutableDictionary * _vars;
}
@property (nonatomic ,copy ,readonly) NSDictionary * variables;

- (NSString *) varWithKey:(NSString *)key;
- (void) addVar:(NSString *)var forKey:(NSString *)key;

- (void) clear;
@end

NS_ASSUME_NONNULL_END
