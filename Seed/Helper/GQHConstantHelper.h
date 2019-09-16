//
//  GQHConstantHelper.h
//  Seed
//
//  Created by GuanQinghao on 2018/6/16.
//  Copyright © 2018 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 游戏等级
typedef NS_ENUM(NSInteger, GQHUserLevel) {
    
    GQHUserLevelEasy    = 3,
    GQHUserLevelNormal  = 4,
    GQHUserLevelHarder  = 6,
    GQHUserLevelHardest = 8     /// Only in iPad
};


/// 游戏图片
UIKIT_EXTERN NSString * const GQHUserImageKey;
/// 游戏等级
UIKIT_EXTERN NSString * const GQHUserLevelKey;
/// 游戏音效
UIKIT_EXTERN NSString * const GQHUserSoundKey;
/// 游戏记录
UIKIT_EXTERN NSString * const GQHUserRecordKey;



@interface GQHConstantHelper : NSObject

+ (nonnull NSString *)qh_imagesDirectoryPath;







#pragma mark - color


#pragma mark - font color
/// 黑色
UIKIT_EXTERN NSString * const GQHFontColorBlack;
/// 浅黑色
UIKIT_EXTERN NSString * const GQHFontColorLightBlack;
/// 深灰色
UIKIT_EXTERN NSString * const GQHFontColorDarkGray;
/// 灰色 #878787
UIKIT_EXTERN NSString * const GQHFontColorGray;
/// 浅灰色 #adadad
UIKIT_EXTERN NSString * const GQHFontColorLightGray;


#pragma mark - font size
/// 正文、列表正文
UIKIT_EXTERN CGFloat const GQHFontSizeSmallest;
/// 副文、列表副文
UIKIT_EXTERN CGFloat const GQHFontSizeSmaller;
/// 最小字体 小字
UIKIT_EXTERN CGFloat const GQHFontSizeDefault;
/// 标题、按钮
UIKIT_EXTERN CGFloat const GQHFontSizeBigger;
/// 最大字体 导航、突出内容
UIKIT_EXTERN CGFloat const GQHFontSizeBiggest;


#pragma mark - font name
/// 苹方-简 中黑体
UIKIT_EXTERN NSString * const GQHFontNamePFSMedium;
/// 苹方-简 中粗体
UIKIT_EXTERN NSString * const GQHFontNamePFSSemibold;
/// 苹方-简 常规体
UIKIT_EXTERN NSString * const GQHFontNamePFSRegular;


#pragma mark - UI
/// 全局常量-单倍外边距
UIKIT_EXTERN CGFloat const GQHSingleMargin;
/// 全局常量-双倍外边距
UIKIT_EXTERN CGFloat const GQHDoubleMargin;
/// 全局常量-线的粗细
UIKIT_EXTERN CGFloat const GQHLineWidth;
/// 视图布局最小尺寸
UIKIT_EXTERN CGFloat const GQHMinLayoutValue;
/// 普通按钮高度
UIKIT_EXTERN CGFloat const GQHButtonNormalHeight;


#pragma makr - network
/// 成功code 1
UIKIT_EXTERN NSInteger const GQHHTTPStatusOKCode;
/// 服务器错误code 500
UIKIT_EXTERN NSInteger const GQHHTTPStatusServiceErrorCode;
/// 无服务code 503
UIKIT_EXTERN NSInteger const GQHHTTPStatusNoServiceCode;
/// 无效的令牌code 401
UIKIT_EXTERN NSInteger const GQHHTTPStatusUnauthorizedCode;

/// 接口根域名地址
UIKIT_EXTERN NSString * const GQHAPIServerBaseURL;
/// 接口路径地址
UIKIT_EXTERN NSString * const GQHAPIPathURL;
/// 图片服务器地址
UIKIT_EXTERN NSString * const GQHPictureServerURL;
/// 文件服务器地址
UIKIT_EXTERN NSString * const GQHFileServerURL;
/// 空白页链接
UIKIT_EXTERN NSString * const GQHBlankURL;


#pragma mark - business
/// 分页每页大小
UIKIT_EXTERN NSInteger const GQHPageSize;

/// 百度地图AppKey
UIKIT_EXTERN NSString * const GQHBMKAppKey;
/// 友盟AppKey
UIKIT_EXTERN NSString * const GQHUMShareAppKey;


#pragma mark - assets
/// TabBar
UIKIT_EXTERN NSString * const GQHTabBarItemHomeNormal;
UIKIT_EXTERN NSString * const GQHTabBarItemHomeSelected;
UIKIT_EXTERN NSString * const GQHTabBarItemDepartmentNormal;
UIKIT_EXTERN NSString * const GQHTabBarItemDepartmentSelected;
UIKIT_EXTERN NSString * const GQHTabBarItemCartNormal;
UIKIT_EXTERN NSString * const GQHTabBarItemCartSelected;
UIKIT_EXTERN NSString * const GQHTabBarItemDiscoverNormal;
UIKIT_EXTERN NSString * const GQHTabBarItemDiscoverSelected;
UIKIT_EXTERN NSString * const GQHTabBarItemMeNormal;
UIKIT_EXTERN NSString * const GQHTabBarItemMeSelected;

/// NavigationBar
UIKIT_EXTERN NSString * const GQHNavigationBarLeftArrowWhite;
UIKIT_EXTERN NSString * const GQHNavigationBarLeftArrowBlack;

/// Me
UIKIT_EXTERN NSString * const GQHMeAppFeedbackAddPicture;
UIKIT_EXTERN NSString * const GQHMeAppFeedbackRemovePicture;

/// Login
UIKIT_EXTERN NSString * const GQHLoginEyeOff;
UIKIT_EXTERN NSString * const GQHLoginEyeOn;

@end