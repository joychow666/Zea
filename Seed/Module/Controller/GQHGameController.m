//
//  GQHGameController.m
//
//  Created by GuanQinghao on 2019-08-11.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#pragma mark Other
#import "GQHHeader.h"
#import "GQHPuzzleStatus.h"
#import "GQHIAPManager.h"

#pragma mark Model
#import "GQHRecordModel.h"

#pragma mark View
#import "GQHGameView.h"

#pragma mark Controller
#import "GQHGameController.h"


#pragma mark -

@interface GQHGameController () <GQHGameViewDelegate, GQHIAPManagerDelegate>

/**
 自定义根视图
 */
@property (nonatomic, strong) GQHGameView *rootView;

/**
 拼图机器人
 */
@property (nonatomic, strong) UIButton *robotButton;

/**
 当前的游戏状态
 */
@property (nonatomic, strong) GQHPuzzleStatus *currentStatus;

/**
 完成时游戏状态
 */
@property (nonatomic, strong) GQHPuzzleStatus *endStatus;

/**
 保存的游戏状态
 */
@property (nonatomic, strong) GQHPuzzleStatus *savedStatus;

/**
 正在自动拼图
 */
@property (nonatomic, assign) BOOL autoGaming;


/**
 正在游戏中
 */
@property (nonatomic, assign) BOOL running;


/**
 最优记录
 */
@property (nonatomic, strong) GQHRecordModel *bestRecord;

/**
 当前游戏记录
 */
@property (nonatomic, strong) GQHRecordModel *record;

@end

@implementation GQHGameController

#pragma mark - Lifecycle
/**
 1.加载系统根视图或自定义根视图
 */
- (void)loadView {
    [super loadView];
    NSLog(@"");
    
    self.view = self.rootView;
}

/**
 2.视图加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"");
    
    [self.qh_titleButton setTitle:NSLocalizedString(@"puzzle", @"拼图") forState:UIControlStateNormal];
    [self.qh_rightMostButton setImage:[UIImage imageNamed:GQHNavigationBarResetBlackOnClear] forState:UIControlStateNormal];
    
    // 右键
    [self.qh_rightButton setTitle:@"内购" forState:UIControlStateNormal];
    
    // 重置游戏
    [self resetGame];
    
    // 查询最优记录
    [self fetchBestRecord];
    
    
    // 内购代理
    [GQHIAPManager qh_sharedIAPMannager].qh_delegate = self;
}

/**
 3.视图即将显示
 
 @param animated 是否显示动画效果
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"");
    
    //TODO: 是否有未保存的游戏
}

/**
 4.视图即将布局其子视图
 */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"");
    
}

/**
 5.视图已经布局其子视图
 */
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"");
    
}

/**
 6.视图已经显示
 
 @param animated 是否显示动画效果
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"");
    
}

/**
 7.视图即将消失
 
 @param animated 是否显示动画效果
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"");
    
}

/**
 8.视图已经消失
 
 @param animated 是否显示动画效果
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"");
    
}

/**
 9.视图被销毁
 */
- (void)dealloc {
    NSLog(@"");
    
}

#pragma mark - GQHGameViewDelegate

#pragma mark - GQHIAPManagerDelegate

/// 请求商品列表
/// @param code 返回码
/// @param content 返回内容
- (void)qh_fetchIAPProductsWithCode:(GQHIAPServiceCode)code content:(nullable id)content {
    
    switch (code) {
        case GQHIAPServiceCodeUnavailable:
            NSLog(@"内购不可用");
            break;
        case GQHIAPServiceCodeProductsUnobtainable:
            NSLog(@"无法获取商品");
            break;
        case GQHIAPServiceCodeProductsEmpty:
            NSLog(@"商品为空");
            break;
        case GQHIAPServiceCodeProductsOK: {
            
            NSArray<SKProduct *> *products = [NSArray arrayWithArray:content];
            
            for (SKProduct *product in products) {
                
                NSLog(@"商品信息%@%@%@%@",product.localizedTitle,product.localizedDescription, product.price,product.productIdentifier);
            }
            
            [[GQHIAPManager qh_sharedIAPMannager] qh_payForIAPProduct:products.firstObject];
        }
            break;
    }
}

