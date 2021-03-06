//
//  GQHLogger.m
//  Seed
//
//  Created by Hao on 2018/8/20.
//  Copyright © 2018 GuanQinghao. All rights reserved.
//

#import "GQHLogger.h"


@interface GQHLog : NSObject

/**
 时间戳
 */
@property (nonatomic, assign) double timeStamp;

/**
 时间文本
 */
@property (nonatomic, copy) NSString *timeText;

/**
 日志记录文本
 */
@property (nonatomic, copy) NSString *logText;

@end

/// 日志板高度
static CGFloat const kLogBoardHeight = 250.0f;
/// 日志板透明度
static CGFloat const kLogBoardAlpha = 0.15f;


@implementation GQHLog

/**
 初始化日志记录

 @param text 日志记录文本
 @return 日志记录
 */
+ (instancetype)logWithText:(NSString *)text {
    
    GQHLog *log = [[GQHLog alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    log.timeText = [dateFormatter stringFromDate:[NSDate date]];
    log.timeStamp = [[NSDate date] timeIntervalSince1970];
    log.logText = text;
    
    return log;
}

@end


@interface GQHLogger ()

/**
 日志记录视图
 */
@property (nonatomic, strong) UITextView *textView;

/**
 日志记录数组
 */
@property (nonatomic, strong) NSMutableArray<GQHLog *> *logArray;

@end

@implementation GQHLogger

/**
 输出日志记录
 
 @param text 日志记录
 */
+ (void)qh_print:(NSString *)text {
    
    [[self qh_sharedLogger] qh_print:text];
}

/**
 输出日志记录
 
 @param text 日志记录
 */
- (void)qh_print:(NSString *)text {
    
    if (text && text.length > 0) {
        
        @synchronized (self) {
            
            GQHLog *log = [GQHLog logWithText:@""];
            log.logText = [NSString stringWithFormat:@"%@\n%@ %@",log.logText,log.timeText,text];
            [self.logArray addObject:log];
            
            if (self.logArray.count > 20) {
                
                [self.logArray removeObjectAtIndex:0];
            }
            
            [self reloadDisplay];
        }
    }
    
    return;
}

/**
 清除日志记录
 */
+ (void)qh_clear {
    
    [[self qh_sharedLogger] qh_clear];
}

/**
 清除日志记录
 */
- (void)qh_clear {
    
    self.textView.attributedText = nil;
    self.logArray = nil;
}

/// 日志记录器单例
static GQHLogger *logger = nil;

/**
 日志记录器单例
 
 @return 日志记录器单例
 */
+ (instancetype)qh_sharedLogger {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        logger = [[GQHLogger alloc] init];
    });
    
    return logger;
}

/**
 初始化日志记录器

 @return 日志记录器
 */
- (instancetype)init {
    
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(UIScreen.mainScreen.bounds), kLogBoardHeight)]) {
        
        self.rootViewController = [UIViewController new];
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:kLogBoardAlpha];
        self.userInteractionEnabled = NO;
        
        [self addSubview:self.textView];
    }
    
    return self;
}

/**
 刷新记录器视图
 */
- (void)reloadDisplay {
    
    NSMutableAttributedString *attributedStringM = [NSMutableAttributedString new];
    
    double timeStamp = [[NSDate date] timeIntervalSince1970];
    
    [self.logArray enumerateObjectsUsingBlock:^(GQHLog * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:obj.logText];
        
        UIColor *color = (timeStamp - obj.timeStamp > 0.1f) ? UIColor.whiteColor : UIColor.yellowColor;
        
        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
        
        [attributedStringM appendAttributedString:string];
    }];
    
    self.textView.attributedText = attributedStringM;
    [self.textView scrollRangeToVisible:NSMakeRange(attributedStringM.length - 1, 1)];
}

- (void)layoutSubviews {
    
    self.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(UIScreen.mainScreen.bounds), kLogBoardHeight);
}

#pragma mark --Setter
- (UITextView *)textView {
    
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        _textView.font = [UIFont systemFontOfSize:12.0f];
        _textView.backgroundColor = UIColor.clearColor;
        _textView.scrollsToTop = NO;
    }
    
    return _textView;
}

- (NSMutableArray<GQHLog *> *)logArray {
    
    if (!_logArray) {
        
        _logArray = [NSMutableArray array];
    }
    
    return _logArray;
}

@end
