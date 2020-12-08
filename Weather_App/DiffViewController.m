//
//  DiffViewController.m
//  Weather_App
//
//  Created by rocky on 2020/12/7.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DiffViewController.h"
#import <IGListDiffKit/IGListDiffKit.h>
#import <Masonry/Masonry.h>

@interface Diff_Person : NSObject<IGListDiffable>
@property (nonatomic ,strong) NSNumber * identifier;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,assign) NSInteger age;
@property (nonatomic ,copy) NSString * address;
@end

@interface DiffViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic ,strong) NSArray * dataSource;
@property (nonatomic ,strong) UITableView * tableView;
@end

@implementation DiffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[
        @"a",@"b",@"c",@"d",
        @"e",@"f",@"g",@"h"
    ];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    
    UIButton * updateButton = [UIButton new];
    [updateButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(onUpdate)
           forControlEvents:UIControlEventTouchUpInside];
    [updateButton setTitle:@"Update" forState:UIControlStateNormal];
    [self.view addSubview:updateButton];
    
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-10);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(updateButton.mas_top).mas_offset(-10);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
    }];
    NSArray * source1 = @[
        @"a",@"b",@"c",@"d",
        @"e",@"f",@"g",@"h"
    ];
    
    NSArray * source1_1 = @[
        @"a",@"f",@"g",@"d",
        @"e",@"x",@"gg",@"h"
    ];
    
    NSArray * source2 = @[
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(0);
            person.name = @"zero";
            person.address = @"live in zero";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(1);
            person.name = @"zero";
            person.address = @"live in 1 zero";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(2);
            person.name = @"two";
            person.address = @"live in 2";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(3);
            person.name = @"three";
            person.address = @"live in 3";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(4);
            person.name = @"four";
            person.address = @"live in 4";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(5);
            person.name = @"five";
            person.address = @"live in 5";
            person.age = 10;
            person;
        }),
    ];
    
    NSArray * source2_2 = @[
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(1);
            person.name = @"zero";
            person.address = @"live in 1 zero";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(2);
            person.name = @"two";
            person.address = @"live in 2";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(0);
            person.name = @"zero";
            person.address = @"live in zero";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(3);
            person.name = @"three";
            person.address = @"live in 3";
            person.age = 10;
            person;
        }),
        ({
            Diff_Person * person = [Diff_Person new];
            person.identifier = @(5);
            person.name = @"five";
            person.address = @"live in 5";
            person.age = 10;
            person;
        }),
    ({
        Diff_Person * person = [Diff_Person new];
        person.identifier = @(14);
        person.name = @"ten four";
        person.address = @"live in 14";
        person.age = 10;
        person;
    }),
    ];
    
    {
        IGListIndexSetResult * result1 =
        IGListDiff(source1, source1_1, IGListDiffEquality);
        
        if (result1.hasChanges) {
            NSLog(@"insert:%@",result1.inserts);
            NSLog(@"delete:%@",result1.deletes);
            NSLog(@"update:%@",result1.updates);
            NSLog(@"moves:%@",result1.moves);
        }
    }
    
    {
        IGListIndexSetResult * result2 =
        IGListDiff(source2, source2_2, IGListDiffEquality);
        
        if (result2.hasChanges) {
            NSLog(@"insert:%@",result2.inserts);
            NSLog(@"delete:%@",result2.deletes);
            NSLog(@"update:%@",result2.updates);
            NSLog(@"moves:%@",result2.moves);
        }
    }
}

- (void) onUpdate{
    NSArray * old = self.dataSource;
    NSArray * new = @[
        @"a",@"f",@"g",@"d",
        @"e",@"x",@"gg",@"h",
        @"1",@"2",@"3",@"4"
    ];
    
    self.dataSource = new;
    
    void(^update)(void) = ^(void) {
        IGListIndexPathResult * result =
        IGListDiffPaths(0, 0, old, new, IGListDiffEquality);
//        IGListDiff(old, new, IGListDiffEquality);
        if (result.hash) {
            if (result.deletes.count) {
                [self.tableView deleteRowsAtIndexPaths:result.deletes withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            if (result.inserts.count) {
                [self.tableView insertRowsAtIndexPaths:result.inserts withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            if (result.updates.count) {
                [self.tableView reloadRowsAtIndexPaths:result.updates withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            if (result.moves.count) {
                for (IGListMoveIndexPath * move in result.moves) {
                    [self.tableView moveRowAtIndexPath:move.from toIndexPath:move.to];
                }
            }
        }
    };
    [CATransaction begin];
    
    if (@available(iOS 11.0, *)) {
        [self.tableView performBatchUpdates:^{
            update();
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.tableView beginUpdates];
        update();
        [self.tableView endUpdates];
    }
    [CATransaction commit];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =
    [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
    return cell;
}
@end

@implementation Diff_Person

#pragma mark - IGListDiffable

- (nonnull id<NSObject>)diffIdentifier {
    return self.identifier;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self.diffIdentifier isEqual:object.diffIdentifier];
}

@end
