//
//  Magic_NavigationController.h
//  MagicFramework
//
//  Created by NewM on 13-3-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magic_ViewController.h"
#import "UINavigationBar+MagicNavigationBar.h"

#pragma mark - View分类用于navigation
@class MagicViewController;
@class MagicNavigationController;
@interface UIView (MagicViewNavigation)
- (MagicViewController *)stack;
- (UINavigationController *)navigationController;

@end

#pragma mark - 动画枚举

/* 过渡效果
 cube     //立方体翻滚效果
 fade     //交叉淡化过渡(不支持过渡方向)
 reveal   //将旧视图移开,显示下面的新视图
 push     //新视图把旧视图推出去
 moveIn   //新视图移到旧视图上面
 oglFlip  //上下左右翻转效果
 suckEffect   //收缩效果，如一块布被抽走(不支持过渡方向)
 rippleEffect //滴水效果(不支持过渡方向)
 pageCurl     //向上翻页效果
 pageUnCurl   //向下翻页效果
 cameraIrisHollowOpen  //相机镜头打开效果(不支持过渡方向)
 cameraIrisHollowClose //相机镜头关上效果(不支持过渡方向)
 */
//先写这些以后再加
enum animationType
{
    ANIMATION_TYPE_DEFAULT = 0,//普通切页面
    ANIMATION_TYPE_CUBE    = 1,
    ANIMATION_TYPE_FADE    = 2,
    ANIMATION_TYPE_REVEAL  = 3,//竖直翻页
    ANIMATION_TYPE_PUSH   = 4,//滑动翻页下个页面渐变呈现
    
};

enum navigationType
{
    NAVIGATION_PUSHVIEW         = 0,
    NAVIGATION_POPVIEW          = 1,
    NAVIGATION_POPTOVIEW        = 2,
    NAVIGATION_POPTOROOTVIEW    = 3
};
@class MagicUINavigationBar;
@interface MagicNavigationController : UINavigationController<UIGestureRecognizerDelegate>
{
    MagicViewController *_baseViewController;
    NSString *_name;
}
@property (nonatomic, retain)MagicUINavigationBar *dNavBarView;//自定义navgtionbar的view
@property (nonatomic, retain)NSString *name;//当前viewcontroller在navi中的名字
@property (nonatomic, assign)MagicViewController *baseViewController;//nav的root的viewcontroller

@property (nonatomic, readonly)NSArray *allviewControllers;//全部的viewcontroller
@property (nonatomic, readonly)NSMutableArray *allviewImg;//全部viewcontroller的view
@property (nonatomic, readonly)MagicViewController *topStackViewController;//nav最堆的最上面的viewcontroller

@property (nonatomic, assign) NSInteger pageNumberCantBack;
@property (nonatomic, assign) BOOL      needSwipeBackIMGAnimation;//是否启动返回动画
@property (nonatomic, assign) BOOL      needSwipeBackSCRAnimation;//是否要支持手势后退

@property (nonatomic, readonly)CGFloat navigationbarHeight;


////初始化navigationviewcontroller
+ (MagicNavigationController *)stack;
+ (MagicNavigationController *)stack:(NSString *)name;
+ (MagicNavigationController *)stack:(NSString *)name firstViewClass:(Class)clazz;
+ (MagicNavigationController *)stack:(NSString *)name firstviewController:(MagicViewController *)viewController;
+ (MagicNavigationController *)stackWithFirstViewControllerClass:(Class)clazz;
+ (MagicNavigationController *)stackWithFirstViewController:(MagicViewController *)viewController;

- (MagicNavigationController *)initWithName:(NSString *)name andFirstBoardClass:(Class)clazz;
- (MagicNavigationController *)initWithName:(NSString *)name andFirstviewController:(MagicViewController *)viewController;

//////
- (void)pushViewController:(MagicViewController *)viewController animated:(BOOL)animated;
- (void)pushViewController:(MagicViewController *)viewController animated:(BOOL)animated animationType:(NSInteger)type;

- (void)popVCAnimated:(BOOL)animated;
- (void)popVCAnimated:(BOOL)animated animationType:(NSInteger)type;

- (NSArray *)popToViewcontroller:(MagicViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToViewcontroller:(MagicViewController *)viewController animated:(BOOL)animated animationType:(NSInteger)type;

- (NSArray *)popToFirstViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToFirstViewControllerAnimated:(BOOL)animated animationType:(NSInteger)type;

- (void)popAllViewControllers;

- (BOOL)existsViewController:(MagicViewController *)board;
- (MagicViewController *)getViewController:(Class)clazz;

- (void)setBarBackgroundImage:(UIImage *)image;
+ (void)setDefaultBarBackgroundImage:(UIImage *)image;
- (void)setBarBackgroundColor:(UIColor *)color;

- (void)enterBackground;
- (void)enterForeground;

- (void)handleSwitchView:(id)sender;

@end
