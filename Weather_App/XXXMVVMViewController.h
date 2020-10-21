//
//  XXXMVVMViewController.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXXViewModel.h"
#import <YTKNetwork/YTKRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXXMVVMViewController : UIViewController

@end

@interface DemoListViewModel : XXXViewModel

@end

@interface DemoListService : XXXService

@end

@interface DemoListLayoutData : XXXCellLayoutData
@property (nonatomic ,assign) CGRect picFrame;
@property (nonatomic ,assign) CGRect nameFrame;
@end

@interface DemoListModel : NSObject<XXXModelAble>
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * pic;

@property (nonatomic ,strong) DemoListLayoutData * layoutData;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
@end

@interface DemoTableViewCell : UITableViewCell<XXXCellAble>

@end

@interface DemoListRequest : YTKRequest
- (instancetype) initWithKey:(NSInteger)key;
@property (nonatomic ,copy ,readonly) NSArray * list;
@end
NS_ASSUME_NONNULL_END
