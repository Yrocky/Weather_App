//
//  QLLiveLayoutCalculator.m
//  Weather_App
//
//  Created by rocky on 2020/8/9.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "QLLiveLayoutCalculator.h"
#import <UIKit/UIKit.h>

@interface QLLiveLayoutCalculator ()
@property (nonatomic ,strong) NSMutableArray * rowWidths;
@property (nonatomic ,assign) UIEdgeInsets edgeInsets;
@property (nonatomic ,assign) CGFloat rowMargin;
@property (nonatomic ,assign) CGFloat columnMargin;
@property (nonatomic ,assign) CGFloat maxRowWidth;

@property (nonatomic ,strong) NSMutableArray * rowHeights;
@property (nonatomic ,assign) CGFloat maxRowHeight;
@end
@implementation QLLiveLayoutCalculator

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.justifyContent = QLLiveFlexLayoutFlexStart;
        self.itemSpacing = 10;
        self.lineSpacing = 10;
        self.flexHeight = 30;
        
        self.renderDirection = QLLiveWaterfallLayoutRenderShortestFirst;
        
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.maxRowWidth = self.maxRowHeight =
        self.rowMargin = self.columnMargin = 0.0f;

        self.rowWidths = [NSMutableArray new];
        for (NSInteger i = 0; i < 2; i++) {
            [self.rowWidths addObject:@(self.edgeInsets.left)];
        }

        self.rowHeights = [NSMutableArray new];
        for (NSInteger i = 0; i < 4; i++) {
            [self.rowHeights addObject:@(self.edgeInsets.top)];
        }
    }
    return self;
}

- (NSArray<NSValue *> *) calculatorWith:(NSArray<NSValue *> *)items{

    CGFloat collectionH = 3 * 414/4 ;
    NSMutableArray * tmp = [NSMutableArray new];
    for (NSInteger index = 0; index < items.count; index ++) {

        CGSize size = items[index].CGSizeValue;

        CGFloat h = size.height;
        CGFloat w = size.width;

        CGFloat x = 0;
        CGFloat y = 0;

        //找出宽度最短的那一行
        NSInteger destRow = 0;
        CGFloat minRowWidth = [self.rowWidths[destRow] doubleValue];
        for (NSInteger i = 1; i < self.rowWidths.count; i++) {
            //取出第i行
            CGFloat rowWidth = [self.rowWidths[i] doubleValue];
            if (minRowWidth > rowWidth) {
                minRowWidth = rowWidth;
                destRow = i;
            }
        }

        // h需要的是前一行的最大y
        y = destRow == 0 ? self.edgeInsets.top : self.edgeInsets.top + h + self.rowMargin;

        x = [self.rowWidths[destRow] doubleValue] == self.edgeInsets.left ? self.edgeInsets.left : [self.rowWidths[destRow] doubleValue] + self.columnMargin;
        //更新最短那行的宽度
        if (h >= collectionH - self.edgeInsets.bottom - self.edgeInsets.top) {
            x = [self.rowWidths[destRow] doubleValue] == self.edgeInsets.left ?
            self.edgeInsets.left :
            self.maxRowWidth + self.columnMargin;
            for (NSInteger i = 0; i < 2; i++) {
                self.rowWidths[i] = @(x + w);
            }
        }else{
            self.rowWidths[destRow] = @(x + w);
        }
        //记录最大宽度
        if (self.maxRowWidth < x + w) {
            self.maxRowWidth = x + w ;
        }

        [tmp addObject:[NSValue valueWithCGRect:(CGRect){
            x,y,w,h
        }]];
    }
    return tmp;
}