/// 交易失败
/// @param code 交易失败码
- (void)qh_failedIAPTransactionWithCode:(GQHIAPResultCode)code {
    
    switch (code) {
            
        case GQHIAPResultCodePaymentOK:
            
            break;
        case GQHIAPResultCodePaymentFailed:
            
            break;
        case GQHIAPResultCodePaymentCancelled:
            
            break;
    }
}

/// 发送内购交易收据到服务器(验证通过，删除收据，完成此次交易)
/// @param transaction 内购交易
/// @param file 收据文件路径
- (void)qh_sendIAPTransaction:(SKPaymentTransaction *)transaction receipt:(NSString *)file {
    
    NSDictionary *receipt = [NSDictionary dictionaryWithContentsOfFile:file];
    NSLog(@"%@",receipt);
    
    [self showToastWithText:@"验证成功"];
    
    [[GQHIAPManager qh_sharedIAPMannager] qh_finishIAPTransaction:transaction receipt:file];
}






#pragma mark - TargetMethod

- (void)qh_didClickRightButton:(UIButton *)sender {
    
    if (self.autoGaming) {
        
        return;
    }
    
    if (self.currentStatus.qh_mark < 0) {
        
        return;
    }
    
    self.rootView.qh_gameboardView.userInteractionEnabled = NO;
    
    
    GQHPathSearcher *searcher = [[GQHAStarSearcher alloc] init];
    searcher.qh_startStatus = [self.currentStatus qh_copy];
    searcher.qh_targetStatus = [self.endStatus qh_copy];
    
    [searcher setQh_comparator:^BOOL(GQHPuzzleStatus *status1, GQHPuzzleStatus *status2) {
        
        return [status1 qh_isEqualTo:status2];
    }];
    
    // 开始搜索
    NSMutableArray<GQHPuzzleStatus *> *path = [searcher qh_startSearching];
    
    __block NSInteger count = path.count;
    self.record.qh_gameCount = count;
    self.record.qh_gameTime = count * 0.25f;
    
    if (!path || count == 0) {
        
        return;
    }
    
    // 开始自动拼图
    self.autoGaming = YES;
    
    // 定时信号，控制拼图速度
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.25f repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [path enumerateObjectsUsingBlock:^(GQHPuzzleStatus * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 等待信号
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            // 刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 显示排列
                [self reloadGameBoardWithStatus:obj order:self.record.qh_levelOrder];
            });
        }];
        
        // 拼图完成
        [timer invalidate];
        self.currentStatus = [path lastObject];
        self.autoGaming = NO;
        // 保存记录
        self.record.qh_timestamp = [[NSDate date] timeIntervalSince1970];
        // 操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 取消交互
            self.rootView.qh_gameboardView.userInteractionEnabled = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                GQHPuzzlePiece *piece = [self.endStatus.qh_puzzlePieceArray lastObject];
                piece.alpha = 1.0f;
                self.currentStatus.qh_mark = -1;
                
                self.record.qh_timestamp = [[NSDate date] timeIntervalSince1970];
                if ([GQHRecordModel qh_insertRecord:self.record]) {
                    
                    // 完成
                    [self qh_alertWithTitle:NSLocalizedString(@"gameover", @"游戏结束") message:nil handler:nil completion:nil];
                }
            });
        });
    });
}

/// 重置游戏
/// @param sender 重置按钮
- (void)qh_didClickRightMostButton:(UIButton *)sender {
    
    [[GQHIAPManager qh_sharedIAPMannager] qh_restoreCompletedIAPTransactionsWithApplicationUsername:@"iap"];
    
//    [self resetGame];
}

