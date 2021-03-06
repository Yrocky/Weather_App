//
//  MT_Section.h
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MT_ViewNode;
@class MT_CellNode;

NS_ASSUME_NONNULL_BEGIN

@interface MT_Section : NSObject

@property (nonatomic ,strong ,nullable) MT_ViewNode * header;

@property (nonatomic ,copy) NSArray<MT_CellNode *> * cells;

@property (nonatomic ,strong ,nullable) MT_ViewNode * footer;

- (NSArray<MT_Section *> *) buildSections;

@property (nonatomic ,copy ,readonly) NSString * identifier;

@end

NS_ASSUME_NONNULL_END
