//
//  HLLAttributedBuilder.m
//  Weather_App
//
//  Created by user1 on 2017/8/24.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HLLAttributedBuilder.h"

@interface _HLLString : NSObject

@property (nonatomic ,strong) NSString * string;
@property (nonatomic ,strong) NSAttributedString * attributedString;
@property (nonatomic ,assign) NSRange range;
@property (nonatomic ,strong) NSDictionary * style;
@end
@implementation _HLLString
@end

@interface HLLAttributedBuilder (){

    NSDictionary * _defaultStyle;
    NSMutableArray * _stringObjs;
    NSMutableString * _originalString;
}

@property (nonatomic ,strong) NSDictionary * defaultStyle;
@property (nonatomic ,strong) NSMutableArray * stringObjs;
@property (nonatomic ,strong) NSMutableString * originalString;
@end

@implementation HLLAttributedBuilder

+ (instancetype)builder{

    NSDictionary * defaultStyle = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:16]};
    return [self builderWithDefaultStyle:defaultStyle];
}

+ (instancetype)builderWithDefaultStyle:(NSDictionary *)defaultStyle{

    HLLAttributedBuilder * builder = [[self alloc] init];
    builder.defaultStyle = defaultStyle;
    return builder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stringObjs = [NSMutableArray array];
        _originalString = [NSMutableString string];
    }
    return self;
}

- (HLLAttributedBuilder *)appendString:(NSString *)string{

    return [self appendString:string forStyle:self.defaultStyle];
}

- (HLLAttributedBuilder *)appendString:(NSString *)string forStyle:(NSDictionary *)style{

    NSAssert(string.length, @"请输入非nil的字符串");
    
    NSMutableDictionary * mergeStyle = [NSMutableDictionary dictionaryWithDictionary:self.defaultStyle];
    [mergeStyle addEntriesFromDictionary:style];
    
    [_originalString appendString:string];
    
    NSRange range = [_originalString rangeOfString:string];
    
    NSAttributedString * attString = [[NSAttributedString alloc] initWithString:string attributes:mergeStyle];
    
    _HLLString * stringObj = [[_HLLString alloc] init];
    stringObj.string = string;
    stringObj.attributedString = attString;
    stringObj.range = range;
    stringObj.style = mergeStyle;
    [_stringObjs addObject:stringObj];
    return self;
}

- (HLLAttributedBuilder *(^)(NSString *))appendString{

    return ^HLLAttributedBuilder *(NSString *str){
        return [self appendString:str];
    };
}

- (HLLAttributedBuilder *(^)(NSString *, NSDictionary *))appendStringAndStyle{

    return ^HLLAttributedBuilder *(NSString *str ,NSDictionary *style){
        return [self appendString:str forStyle:style];
    };;
}

- (NSAttributedString *) attributedString{

    if (_stringObjs && _stringObjs.count) {
        
        NSMutableAttributedString * output = [[NSMutableAttributedString alloc] init];
        for (_HLLString * stringObj in _stringObjs) {
            
            [output appendAttributedString:stringObj.attributedString];
        }
        return output;
    }
    return nil;
}
- (NSAttributedString *(^)())attributedStr{

    return ^NSAttributedString *(){
        return [self attributedString];
    };
}
@end

@implementation HLLAttributedBuilder (Attachment)

- (HLLAttributedBuilder *)appendAttachment:(NSTextAttachment *)attachment{
    
    NSAssert(attachment, @"请输入非nil的attachment");
    
    NSAttributedString * attString = [NSAttributedString attributedStringWithAttachment:attachment];
    _HLLString * stringObj = [[_HLLString alloc] init];
    stringObj.attributedString = attString;
    [_stringObjs addObject:stringObj];
    return self;
}

- (HLLAttributedBuilder *(^)(NSTextAttachment *))appendAttachment{

    return ^HLLAttributedBuilder *(NSTextAttachment *attachment){
    
        return [self appendAttachment:attachment];
    };
}
@end

@implementation HLLAttributedBuilder (Config)

+ (instancetype)builderWithString:(NSString *)originalString{

    NSDictionary * defaultStyle = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:16]};
    return [self builderWithString:originalString defaultStyle:defaultStyle];
}

+ (instancetype)builderWithString:(NSString *)originalString defaultStyle:(NSDictionary *)defaultStyle{

    HLLAttributedBuilder * builder = [self builderWithDefaultStyle:defaultStyle];
    return [builder appendString:originalString];
}

- (HLLAttributedBuilder *)configString:(NSString *)string forStyle:(NSDictionary *)style{

    NSAssert(string.length, @"请输入非nil的字符串");
    
    NSMutableDictionary * mergeStyle = [NSMutableDictionary dictionaryWithDictionary:self.defaultStyle];
    [mergeStyle addEntriesFromDictionary:style];

    NSAssert(self.stringObjs.count, @"请使用`builderWithString:`或者`builderWithString:defaultStyle:`初始化 HLLAttributedBuilder ");
    
    _HLLString * resultStringObj = self.stringObjs[0];
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:resultStringObj.attributedString];
    
    NSRegularExpression * regularExp = [[NSRegularExpression alloc] initWithPattern:string options:NSRegularExpressionIgnoreMetacharacters|NSRegularExpressionAnchorsMatchLines error:nil];
    NSRange originalStringRange = NSMakeRange(0, self.originalString.length);
    
    NSArray <NSTextCheckingResult *>* matches = [regularExp matchesInString:self.originalString options:NSMatchingWithTransparentBounds range:originalStringRange];
    
    for (NSTextCheckingResult * math in matches) {
        [attributedText addAttributes:mergeStyle range:math.range];
    }
    
    [self.stringObjs removeAllObjects];
    
    _HLLString * stringObj = [[_HLLString alloc] init];
    stringObj.attributedString = attributedText;
    [self.stringObjs addObject:stringObj];
    return self;
}
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) configStringAndStyle{

    return ^HLLAttributedBuilder *(NSString *str ,NSDictionary *style){
        return [self configString:str forStyle:style];
    };
}

@end
