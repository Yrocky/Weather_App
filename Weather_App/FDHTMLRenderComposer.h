//
//  FDHTMLRenderComposer.h
//  Weather_App
//
//  Created by Rocky Young on 2017/11/2.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FDHTMLRenderComposer : NSObject

- (void) renderHTML:(NSString *)month
             items:(NSArray *)items
                cb:(void(^)(NSString *html))cb;

+ (NSData *) exportPDF:(UIWebView *)webView;

+ (UIImage *) exportImage:(UIWebView *)webView;
@end

