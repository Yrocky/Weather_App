//
//  SomeCustomView.m
//  Weather_App
//
//  Created by user1 on 2017/11/16.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "SomeCustomView.h"

@implementation SomeCustomView


+ (SomeCustomView *) xib{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SomeCustomView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
//    self.directionalLayoutMargins
    self.layoutMargins = UIEdgeInsetsMake(0, 200, 0, 200);
}
@end
