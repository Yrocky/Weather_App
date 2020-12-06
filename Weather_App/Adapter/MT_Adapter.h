//
//  MT_Adapter.h
//  Weather_App
//
//  Created by rocky on 2020/12/5.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_CellNode.h"
#import "MT_Section.h"
#import "MT_ViewNode.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MT_Adapter <NSObject>

// Section
@property (nonatomic ,copy) NSArray<MT_Section *> * data;

@optional
// CellNode
- (NSArray<MT_CellNode *> *) cellNodesInSection:(NSInteger)section;
- (MT_CellNode *) cellNodeAtIndexPath:(NSIndexPath *)indexPath;

// ViewNode
- (MT_ViewNode *) headerNodeInSection:(NSInteger)section;
- (MT_ViewNode *) footerNodeInSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
