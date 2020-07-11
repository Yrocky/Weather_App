//
//  MMHomeSectionModel.m
//  Weather_App
//
//  Created by rocky on 2020/6/9.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeSectionModel.h"

@implementation MMHomeSectionModel

#pragma mark - IGListDiffable

- (nonnull id <NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id <IGListDiffable>)other {
    return [self isEqual:other];
}
@end
