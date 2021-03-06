//
//  MT_Renderer.h
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_Updater.h"

NS_ASSUME_NONNULL_BEGIN

@interface MT_Renderer : NSObject

@property (nonatomic ,strong ,readonly) id<MT_Updater> updater;
@property (nonatomic ,strong ,readonly) id<MT_Adapter> adapter;

@property (nonatomic ,weak) id target;

@property (nonatomic ,copy) NSArray<MT_Section *> * data;

- (instancetype) initWithAdaper:(id<MT_Adapter>)adapter updater:(id<MT_Updater>)updater;

// 装Section的模型数据，核心方法
- (void) renderWith:(NSArray<MT_Section *> *)data;

- (void) renderWithSection:(MT_Section *)section;
- (void) renderWithSectionBuilder:(MT_Section *(^)(void))sectionBuilder;

- (void) renderWithCells:(NSArray<MT_CellNode *> *)cells;
- (void) renderWithCellBuilder:(MT_CellNode *(^)(void))cellBuilder;
@end

NS_ASSUME_NONNULL_END
