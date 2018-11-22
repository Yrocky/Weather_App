//
//  HLLAttributedBuilder.m
//  Weather_App
//
//  Created by user1 on 2017/8/24.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HLLAttributedBuilder.h"

@implementation NSRegularExpression (RX)

- (id) initWithPattern:(NSString*)pattern
{
    return [self initWithPattern:pattern options:0 error:nil];
}

- (NSTextCheckingResult *) firstMatch:(NSString *)str{

    return [self matches:str].firstObject;
}

- (NSArray<NSTextCheckingResult *>*) matches:(NSString*)str
{
    return [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
}

- (void) enumMatches:(void(^)(NSTextCheckingResult * result,NSUInteger index))handle inString:(NSString *)string{

    NSArray * results = [self matches:string];
    if (results && results.count > 0) {

        [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (handle) {
                handle(obj,idx);
            }
        }];
    }
}
- (NSString *) replaceMatchedStringsWith:(NSString *(^)(NSString *matchedString))replace inString:(NSString *)string{
    
    __block NSMutableString * replacedString = [NSMutableString stringWithString:string];
    [self enumMatches:^(NSTextCheckingResult * _Nonnull result, NSUInteger index) {
        
        NSString * template = replace ? replace([replacedString substringWithRange:result.range]) : @"";
        // NSMatchingReportCompletion : 找到任何一个匹配串后都回调一次block
        [self replaceMatchesInString:replacedString options:NSMatchingReportCompletion
                               range:result.range withTemplate:template];
    } inString:string];
    return replacedString.copy;
}
@end

@interface _HLLString : NSObject

@property (nonatomic ,copy) NSString * string;
@property (nonatomic ,strong) NSAttributedString * attributedString;
@property (nonatomic ,assign) NSRange range;
@property (nonatomic ,strong) NSDictionary * style;
@end

@implementation _HLLString
- (void)dealloc {
    NSLog(@"_HLLString:%@/%@ dealloc",self.string,self.attributedString);
}
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

- (void)dealloc {
    NSLog(@"HLLAttributedBuilder:%@ dealloc",self.originalString);
}

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
    @autoreleasepool {
        
        NSMutableDictionary * mergeStyle = [NSMutableDictionary dictionaryWithDictionary:self.defaultStyle];
        [mergeStyle addEntriesFromDictionary:style];
        
        NSRange range = NSMakeRange(_originalString.length - 1, string.length);

        [_originalString appendString:string];
        
        NSAttributedString * attString = [[NSAttributedString alloc] initWithString:string attributes:mergeStyle];
        
        _HLLString * stringObj = [[_HLLString alloc] init];
        stringObj.string = string;
        stringObj.attributedString = attString;
        stringObj.range = range;
        stringObj.style = mergeStyle;
        [_stringObjs addObject:stringObj];
    }
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

- (HLLAttributedBuilder *) _config:(NSString *)string style:(NSDictionary *)style isFirstMatch:(BOOL)firstMatch{

    NSAssert(string.length, @"请输入非nil的字符串");
    
    NSMutableDictionary * mergeStyle = [NSMutableDictionary dictionaryWithDictionary:self.defaultStyle];
    [mergeStyle addEntriesFromDictionary:style];
    
    NSAssert(self.stringObjs.count, @"请使用`builderWithString:`或者`builderWithString:defaultStyle:`初始化 HLLAttributedBuilder ");
    
    _HLLString * resultStringObj = self.stringObjs[0];
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:resultStringObj.attributedString];
    if (firstMatch) {
        NSTextCheckingResult * result = [RX(string) firstMatch:self.originalString];
        [attributedText addAttributes:mergeStyle range:result.range];
    }else{
        [RX(string) enumMatches:^(NSTextCheckingResult *result, NSUInteger index) {
            
            [attributedText addAttributes:mergeStyle range:result.range];
            
        } inString:self.originalString];
    }
    
    [self.stringObjs removeAllObjects];
    
    _HLLString * stringObj = [[_HLLString alloc] init];
    stringObj.attributedString = attributedText;
    [self.stringObjs addObject:stringObj];
    return self;
}

- (HLLAttributedBuilder *)configString:(NSString *)string forStyle:(NSDictionary *)style{

    return [self _config:string style:style isFirstMatch:NO];
}

- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) configStringAndStyle{

    return ^HLLAttributedBuilder *(NSString *str ,NSDictionary *style){
        return [self configString:str forStyle:style];
    };
}

- (HLLAttributedBuilder *) firstConfigString:(NSString *)string forStyle:(NSDictionary *)style{

    return [self _config:string style:style isFirstMatch:YES];
}

- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) firstConfigStringAndStyle{
    return ^HLLAttributedBuilder *(NSString *str ,NSDictionary *style){
        return [self firstConfigString:str forStyle:style];
    };
}
@end