- (NSArray<NSValue *> *) calculatorFlexLayoutWith:(NSArray<NSNumber *> *)items{
    
    CGFloat maxWidth = 0.0f;
    NSMutableArray<NSValue *> * result = [NSMutableArray new];
    
    NSMutableArray<NSMutableArray<NSValue *> *> * lines = [NSMutableArray new];
    NSMutableArray<NSValue *> * line = [NSMutableArray new];
    [lines addObject:line];
    NSInteger lineNumber = 1;
    
    for (NSInteger index = 0; index < items.count; index ++) {
        CGFloat itemWidth = items[index].floatValue;
        CGSize itemSize = (CGSize){
            MIN(self.containerWidth, itemWidth),
            self.flexHeight
        };
        
        NSLog(@"[cal] itemSize:%@",NSStringFromCGSize(itemSize));
        maxWidth += (itemSize.width + self.itemSpacing);
        
        if ((maxWidth - self.itemSpacing) > self.containerWidth) {
            CGFloat currentLineMaxWidth = maxWidth - self.itemSpacing * 2 - itemSize.width;
            [self _calculatorFlexLayoutLineMaxWidth:currentLineMaxWidth
                                              line:line
                                        lineNumber:lineNumber
                                            result:result];
            maxWidth = itemSize.width + self.itemSpacing;
            [lines removeObject:line];
            line = [NSMutableArray new];
            [lines addObject:line];
            lineNumber ++;
        }
        [line addObject:[NSValue valueWithCGSize:itemSize]];
    }
    if (line.count) {
        // 最后一行
        [self _calculatorFlexLayoutLineMaxWidth:maxWidth - self.itemSpacing
                                          line:line
                                    lineNumber:lineNumber
                                        result:result];
    }
    NSLog(@"line number:%d",lineNumber);
    return result;
}

- (void) _calculatorFlexLayoutLineMaxWidth:(CGFloat)lineMaxWidth line:(NSMutableArray<NSValue *> *)line lineNumber:(NSInteger)lineNumber result:(NSMutableArray<NSValue *> *)result{
    /*
     |<--spacing1-->口<-itemSpacing->口<--spacing2-->|
     lineMaxWidth: 口+口+itemSpacing
     totalSpacing: spacing1 + spacing2 + itemSpacing
     totalItemsWidth: = 口+口
    */
    CGFloat totalSpacing = self.containerWidth - lineMaxWidth + (line.count - 1) * self.itemSpacing;
    CGFloat totalItemsWidth = lineMaxWidth - (line.count - 1) * self.itemSpacing;

    __block CGFloat preItemX = 0.0f;
    if (self.justifyContent == QLLiveFlexLayoutFlexEnd) {
        preItemX = self.containerWidth - lineMaxWidth;
    } else if (self.justifyContent == QLLiveFlexLayoutCenter) {
        preItemX = (self.containerWidth - lineMaxWidth) / 2.0;
    } else if (self.justifyContent == QLLiveFlexLayoutSpaceAround){
        preItemX = (self.containerWidth - totalItemsWidth) / (line.count + 1);
    }
    // 为line中的元素进行布局
    [line enumerateObjectsUsingBlock:^(NSValue * item, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize innerItemSize = item.CGSizeValue;
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        if (self.justifyContent == QLLiveFlexLayoutFlexStart ||
            self.justifyContent == QLLiveFlexLayoutFlexEnd ||
            self.justifyContent == QLLiveFlexLayoutCenter) {
            x = preItemX;
            preItemX += (innerItemSize.width + self.itemSpacing);
        } else if (self.justifyContent == QLLiveFlexLayoutSpaceBetween){
            x = preItemX;
            preItemX += (innerItemSize.width + totalSpacing / (line.count - 1));
        } else {
            x = preItemX;
            preItemX += (innerItemSize.width + totalSpacing / (line.count + 1));
        }
        y = (lineNumber - 1) * (innerItemSize.height + self.lineSpacing);
        [result addObject:[NSValue valueWithCGRect:(CGRect){
            CGPointMake(x, y), innerItemSize
        }]];
    }];
}

- (NSArray<NSValue *> *) calculatorListLayoutWith:(NSArray *)items{
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (self.distribution.isAbsolute) {
        width = self.distribution.value;
    } else if (self.distribution.isFractional) {
        width = self.containerWidth * MIN(1, self.distribution.value);
    } else {
        NSInteger count = MAX(1, self.distribution.value);
        width = (self.containerWidth - (count - 1) * self.itemSpacing) / count;
    }
    // itemRatio -> height
    if (nil == self.itemRatio) {
        self.itemRatio = [QLLiveLayoutItemRatio itemRatioValue:1];
    }
    if (self.itemRatio.isAbsolute) {
        height = self.itemRatio.value;
    } else {
        height = width / MAX(0.01, self.itemRatio.value);
    }
    
    NSMutableArray<NSValue *> * result = [NSMutableArray new];
    __block CGFloat maxY = 0.0f;
    __block CGFloat maxX = 0.0f;
    
    for (NSInteger index = 0; index < items.count; index ++) {
        CGFloat x = maxX;
        CGFloat y = maxY;
        [result addObject:[NSValue valueWithCGRect:(CGRect){
            x,y,width,height
        }]];
        maxX += (width + self.itemSpacing);
        if (maxX > self.containerWidth) {
            maxX = 0;
            maxY += (height + self.lineSpacing);
        }
    }
    return result;
}

