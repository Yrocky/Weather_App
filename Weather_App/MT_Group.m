//
//  MT_Group.m
//  Weather_App
//
//  Created by rocky on 2020/12/7.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MT_Group.h"

@interface MT_Group ()

@end

@implementation MT_Group

+ (MT_Group * _Nonnull (^)(NSArray<id<MT_Component>> * _Nonnull))create{
    
    return ^MT_Group *(NSArray<id<MT_Component>> * componets){
//        return [[self alloc] initWithComponent:componet];
        return nil;
    };
}

//MT_CellNode.create(Address.create(self.dataForm.address)),
//MT_CellNode.create(AddressPicker.create(self.dataForm.addressOptions)),

@end
