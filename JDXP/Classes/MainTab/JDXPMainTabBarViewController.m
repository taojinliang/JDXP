//
//  LIMainTabBarViewController.m
//  LIGHTinvesting
//
//  Created by Deng on 15/8/25.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "JDXPMainTabBarViewController.h"
#import "LIAppUtils.h"

#import "JDSYViewController.h"
#import "XPFLViewController.h"
#import "XPFXViewController.h"
#import "JDMEViewController.h"


@interface JDXPMainTabBarViewController ()

@end

@implementation JDXPMainTabBarViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    JDSYViewController *vc1 = [[JDSYViewController alloc] init];
    [self setUpOneChildViewController:vc1 normalImage:[UIImage imageNamed:@"liTab_genius_n"] selectedImage:[UIImage imageNamed:@"liTab_genius_h"] title:@"首页"];
    
    XPFLViewController *vc2 = [[XPFLViewController alloc] init];
    [self setUpOneChildViewController:vc2 normalImage:[UIImage imageNamed:@"liTab_dynamic_n"] selectedImage:[UIImage imageNamed:@"liTab_dynamic_h"] title:@"分类"];
    
    XPFXViewController *vc3 = [[XPFXViewController alloc] init];
    [self setUpOneChildViewController:vc3 normalImage:[UIImage imageNamed:@"liTab_trade_n"] selectedImage:[UIImage imageNamed:@"liTab_trade_h"] title:@"发现"];
    
    JDMEViewController *vc4 = [[JDMEViewController alloc] init];
    [self setUpOneChildViewController:vc4 normalImage:[UIImage imageNamed:@"liTab_optional_n"] selectedImage:[UIImage imageNamed:@"liTab_optional_h"] title:@"我"];
    
    self.tabBar.tintColor = [LIAppUtils colorFromRGB:0xF75300];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private mothed
/**
 *  加入tabViewController控制器
 *
 *  @param viewController 子控制器
 *  @param normalImage    普通图片
 *  @param selectedImage  选中图片
 *  @param title          标题
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.navigationBarHidden = YES;
    [self addChildViewController:nav];
}


@end
