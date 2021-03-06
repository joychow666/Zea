//
//  GQHDatePickerView.m
//  Seed
//
//  Created by Mac on 2018/12/17.
//  Copyright © 2018 GuanQinghao. All rights reserved.
//

#import "GQHDatePickerView.h"
#import "UIView+GQHFrame.h"


/// 工具栏高度
static CGFloat const kToolBarHeight = 45.0f;
/// 视图高度
static CGFloat const kPickerViewHeight = 216.0f;


@interface GQHDatePickerView ()

/**
 时间选择器背景视图
 */
@property (nonatomic, strong) UIView *backgroundView;

/**
 时间选择器
 */
@property (nonatomic, strong) UIDatePicker *pickerView;

/**
 工具栏
 */
@property (nonatomic, strong) UIView *toolBar;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 确定按钮
 */
@property (nonatomic, strong) UIButton *doneButton;

/**
 预览视图
 */
@property (nonatomic, strong) UILabel *previewLabel;

/**
 选中的日期字符串
 */
@property (nonatomic, copy) NSString *selectedString;

/**
 屏幕宽度
 */
@property (nonatomic, assign) CGFloat screenWidth;

/**
 屏幕高度
 */
@property (nonatomic, assign) CGFloat screenHeight;

/**
 时间选择器背景视图宽度, 适配横竖屏
 */
@property (nonatomic, assign) CGFloat viewWidth;

/**
 时间选择器背景视图高度, 工具栏高度 + 时间选择器高度 + 底部操作视图高度
 */
@property (nonatomic, assign) CGFloat viewHeight;

@end

@implementation GQHDatePickerView

/**
 显示时间选择器

 @param sender 触发器
 */
- (void)qh_pickerViewShow:(id)sender {
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.center = UIApplication.sharedApplication.keyWindow.center;
    [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self];
    
    // 设置动画前frame
    self.backgroundView.frame = CGRectMake(0.5f * (self.screenWidth - self.viewWidth), self.screenHeight, self.viewWidth, self.viewHeight);
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.layer.opacity = 1.0f;
        
        self.backgroundView.frame = CGRectMake(0.5f * (self.screenWidth - self.viewWidth), self.screenHeight - self.viewHeight, self.viewWidth, self.viewHeight);
    } completion:^(BOOL finished) {
        
        // 初始值
        [self dateChanged:self.pickerView];
    }];
}

/**
 隐藏时间选择器

 @param sender 触发器
 */
- (void)qh_pickerViewDismiss:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.layer.opacity = 0.0f;
        
        self.backgroundView.frame = CGRectMake(0.5f * (self.screenWidth - self.viewWidth), self.screenHeight, self.viewWidth, self.viewHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.layer.opaque = NO;
        
        // 点击其他区域隐藏视图
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qh_pickerViewDismiss:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        // 工具栏
        [self.toolBar addSubview:self.cancelButton];
        [self.toolBar addSubview:self.previewLabel];
        [self.toolBar addSubview:self.doneButton];
        
        // 背景视图
        [self.backgroundView addSubview:self.toolBar];
        [self.backgroundView addSubview:self.pickerView];
        
        [self addSubview:self.backgroundView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(0.0f, 0.0f, self.screenWidth, self.screenHeight);
    self.backgroundView.frame = CGRectMake(0.5f * (self.screenWidth - self.viewWidth), self.screenHeight - self.viewHeight, self.viewWidth, self.viewHeight);
    self.pickerView.frame = CGRectMake(0.0f, kToolBarHeight, self.viewWidth, kPickerViewHeight);
    self.cancelButton.frame = CGRectMake(0.0f, 0.0f, kToolBarHeight, kToolBarHeight);
    self.doneButton.frame = CGRectMake(self.viewWidth - kToolBarHeight, 0.0f, kToolBarHeight, kToolBarHeight);
    self.previewLabel.frame = CGRectMake(kToolBarHeight, 0.0f, self.viewWidth - 2 * kToolBarHeight, kToolBarHeight);
}

#pragma mark - Delegate

#pragma mark - TargetMethod
/**
 选择时间

 @param sender 时间选择器
 */
- (IBAction)dateChanged:(UIDatePicker *)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    if (self.qh_dateFormat) {
        
        formatter.dateFormat = self.qh_dateFormat;
    }
    
    NSString *dateString = [formatter stringFromDate:sender.date];
    self.selectedString = dateString;
    self.previewLabel.text = dateString;
}

/**
 确定选择时间执行回调

 @param sender 触发器
 */
- (IBAction)didSelectPickerViewData:(id _Nullable)sender {
    
    if (_qh_block) {
        
        _qh_block(self.selectedString);
    }
    
    [self qh_pickerViewDismiss:sender];
}

#pragma mark - PrivateMethod

#pragma mark - Setter
/**
 时间选择模式, 默认日期选择模式

 @param qh_datePickerMode 时间选择模式
 */
- (void)setQh_datePickerMode:(UIDatePickerMode)qh_datePickerMode {
    
    _qh_datePickerMode = qh_datePickerMode;
    
    self.pickerView.datePickerMode = qh_datePickerMode;
}

#pragma mark - Getter
- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        
        _backgroundView.layer.cornerRadius = 0.0f;
        _backgroundView.layer.masksToBounds = YES;
    }
    
    return _backgroundView;
}

- (UIDatePicker *)pickerView {
    
    if (!_pickerView) {
        
        _pickerView = [[UIDatePicker alloc] init];
        _pickerView.backgroundColor = UIColor.whiteColor;
        _pickerView.datePickerMode = UIDatePickerModeDateAndTime;
        [_pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pickerView;
}

- (UIView *)toolBar {
    
    if (!_toolBar) {
        
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = UIColor.whiteColor;
    }
    
    return _toolBar;
}

- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_cancelButton setTitle:NSLocalizedString(@"取消", @"取消") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(qh_pickerViewDismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

- (UIButton *)doneButton {
    
    if (!_doneButton) {
        
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_doneButton setTitle:NSLocalizedString(@"确定", @"确定") forState:UIControlStateNormal];
        [_doneButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(didSelectPickerViewData:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _doneButton;
}

- (UILabel *)previewLabel {
    
    if (!_previewLabel) {
        
        _previewLabel = [[UILabel alloc] init];
        _previewLabel.font = [UIFont systemFontOfSize:14.0f];
        _previewLabel.textColor = UIColor.blackColor;
        _previewLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _previewLabel;
}

- (CGFloat)screenWidth {
    
    return CGRectGetWidth(UIScreen.mainScreen.bounds);
}

- (CGFloat)screenHeight {
    
    return CGRectGetHeight(UIScreen.mainScreen.bounds);
}

- (CGFloat)viewWidth {
    
    return MIN(self.screenWidth, self.screenHeight);
}

- (CGFloat)viewHeight {
    
    return kToolBarHeight + kPickerViewHeight + self.qh_homeIndicatorHeight;
}

@end
