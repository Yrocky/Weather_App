//
//  XXXAutoScrollImageView.h
//  Weather_App
//
//  Created by 洛奇 on 2019/5/31.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,XXXAutoScrollDirection) {
    XXXAutoScrollDirectionVertical,///<垂直翻滚
    XXXAutoScrollDirectionHorizontal,///<水平翻滚
    XXXAutoScrollDirectionLeftToRightDiagonal,///<\对角线
    XXXAutoScrollDirectionRightToLeftDiagonal,///</对角线
};

@interface XXXAutoScrollImageView : UIView

@property (nonatomic ,assign ,readonly) XXXAutoScrollDirection direction;///<default vertical

- (instancetype) initWithDirection:(XXXAutoScrollDirection)direction;

- (void) setupImage:(NSString *)imageName;
- (void) setupImage:(NSString *)imageUrl placeholder:(NSString *)placeholder;

- (void) start;
- (void) pause;

@end

NS_ASSUME_NONNULL_END
