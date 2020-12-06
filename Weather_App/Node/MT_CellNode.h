//
//  MT_CellNode.h
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_ViewNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MT_CellNode : MT_ViewNode

- (NSArray<MT_CellNode *> *) buildCells;
@end

NS_ASSUME_NONNULL_END