- (NSArray<NSValue *> *) calculatorWaterfallLayoutWith:(NSArray<NSNumber *> *)items{
    
    // 初始化每一列的最大值,最终这里应该是一个二维数组，根据section来装不同的最大高度
    self.columnHeights = [NSMutableArray new];
    for (NSInteger index = 0; index < self.column; index ++) {
        [self.columnHeights addObject:@(0)];
    }
    
    CGFloat width = (self.containerWidth - (self.column - 1) * self.itemSpacing) / self.column;
    CGFloat height = 0.0f;
    NSMutableArray<NSValue *> * result = [NSMutableArray new];

    for (NSInteger index = 0; index < items.count; index ++) {
        height = items[index].floatValue;
        NSUInteger columnIndex = [self nextColumnIndexForItem:index];

        CGFloat x = (width + self.itemSpacing) * columnIndex;
        CGFloat y = [self.columnHeights[columnIndex] floatValue];
        CGRect frame = CGRectMake(x, y, width, height);
        self.columnHeights[columnIndex] = @(CGRectGetMaxY(frame) + self.lineSpacing);

        [result addObject:[NSValue valueWithCGRect:frame]];
    }
    return result;
}

- (NSUInteger)nextColumnIndexForItem:(NSInteger)item {
    
    NSUInteger index = 0;
    if (self.renderDirection == QLLiveWaterfallLayoutRenderLeftToRight) {
        index = (item % self.column);
    } else if (self.renderDirection == QLLiveWaterfallLayoutRenderRightToLeft) {
        index = (self.column - 1) - (item % self.column);
    } else {
        index = [self shortestColumnIndex];
    }
    return index;
}

- (NSUInteger)shortestColumnIndex{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    return index;
}
@end


typedef NS_ENUM(NSUInteger, QLLiveLayoutSemantic) {
    
    QLLiveLayoutSemanticNormal,
    
    QLLiveLayoutSemanticEmbed,
    QLLiveLayoutSemanticAbsolute,
    QLLiveLayoutSemanticFractional,
};

@interface QLLiveLayoutDistribution()
@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic) QLLiveLayoutSemantic semantic;
@end

@implementation QLLiveLayoutDistribution

+ (instancetype)distributionValue:(NSInteger)value{
    return [[self alloc] initWithDistribution:(CGFloat)value
                                     semantic:QLLiveLayoutSemanticNormal];
}
+ (instancetype)absoluteDimension:(CGFloat)value{
    return [[self alloc] initWithDistribution:value
                                     semantic:QLLiveLayoutSemanticAbsolute];
}
+ (instancetype)fractionalDimension:(CGFloat)value{
    return [[self alloc] initWithDistribution:value
                                     semantic:QLLiveLayoutSemanticFractional];
}
- (instancetype)initWithDistribution:(CGFloat)distribution semantic:(QLLiveLayoutSemantic)semantic {

    self = [super init];
    if (self) {
        self.value = distribution;
        self.semantic = semantic;
    }
    return self;
}

- (BOOL)isEmbed{
    return self.semantic == QLLiveLayoutSemanticEmbed;
}

- (BOOL)isAbsolute{
    return self.semantic == QLLiveLayoutSemanticAbsolute;
}

- (BOOL)isFractional{
    return self.semantic == QLLiveLayoutSemanticFractional;
}

@end

@interface QLLiveLayoutItemRatio ()

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic) QLLiveLayoutSemantic semantic;

@end
@implementation QLLiveLayoutItemRatio

+ (instancetype)itemRatioValue:(CGFloat)value{
    if (value <= 0) {
        return nil;
    }
    return [[self alloc] initWithItemRatio:value semantic:QLLiveLayoutSemanticNormal];
}

+ (instancetype)absoluteValue:(CGFloat)value{
    if (value <= 0) {
        return nil;
    }
    return [[self alloc] initWithItemRatio:value semantic:QLLiveLayoutSemanticAbsolute];
}

- (instancetype)initWithItemRatio:(CGFloat)itemRatio semantic:(QLLiveLayoutSemantic)semantic {

    self = [super init];
    if (self) {
        self.value = itemRatio;
        self.semantic = semantic;
    }
    return self;;
}

- (BOOL)isAbsolute{
    return self.semantic == QLLiveLayoutSemanticAbsolute;
}
@end
