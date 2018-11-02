//
//  FDHTMLRenderComposer.m
//  Weather_App
//
//  Created by Rocky Young on 2017/11/2.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDHTMLRenderComposer.h"
#import "MMGCD.h"
#import "NSArray+Sugar.h"

@interface FDPDFPrintPageRenderer : UIPrintPageRenderer
@end

@interface FDHTMLRenderComposer()

@property (nonatomic ,strong) NSString * pathToHTMLTemplate;
@property (nonatomic ,strong) NSString * pathToSingleItemHTMLTemplate;

@end

@implementation FDHTMLRenderComposer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pathToHTMLTemplate = [[NSBundle mainBundle] pathForResource:@"rootTemplate" ofType:@"html"];
        self.pathToSingleItemHTMLTemplate = [[NSBundle mainBundle] pathForResource:@"singleItemTemplate" ofType:@"html"];
    }
    return self;
}

- (void) renderHTML:(NSString *)month items:(NSArray *)items cb:(void(^)(NSString *html))cb{
    
    __block NSString * HTMLContent = [NSString stringWithContentsOfFile:self.pathToHTMLTemplate
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];
    __block NSString * itemsContent = [NSString stringWithContentsOfFile:self.pathToSingleItemHTMLTemplate
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
    [[MMGCDQueue globalQueue] execute:^{
        
        //
        HTMLContent = [HTMLContent stringByReplacingOccurrencesOfString:@"#FISHDAILY_MONTH#" withString:month];
        
        //
        NSMutableString * itemsContentString = [[NSMutableString alloc] init];
        [items mm_each:^(id item) {
            
            [itemsContentString appendString:({
                NSString * s = [itemsContent stringByReplacingOccurrencesOfString:@"#FISHDAILY_ITEM#" withString:item];
                s;
            })];
        }];
        
        //
        HTMLContent = [HTMLContent stringByReplacingOccurrencesOfString:@"#FISHDAILY_ITEMS#" withString:itemsContentString];
        
        [[MMGCDQueue mainQueue] execute:^{
            
            if (cb) {
                cb(HTMLContent);
            }
        }];
    }];
}

+ (NSData *) exportPDF:(UIWebView *)webView{
    
    UIViewPrintFormatter *fmt = [webView viewPrintFormatter];
    
    FDPDFPrintPageRenderer *render = [[FDPDFPrintPageRenderer alloc] init];
    [render addPrintFormatter:fmt startingAtPageAtIndex:0];
    
    NSMutableData * pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );
    
    for (NSInteger i=0; i < [render numberOfPages]; i++)
    {
        UIGraphicsBeginPDFPage();
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        [render drawPageAtIndex:i inRect:bounds];
        
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}

+ (UIImage *) exportImage:(UIWebView *)webView{
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize boundsSize = webView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize contentSize = webView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    
    CGPoint offset = webView.scrollView.contentOffset;
    
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);
        [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = webView.scrollView.contentOffset.y;
        [webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    
    [webView.scrollView setContentOffset:offset];
    
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
}

@end

static CGFloat kA4PageWidth = 595.2;
static CGFloat kA4PageHeight = 841.8;

@implementation FDPDFPrintPageRenderer

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 指定 A4 纸的尺寸
        CGRect pageFrame = (CGRect){
            CGPointZero,
            kA4PageWidth, kA4PageHeight
        };
        // 设定页面的尺寸
        [self setValue:[NSValue valueWithCGRect:pageFrame] forKey:@"paperRect"];
        
        // 设定水平和垂直的缩进（这一步是可选的）
        [self setValue:[NSValue valueWithCGRect:pageFrame] forKey:@"printableRect"];
    }
    return self;
}

@end
