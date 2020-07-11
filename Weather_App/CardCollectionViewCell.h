//
//  CardCollectionViewCell.h
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardCollectionViewCell : UICollectionViewCell

- (void) setupCoverImageWith:(NSString *)imageUrl name:(NSString *)name;
+ (NSString *) cellIdentifier;
@end

NS_ASSUME_NONNULL_END
