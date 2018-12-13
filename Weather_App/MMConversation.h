//
//  MMConversation.h
//  Weather_App
//
//  Created by Rocky Young on 2018/12/5.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMConversation : NSObject

/**
 在定义model的属性的时候，会使用nonatomic来修饰，表示不使用原子性，对该属性进行了加锁
 但是这样的设置对多线程是不安全的，多线程调用会引起crash
 
 观察`-nonatomicCarshMethod`方法，使用while之后，异步多地方调用该属性就会crash
**/
@property (nonatomic ,copy) NSArray * messages;

/**
 使用`atomic`可以避免crash，但是这样会引起其他的多线程问题，比如数据竞争
 **/
@property (atomic ,copy) NSArray * names;
@end

NS_ASSUME_NONNULL_END
