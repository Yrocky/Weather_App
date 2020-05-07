//
//  MarkdownRenderHTMLViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/11/3.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MarkdownRenderHTMLViewController.h"
#import "Masonry.h"
#import "HLLPlaceholderTextView.h"
#import <MMMarkdown/MMMarkdown.h>
#import "HLLAlert.h"

@interface MarkdownRenderHTMLViewController ()

@property (nonatomic ,strong) UIPlaceholderTextView * textView;
@property (nonatomic ,strong) UIWebView * webView;

@end

@implementation MarkdownRenderHTMLViewController

- (NSArray *)_lineRangesForString:(NSString *)aString
{
    NSMutableArray *result = [NSMutableArray array];
    
    NSUInteger location = 0;
    NSUInteger idx;
    for (idx=0; idx<aString.length; idx++)
    {
        unichar character = [aString characterAtIndex:idx];
        if (character == '\r' || character == '\n')
        {
            NSRange range = NSMakeRange(location, idx-location);
            [result addObject:[NSValue valueWithRange:range]];
            
            // If it's a carriage return, check for a line feed too
            if (character == '\r')
            {
                if (idx + 1 < aString.length && [aString characterAtIndex:idx + 1] == '\n')
                {
                    idx += 1;
                }
            }
            
            location = idx + 1;
        }
    }
    
    // Add the final line if the string doesn't end with a newline
    if (location < aString.length)
    {
        NSRange range = NSMakeRange(location, aString.length-location);
        [result addObject:[NSValue valueWithRange:range]];
    }
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Render HTML";
    
    NSArray * tmo = [self _lineRangesForString:({
        @"11111111\n222222222222\n333\n4444444444444\n55\n6666666\n7777777777\n88888888888888\n";
    })];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.00];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Render" style:UIBarButtonItemStylePlain target:self action:@selector(renderHTML)]];
    
    self.textView = [[UIPlaceholderTextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.layer.borderWidth = 1;
    if (@available(iOS 11.0, *)) {
        self.textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.textView.layer.borderColor = [UIColor redColor].CGColor;
    self.textView.placeholder = @"Input here";
    [self.view addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor orangeColor];
    self.webView.scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview: self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.textView);
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    
    NSArray * array = self.view.layoutGuides;
    
}

- (void)renderHTML {

    __weak typeof(self) weakSelf = self;

    [[[[HLLAlertUtil title:@"确认渲染？"] buttons:@[@"Done"]]
      fetchClick:^(NSInteger index) {
          NSLog(@"index");
          NSError * error;
          NSString * HTMLContent = [MMMarkdown HTMLStringWithMarkdown:weakSelf.textView.text
                                                           extensions:MMMarkdownExtensionsGitHubFlavored
                                                                error:&error];
          if (!error) {
              [weakSelf.webView loadHTMLString:HTMLContent baseURL:nil];
          }else{
              id<HLLAlertActionSheetProtocol> alert = [[HLLAlertUtil message:error.localizedDescription] showIn:self];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [alert dismiss];
              });
          }
      }] showIn:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
