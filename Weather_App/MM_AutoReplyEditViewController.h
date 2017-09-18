//
//  MM_AutoReplyEditViewController.h
//  Weather_App
//
//  Created by Rocky Young on 2017/9/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MM_AutoReplyItem : NSObject<NSCoding>

@property (nonatomic ,strong) NSDate * createTime;
@property (nonatomic ,copy) NSString * regex;
@property (nonatomic ,copy) NSString * reply;
@property (nonatomic ,assign) BOOL valid;
@end

@protocol MM_AutoReplyEditViewControllerDelegate <NSObject>

- (void) onAutoReplyAddItemDone:(id)item;
@end

@interface MM_AutoReplyEditViewController : UIViewController

@property (nonatomic ,weak) id<MM_AutoReplyEditViewControllerDelegate> delegate;

- (instancetype) initWithItem:(id)item;
@end

@interface MM_PlistMgr : NSObject

+ (NSArray *) mm_loadData;
+ (BOOL) mm_addOneItem:(id)item;
+ (BOOL) mm_updateItem:(id)item;
+ (BOOL) mm_deleteItem:(id)item;
@end
