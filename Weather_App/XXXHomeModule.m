//
//  XXXHomeModule.m
//  Weather_App
//
//  Created by skynet on 2019/8/20.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXHomeModule.h"

@AppLordModule(XXXHomeModule)
@implementation XXXHomeModule

- (void)moduleDidInit:(nonnull ALContext *)context {
    
}

@end

@AppLordService(XXXHomeService, XXXHomeServiceImpl)
@implementation XXXHomeServiceImpl

- (void)doSomething{
    XXXHomeModule * module = [[ALContext sharedContext] findModule:[XXXHomeModule class]];
    
    NSLog(@"module.tag:%ld",(long)module.tag);
}

@end
