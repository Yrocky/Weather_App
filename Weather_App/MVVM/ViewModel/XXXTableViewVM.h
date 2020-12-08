//
//  XXXTableViewVM.h
//  BanBanLive
//
//  Created by rocky on 2020/12/8.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "XXXViewModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXXTableViewVM : XXXViewModel<
UITableViewDelegate,
UITableViewDataSource>{
    UITableView * _tableView;
}
- (instancetype) initWithTableView:(UITableView *)tableView;

- (void) reloadItemAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
