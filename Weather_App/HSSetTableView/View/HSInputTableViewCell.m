//
//  HSInputTableViewCell.m
//  PointChat
//
//  Created by Rocky Young on 2017/10/6.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HSInputTableViewCell.h"
#import "HSInputCellModel.h"
#import "HSSetTableViewControllerConst.h"
#import "HLLPlaceholderTextView.h"

@interface HSInputTableViewCell ()<UITextFieldDelegate>
@property (nonatomic ,strong) UITextField * inputTextField;
@property (nonatomic, weak)NSLayoutConstraint *inputRightConstaint;  ///<
@property (nonatomic, weak)NSLayoutConstraint *inputLeftConstaint;  ///<
@end

@implementation HSInputTableViewCell

//cell初始化方法
+ (HSBaseTableViewCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView;
{
    HSInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[HSInputTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setupUI
{
    [super setupUI];
    //添加输入框控件
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputTextField.delegate = self;
    [inputTextField addTarget:self action:@selector(inputTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
    inputTextField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:inputTextField];
    self.inputTextField = inputTextField;
    
    [self setupInputItemConstrnts];
}

- (void)setupInputItemConstrnts
{
    NSLayoutConstraint *inputRightConstaint = [NSLayoutConstraint constraintWithItem:self.inputTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant: -HS_KCellMargin];
    [self.contentView addConstraint:inputRightConstaint];
    self.inputRightConstaint = inputRightConstaint;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.inputTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    NSLayoutConstraint *inputLeftConstaint = [NSLayoutConstraint constraintWithItem:self.inputTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:HS_KCellMargin];
    [self.contentView addConstraint:inputLeftConstaint];
    self.inputLeftConstaint = inputLeftConstaint;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.inputTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:HS_KSwitchHeight]];
}

- (void)setupDataModel:(HSBaseCellModel *)model
{
    [super setupDataModel:model];
    HSInputCellModel *inputModel = (HSInputCellModel *)model;
    
    self.inputTextField.keyboardType = inputModel.keyboardType;
    self.inputTextField.placeholder = inputModel.placeholder;
    self.inputTextField.text = inputModel.inputText;
    self.inputTextField.font = inputModel.inputTextFont;
    self.inputTextField.textColor = inputModel.inputTextColor;
    
    CGFloat rightMargin = -inputModel.controlRightOffset - (inputModel.showArrow ? inputModel.arrowControlRightOffset : 0);
    self.inputRightConstaint.constant = rightMargin;
    
    CGFloat leftMargin = [inputModel.title sizeWithAttributes:@{NSFontAttributeName:inputModel.titleFont}].width + HS_KCellMargin + 12;
    self.inputLeftConstaint.constant = inputModel.title == nil ? HS_KCellMargin : leftMargin;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{

    [self textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    HSInputCellModel * inputModel = (HSInputCellModel *)self.cellModel;
    if (inputModel.doneBlock) {
        inputModel.doneBlock(inputModel, textField.text);
    }
    return YES;
}

- (void) inputTextFieldDidChange:(UITextField *)textField{
    
    HSInputCellModel * inputModel = (HSInputCellModel *)self.cellModel;
    inputModel.inputText = textField.text;
}

@end

@interface HSInputTextTableViewCell ()<UITextViewDelegate>
@property (nonatomic ,strong) UILimitTextView * inputTextView;
@property (nonatomic, weak)NSLayoutConstraint *inputRightConstaint;  ///<
@property (nonatomic, weak)NSLayoutConstraint *inputLeftConstaint;  ///<
@end

@implementation HSInputTextTableViewCell

//cell初始化方法
+ (HSBaseTableViewCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView;
{
    HSInputTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[HSInputTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setupUI
{
    [super setupUI];
    //添加输入框控件
    UILimitTextView *inputTextView = [[UILimitTextView alloc] initWithFrame:CGRectZero];
    inputTextView.delegate = self;
    inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    inputTextView.returnKeyType = UIReturnKeyDone;
    inputTextView.layer.masksToBounds = YES;
    inputTextView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    inputTextView.textContainerInset = UIEdgeInsetsMake(0,0,5,0);
    [self.contentView addSubview:inputTextView];
    self.inputTextView = inputTextView;
    
    [self setupInputItemConstrnts];
}

- (void)setupInputItemConstrnts
{
    NSLayoutConstraint *inputRightConstaint = [NSLayoutConstraint constraintWithItem:self.inputTextView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant: -HS_KCellMargin];
    [self.contentView addConstraint:inputRightConstaint];
    self.inputRightConstaint = inputRightConstaint;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.inputTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    NSLayoutConstraint *inputLeftConstaint = [NSLayoutConstraint constraintWithItem:self.inputTextView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:HS_KCellMargin - 5];
    [self.contentView addConstraint:inputLeftConstaint];
    self.inputLeftConstaint = inputLeftConstaint;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.inputTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.inputTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.inputTextView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}

- (void)setupDataModel:(HSBaseCellModel *)model
{
    [super setupDataModel:model];
    HSInputTextCellModel *inputModel = (HSInputTextCellModel *)model;
    
    self.inputTextView.keyboardType = inputModel.keyboardType;
    self.inputTextView.text = inputModel.inputText;
    self.inputTextView.font = inputModel.inputTextFont;
    self.inputTextView.textColor = inputModel.inputTextColor;
    self.inputTextView.layer.cornerRadius = inputModel.inputTextCornerRadius;
    self.inputTextView.placeholder = inputModel.placeholder;
    self.inputTextView.placeholderColor = inputModel.placeholderColor;
    
    if (inputModel.haveBorder) {
        self.inputTextView.layer.borderColor = inputModel.inputTextBorderColor.CGColor;
    }else{
        self.inputTextView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    CGFloat rightMargin = -inputModel.controlRightOffset - (inputModel.showArrow ? inputModel.arrowControlRightOffset : 0);
    self.inputRightConstaint.constant = rightMargin;
    
    CGFloat leftMargin = [inputModel.title sizeWithAttributes:@{NSFontAttributeName:inputModel.titleFont}].width + HS_KCellMargin + 12;
    self.inputLeftConstaint.constant = (inputModel.title == nil ? HS_KCellMargin : leftMargin) - 5;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.size.height = 20;
    frame.origin.y = 10;
    self.textLabel.frame = frame;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    HSInputTextCellModel * inputModel = (HSInputTextCellModel *)self.cellModel;
    if (inputModel.doneBlock) {
        inputModel.doneBlock(inputModel, textView.text);
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    HSInputTextCellModel * inputModel = (HSInputTextCellModel *)self.cellModel;
    inputModel.inputText = textView.text;
}

@end