/// 触摸拼图块
/// @param sender 拼图块
- (IBAction)touchPuzzlePiece:(GQHPuzzlePiece *)sender {
    NSLog(@"");
    
    if (self.autoGaming) {
        
        return;
    }
    
    GQHPuzzleStatus *status = self.currentStatus;
    NSInteger index = [status.qh_puzzlePieceArray indexOfObject:sender];
    
    if (![status qh_canMoveTo:index]) {
        
        // 触摸其他拼图块
        NSLog(@"无法移动");
        return;
    }
    
    [status qh_moveTo:index];
    
    //MARK: 重新加载拼图板
    [self reloadGameBoardWithStatus:self.currentStatus order:self.record.qh_levelOrder];
    
    self.running = YES;
    self.record.qh_gameCount++;
    self.rootView.qh_record = self.record;
    
    //TODO:完成
    if ([status qh_isEqualTo:self.endStatus]) {
        
        // 取消交互
        self.rootView.qh_gameboardView.userInteractionEnabled = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            GQHPuzzlePiece *piece = [self.endStatus.qh_puzzlePieceArray lastObject];
            piece.alpha = 1.0f;
            status.qh_mark = -1;
            self.running = NO;
            
            self.record.qh_timestamp = [[NSDate date] timeIntervalSince1970];
            if ([GQHRecordModel qh_insertRecord:self.record]) {
                
                // 完成
                [self qh_alertWithTitle:NSLocalizedString(@"gameover", @"游戏结束") message:nil handler:nil completion:nil];
            }
        });
    }
}

