//
//  MMConsolePlugin.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "MMConsolePlugin.h"

@implementation MMConsolePlugin

- (void) log{
    if (nil != self.data) {
        NSLog(@"[webView] log:%@",self.data);
    }
}
@end
