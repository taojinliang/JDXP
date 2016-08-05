//
//  JDXPBaseViewController.m
//  JDXP
//
//  Created by MacBookPro on 15/11/25.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import "JDXPBaseViewController.h"
#import "LIAppUtils.h"
#import "LIAppMacro.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface JDXPBaseViewController ()<UIGestureRecognizerDelegate>
@end

@implementation JDXPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    //基类设置背景色
    self.view.backgroundColor = [LIAppUtils colorFromRGB:0xEFEFF4];
    
    if(IOSVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    /**
     **brief
     **automaticallyAdjustsScrollViewInsets，当设置为YES时（默认YES），如果视图里面存在唯一一个UIScrollView或其子类View，那么它会自动设置相应的内边距，这样可以让scroll占据整个视图，又不会让导航栏遮盖。当然也可以通过修改UIViewController的edgesForExtendedLayout这个属性来实现。
     **/
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
