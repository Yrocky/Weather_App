//
//  XXXHomeModule.h
//  Weather_App
//
//  Created by skynet on 2019/8/20.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppLord/AppLord.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XXXHomeService <ALService>
- (void) doSomething;
@end

@interface XXXHomeModule : NSObject<ALModule>

@property (nonatomic ,assign) NSInteger tag;
@end

@interface XXXHomeServiceImpl : NSObject<XXXHomeService>

@end
NS_ASSUME_NONNULL_END
