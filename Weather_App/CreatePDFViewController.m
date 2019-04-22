//
//  CreatePDFViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/11/2.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "CreatePDFViewController.h"
#import "FDHTMLRenderComposer.h"
#import "Masonry.h"
#import "MMGCD.h"

@interface CreatePDFViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic ,strong) UIDocumentInteractionController *docInteractionController;

@property (nonatomic ,strong) FDHTMLRenderComposer * renderComposer;
@property (nonatomic ,strong) UIWebView * webView;
@end

@implementation CreatePDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.title = @"Export PDF";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.00];

    MMGCDGroup * group = [MMGCDGroup new];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"PDF" style:UIBarButtonItemStylePlain target:self action:@selector(exportPDF)],[[UIBarButtonItem alloc] initWithTitle:@"PNG" style:UIBarButtonItemStylePlain target:self action:@selector(exportImage)]];
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    NSMutableArray * arr = [NSMutableArray array];
    for (NSInteger index = 0; index < 50; index ++) {
        if (index % 2) {
            [arr addObject:[NSString stringWithFormat:@"This is This is This is This is This is This is This is This is This is This is This is This is This is This is This is This is This is This is This is %ld",(long)index]];
        }else{
            [arr addObject:[NSString stringWithFormat:@"This is %ld",(long)index]];
        }
    }
    
    //
    self.renderComposer = [[FDHTMLRenderComposer alloc] init];
    [self.renderComposer renderHTML:@"2017年" items:arr cb:^(NSString *html) {
        [self.webView loadHTMLString:html baseURL:nil];
    }];
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://music.163.com/playlist/817223072/10440591?userid=10440591"]]];
    //
    self.docInteractionController = [[UIDocumentInteractionController alloc] init];
    self.docInteractionController.delegate = self;
}

- (void) exportPDF{
    
    NSData *pdfData = [FDHTMLRenderComposer exportPDF:self.webView];
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * time = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSString *pdfPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",time]];
    BOOL result = [pdfData writeToFile:pdfPath atomically:YES];
    if (result) {
        _docInteractionController.URL = [NSURL fileURLWithPath:pdfPath];
        [_docInteractionController presentPreviewAnimated:YES];
    }
}

- (void) exportImage{
    
    UIImage *image = [FDHTMLRenderComposer exportImage:self.webView];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * time = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",time]];
    BOOL result = [imageData writeToFile:imagePath atomically:YES];
    if (result) {
        _docInteractionController.URL = [NSURL fileURLWithPath:imagePath];
        [_docInteractionController presentPreviewAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIDocumentInteractionControllerDelegate Methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
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
