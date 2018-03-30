//
//  MMXibCustomView.m
//  Weather_App
//
//  Created by user1 on 2017/12/11.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMXibCustomView.h"

@implementation MMXibCustomOneView

+ (MMXibCustomOneView *)xibView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"MMXibCustomView" owner:nil options:nil][0];
}

@end

@implementation MMXibCustomTwoView

+ (MMXibCustomTwoView *)xibView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"MMXibCustomView" owner:nil options:nil][1];
}
@end

@implementation MMXibCustomThreeView

+ (MMXibCustomThreeView *)xibView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"MMXibCustomView" owner:nil options:nil][2];
}
@end
