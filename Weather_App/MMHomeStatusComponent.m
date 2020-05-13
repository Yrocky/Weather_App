//
//  MMHomeStatusComponent.m
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeStatusComponent.h"

@implementation MMHomeStatusComponent{
    NSMutableDictionary<NSString *, NSObject *> *_componentDict;
@protected
    NSUInteger _numberOfSections; // cache
}

- (NSInteger)firstItemOfSubComponent:(id)subComp {
    return 0;//self.item;
}

- (NSInteger)firstSectionOfSubComponent:(id)subComp {
    return 0;//self.section;
}

#pragma mark - state

- (NSObject *) currentComponent{
    return [self componentForState:self.currentState];
}

- (NSObject * _Nullable)componentForState:(NSString * _Nullable)state{
    return state? [_componentDict objectForKey:state] : nil;
}

- (void)setComponent:(NSObject * _Nullable)comp forState:(NSString * _Nullable)state{
    if (state) {
        NSObject *oldComp = _componentDict[state];
        if (comp) {
//            if (oldComp.superComponent == self) _componentDict[state].superComponent = nil;
//            comp.superComponent = self;
            [_componentDict setObject:comp forKey:state];
//            if (self.collectionView) {
//                [comp prepareCollectionView];
//            }
        }
        else {
//            if (oldComp.superComponent == self) _componentDict[state].superComponent = nil;
            [_componentDict removeObjectForKey:state];
        }
    }
}

- (void)changeState:(NSString *)state{
    
    // reload section
}


@end
