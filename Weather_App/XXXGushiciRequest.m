//
//  XXXGushiciRequest.m
//  Weather_App
//
//  Created by meme-rocky on 2019/1/22.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXGushiciRequest.h"
#import "NSString+Exten.h"

@implementation XXXGushiciWrap

- (instancetype) initWithJsonData:(id)jsonData{
    self = [super init];
    if (self) {
        _author = jsonData[@"author"];
        _content = jsonData[@"content"];
        _origin = jsonData[@"origin"];
        _category = jsonData[@"category"];
    }
    return self;
}
- (NSArray<NSString *> *)categorys{
    if (self.category.length) {
        return [self.category componentsSeparatedByString:@"-"];
    }
    return nil;
}

- (NSArray<NSString *> *)contents{
    if (self.content.length) {
        return [self.content separatedByStrings:@[@",", @"。", @",", @";", @"；", @"."] contained:YES];
    }
    return nil;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"author:%@\tconent:%@", self.author,self.content];
}
@end

@implementation XXXGushiciRequest

- (void)dealloc
{
    NSLog(@"XXXGushiciRequest dealloc");
}
- (NSString *)baseUrl{
    return @"https://api.gushi.ci";
}

- (NSString *)requestUrl{
    return @"all.json";
}

- (void)requestCompletePreprocessor{
    _gushici = [[XXXGushiciWrap alloc] initWithJsonData:self.responseObject];
}

- (id) mapModelWithJsonData:(id)jsonData{
    return [[XXXGushiciWrap alloc] initWithJsonData:jsonData];
}

@end