#pragma mark - PrivateMethod
/// 重置游戏
- (void)resetGame {
    
    // 自动拼图中
    if (self.autoGaming) {
        
        return;
    }
    
    // 游戏等级
    NSInteger gameLevel = self.record.qh_levelOrder;
    if (gameLevel < 3 || gameLevel > 11) {
        
        return;
    }
    
    // 游戏图片
    UIImage *gameImage = [UIImage imageNamed:self.record.qh_gameImage];
    if (!gameImage) {
        
        return;
    }
    
    if (self.currentStatus) {
        
        // 移除当前状态
        [self.currentStatus qh_removeAllPieces];
    }
    
    //MARK:准备拼图块
    self.currentStatus = [GQHPuzzleStatus qh_puzzleStatusWithOrder:gameLevel image:gameImage];
    
    // 添加触摸事件
    [self.currentStatus.qh_puzzlePieceArray enumerateObjectsUsingBlock:^(GQHPuzzlePiece * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj addTarget:self action:@selector(touchPuzzlePiece:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.endStatus = nil;
    
    //MARK:重置游戏数据
    self.record.qh_gameTime = 0;
    self.record.qh_gameCount = 0;
    self.rootView.qh_record =self.record;
    
    //MARK:显示游戏板
    [self loadGameBoardView:self.rootView.qh_gameboardView order:gameLevel];
    
    //MARK:打乱顺序
    [self shuffleGameBoardViewWithOrder:gameLevel];
    
    //MARK:Tick-Tick
    // 记时器是否运行
    self.running = NO;
    [GQHGlobalTimer qh_sharedGlobalTimer].qh_block = ^(double timeStamp) {
        
        if (self.running) {
            
            self.record.qh_gameTime++;
        }
        
        self.rootView.qh_record = self.record;
    };
    
    // 交互
    self.rootView.qh_gameboardView.userInteractionEnabled = YES;
}

/// 加载游戏板
/// @param boardView 游戏板
/// @param order 阶数
- (void)loadGameBoardView:(UIView *)boardView order:(NSInteger)order {
    
    // 拼图板宽度
    CGFloat boardWith = self.rootView.qh_contentAreaWidth - 2 * GQHSpacing;
    
    // 拼图块宽度和高度
    CGFloat width = boardWith/order;
    CGFloat height = width;
    
    
    NSInteger index = 0;
    for (NSInteger row = 0; row < order; row++) {
        for (NSInteger column = 0; column < order; column++) {
            
            //TODO:优化复杂度
            GQHPuzzlePiece *piece = self.currentStatus.qh_puzzlePieceArray[index++];
            piece.frame = CGRectMake(column * width, row * height, width, height);
            [boardView addSubview:piece];
        }
    }
    
    
    // 设置空格
    if (self.currentStatus.qh_mark < 0) {
        
        // 空格只是变成透明
        GQHPuzzlePiece *last = [self.currentStatus.qh_puzzlePieceArray lastObject];
        last.alpha = 0;
        self.currentStatus.qh_mark = self.currentStatus.qh_puzzlePieceArray.count - 1;
        
        // 设置目标状态
        self.endStatus = [self.currentStatus qh_copy];
    }
}

/// 重新加载游戏板
/// @param status 拼图块状态
- (void)reloadGameBoardWithStatus:(GQHPuzzleStatus *)status order:(NSInteger)order {
    NSLog(@"%s",__func__);
    
    [UIView animateWithDuration:0.15f animations:^{
        
        // 拼图块宽度和高度
        CGFloat width = CGRectGetWidth(status.qh_puzzlePieceArray.firstObject.frame);
        CGFloat height = CGRectGetHeight(status.qh_puzzlePieceArray.firstObject.frame);
        
        
        NSInteger index = 0;
        for (NSInteger row = 0; row < order; row++) {
            for (NSInteger column = 0; column < order; column++) {
                
                //TODO:优化复杂度
                GQHPuzzlePiece *piece = status.qh_puzzlePieceArray[index++];
                piece.frame = CGRectMake(column * width, row * height, width, height);
            }
        }
    }];
}

/// 打乱拼图块顺序(洗牌)
- (void)shuffleGameBoardViewWithOrder:(NSInteger)order {
    
    if (self.autoGaming) {
        
        return;
    }
    
    if (self.currentStatus.qh_mark < 0) {
        
        return;
    }
    
    NSLog(@"洗牌:%@阶矩阵, 随机移动%@步",@(order),@(order * order * 10));
    
    [self.currentStatus qh_shuffle:(order * order * 10)];
    [self reloadGameBoardWithStatus:self.currentStatus order:order];
}

- (void)fetchBestRecord {
    
    NSArray<GQHRecordModel *> *records = [GQHRecordModel qh_fetchBestRecords];
    [records enumerateObjectsUsingBlock:^(GQHRecordModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (self.record.qh_levelOrder == obj.qh_levelOrder) {
            
            self.bestRecord = obj;
        }
    }];
    
    self.rootView.qh_bestRecord = self.bestRecord;
}

#pragma mark - Setter

#pragma mark - Getter
- (GQHGameView *)rootView {
    
    if (!_rootView) {
        
        _rootView = [[GQHGameView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _rootView.backgroundColor = [UIColor qh_colorWithHexString:@"#f8f8f8"];
        _rootView.qh_delegate = self;
    }
    
    return _rootView;
}

- (GQHRecordModel *)record {
    
    if (!_record) {
        
        _record = [[GQHRecordModel alloc] init];
        
        // 游戏记录等级(阶数)
        _record.qh_levelOrder = [[NSUserDefaults.standardUserDefaults objectForKey:GQHGameLevelOrderKey] integerValue];
        _record.qh_levelTitle = [NSUserDefaults.standardUserDefaults objectForKey:GQHGameLevelTitleKey];
        // 游戏记录图片
        _record.qh_gameImage = [NSUserDefaults.standardUserDefaults objectForKey:GQHGameImageKey];
        // 游戏记录用时
        _record.qh_gameTime = 0;
        // 游戏记录计数
        _record.qh_gameCount = 0;
    }
    
    return _record;
}

@end
