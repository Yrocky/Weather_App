//
//  MT_Renderer.m
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MT_Renderer.h"
#import "MT_Section.h"

@implementation MT_Renderer

- (instancetype) initWithAdaper:(id<MT_Adapter>)adapter updater:(id<MT_Updater>)updater{
    self = [super init];
    if (self) {
        _updater = updater;
        _adapter = adapter;
    }
    return self;
}

- (void)setTarget:(id)target{
    _target = target;
    if (target) {
        [self.updater prepare:target adapter:self.adapter];
    }
}

- (NSArray<MT_Section *> *)data{
    return self.adapter.data;
}

- (void)setData:(NSArray<MT_Section *> *)data{
    [self renderWith:data];
}

- (void) renderWith:(NSArray<MT_Section *> *)data{
    
    if (!self.target) {
        self.adapter.data = data;
        return;
    }
    [self.updater performUpdates:_target adapter:self.adapter data:data];
}

- (void) renderWithSection:(MT_Section *)section{
    [self renderWith:[section buildSections]];
}

- (void) renderWithSectionBuilder:(MT_Section *(^)(void))sectionBuilder{
    if (!sectionBuilder) {
        return;
    }
    [self renderWithSection:sectionBuilder()];
}

- (void) renderWithCells:(NSArray<MT_CellNode *> *)cells{
    
    [self renderWith:({
        MT_Section * section = [MT_Section new];
        section.cells = cells;
        [section buildSections];
    })];
}

- (void) renderWithCellBuilder:(MT_CellNode *(^)(void))cellBuilder{
    if (!cellBuilder) {
        return;
    }
    [self renderWithCells:[cellBuilder() buildCells]];
}

@end
