//
//  BillImageExtensionView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "BillImageExtensionView.h"
#import "Masonry.h"
#import "HLLAlert.h"

@interface _BillImageView : UIView

@property (strong, nonatomic) UIImageView * imageView;
@property (nonatomic ,strong) UIButton * deleteButton;

@property (nonatomic ,copy) void(^bTapAction)();
@end

@implementation _BillImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 10;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20,20));
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_top);
        }];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void) onImageViewTapAction{
    if (self.bTapAction) {
        self.bTapAction();
    }
}
@end

@interface BillImageExtensionView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (readwrite) NSMutableArray * images;
@property (nonatomic ,strong) UIStackView * imageContentView;
@property (strong, nonatomic) _BillImageView * addImageView;
@property (nonatomic ,strong) MASConstraint * imageContentViewWidthConstraint;
@end

@implementation BillImageExtensionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.images = [NSMutableArray array];
        
        self.imageContentView = [[UIStackView alloc] init];
        self.imageContentView.axis = UILayoutConstraintAxisHorizontal;
        self.imageContentView.distribution = UIStackViewDistributionFillEqually;
        self.imageContentView.alignment = UIStackViewAlignmentCenter;
        self.imageContentView.spacing = 10;
        self.imageContentView.backgroundColor = [UIColor redColor];
        [self addSubview:self.imageContentView];
        [self.imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageContentView.spacing);
            make.right.mas_equalTo(self.mas_right).mas_offset(-self.imageContentView.spacing).priorityLow();
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(100);
            self.imageContentViewWidthConstraint = make.width.mas_equalTo(100);
        }];
        
        __weak typeof(self) weakSelf = self;
        self.addImageView = [[_BillImageView alloc] initWithFrame:(CGRect){
            CGPointZero,
            {100,100}
        }];
        self.addImageView.imageView.image = [UIImage imageNamed:@"sunset"];
        self.addImageView.deleteButton.hidden = YES;
        self.addImageView.bTapAction = ^(){
            [weakSelf onAddImageAction];
        };
        [self.imageContentView addArrangedSubview:self.addImageView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    NSInteger imageCount = self.images.count;
    CGFloat totalWidth = 0;
    
    if (imageCount > 3) {// 4
        totalWidth = imageCount * 100 + (imageCount - 1) * self.imageContentView.spacing;
    }else {
        totalWidth = (imageCount + 1) * 100 + imageCount * self.imageContentView.spacing;
    }
    totalWidth += 2 * self.imageContentView.spacing;
    self.contentSize = (CGSize){
        totalWidth,
        self.frame.size.height
    };
}

- (void)configImages:(NSArray *)images{

    [self.images removeAllObjects];
    for (UIImage * image in images) {
        [self addImageViewWith:image];
    }
}

- (void) addImageViewWith:(UIImage *)image{
    
    [self.images addObject:image];
    
    _BillImageView * imageView = [[_BillImageView alloc] init];
    imageView.imageView.image = image;
    imageView.bounds = (CGRect){
        CGPointZero,
        {100, 100}
    };
    [imageView.deleteButton addTarget:self
                               action:@selector(onDeleteImageAction:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.imageContentView insertArrangedSubview:imageView atIndex:0];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self updateImageContentViewWidthConstraint];
    } completion:nil];
}

- (void) onDeleteImageAction:(UIButton *)button{
    
    _BillImageView * superView = (_BillImageView *)button.superview;
    [self.images removeObject:superView.imageView.image];
    [self.imageContentView removeArrangedSubview:button.superview];
    [UIView animateWithDuration:0.25 animations:^{
        [self updateImageContentViewWidthConstraint];
    }];
}

- (void) onAddImageAction{
    
    [[[[[HLLAlertActionSheet actionSheet] buttons:@[@"拍照",@"从相册选一张",@"取消"]]style:UIAlertActionStyleCancel index:2] fetchClick:^(NSInteger buttonIndex) {
        
        void (^PickPhotoHandle)(UIImagePickerControllerSourceType sourceType) =
        ^void (UIImagePickerControllerSourceType sourceType){
            
            UIImagePickerController *picker =[[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[HLLAlertActionSheet getPresentedViewController] presentViewController:picker animated:YES completion:nil];
            }];
        };
        
        if (buttonIndex == 0)
        {
            //判断相机是否可以使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                PickPhotoHandle(UIImagePickerControllerSourceTypeCamera);
            }else{
                //                [self showTipByMessage:@"请检查是否打开了相机权限，您可以进入系统“设置>隐私>相机“,允许****访问您的相机。"];
            }
        }
        if (buttonIndex == 1)
        {
            PickPhotoHandle(UIImagePickerControllerSourceTypeSavedPhotosAlbum);
        }
        
    }] show];
}

- (void) updateImageContentViewWidthConstraint{
    
    NSInteger imageCount = self.images.count;
    
    if (imageCount > 3) {
        self.addImageView.alpha = 0;
        [self.imageContentView removeArrangedSubview:self.addImageView];
    }else{
        self.addImageView.alpha = 1;
        [self.imageContentView insertArrangedSubview:self.addImageView atIndex:imageCount];
    }
    
    if (imageCount > 3) {// 4
        self.imageContentViewWidthConstraint.mas_equalTo(imageCount * 100 + (imageCount - 1) * self.imageContentView.spacing);
    }else {
        self.imageContentViewWidthConstraint.mas_equalTo((imageCount + 1) * 100 + imageCount * self.imageContentView.spacing);
    }
    [self layoutIfNeeded];
}

#pragma mark - 照片选取
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image=[[UIImage alloc]init];
    if (picker.allowsEditing == YES) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //对照片进行裁剪 防止照片过大
    UIGraphicsBeginImageContext(CGSizeMake(200,200));
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self addImageViewWith:image];
    }];
}
@end
