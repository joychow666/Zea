//
//  GQHHomeController.m
//
//  Created by GuanQinghao on 2019-08-11.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#pragma mark Other
#import "GQHHeader.h"

#pragma mark Model
#import "GQHMenuModel.h"

#pragma mark View
#import "GQHHomeView.h"

#pragma mark Controller
#import "GQHHomeController.h"
#import "GQHGameController.h"
#import "GQHRecordController.h"
#import "GQHGalleryController.h"
#import "GQHLevelController.h"
#import "GQHAppHelpController.h"
#import "GQHAppAboutController.h"

#import "GQHHelpWebController.h"

#pragma mark -

@interface GQHHomeController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, GQHHomeViewDelegate>

/**
 自定义根视图
 */
@property (nonatomic, strong) GQHHomeView *rootView;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation GQHHomeController

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
    
    self.qh_navigationBar.hidden = YES;
}

/**
 3.视图即将显示
 
 @param animated 是否显示动画效果
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"");
    
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

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 0.5f * (self.rootView.qh_contentAreaWidth - 10.0f);
    CGFloat height = width;
    
    return CGSizeMake(width,height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.rootView.qh_contentAreaWidth, 5.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(self.rootView.qh_contentAreaWidth, 5.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GQHHomeViewMenusCollecionViewCell *cell = [GQHHomeViewMenusCollecionViewCell qh_collectionView:collectionView cellForIndexPath:indexPath data:self.dataSourceArray[indexPath.row]];
    
    cell.qh_delegate = self;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //TODO:push
    switch (indexPath.row) {
            
        case 0: {
            
            // 开始游戏
            GQHGameController *gameController = [[GQHGameController alloc] init];
            [self.navigationController pushViewController:gameController animated:YES];
        }
            break;
        case 1: {
            
            // 游戏记录
            GQHRecordController *recordController = [[GQHRecordController alloc] init];
            [self.navigationController pushViewController:recordController animated:YES];
        }
            break;
        case 2: {
            
            // 游戏图库
            GQHGalleryController *galleryController = [[GQHGalleryController alloc] init];
            [self.navigationController pushViewController:galleryController animated:YES];
        }
            break;
        case 3: {
            
            // 游戏等级
            GQHLevelController *levelController = [[GQHLevelController alloc] init];
            [self.navigationController pushViewController:levelController animated:YES];
        }
            break;
        case 4: {
            
            // 游戏帮助
//            GQHAppHelpController *appHelpController = [[GQHAppHelpController alloc] init];
//            [self.navigationController pushViewController:appHelpController animated:YES];
            GQHHelpWebController *helpWebController = [[GQHHelpWebController alloc] init];
            helpWebController.qh_URLString = @"http://uter.top/2019/11/21/app_puzzle.html";
            [self.navigationController pushViewController:helpWebController animated:YES];
        }
            break;
        case 5: {
            
            // 关于我们
            GQHAppAboutController *appAboutController = [[GQHAppAboutController alloc] init];
            [self.navigationController pushViewController:appAboutController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - GQHHomeViewDelegate

#pragma mark - TargetMethod

#pragma mark - PrivateMethod

#pragma mark - Setter

#pragma mark - Getter
- (GQHHomeView *)rootView {
    
    if (!_rootView) {
        
        _rootView = [[GQHHomeView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _rootView.backgroundColor = [UIColor qh_colorWithHexString:GQHColorWhiteSmoke];
        _rootView.qh_collectionView.delegate = self;
        _rootView.qh_collectionView.dataSource = self;
        _rootView.qh_delegate = self;
    }
    
    return _rootView;
}

- (NSMutableArray *)dataSourceArray {
    
    if (!_dataSourceArray) {
        
        _dataSourceArray = [NSMutableArray arrayWithArray:[GQHMenuModel qh_allMenus]];
    }
    
    return _dataSourceArray;
}

@end
