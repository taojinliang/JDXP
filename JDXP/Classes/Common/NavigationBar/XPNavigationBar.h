//
//  XPNavigationBar.h
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  vc顶部自定义导航view，高度为64
 */
@interface XPNavigationBar : UIView
@property (nonatomic, strong) NSString *title;

- (id)initWithTarget:(UIViewController *)targetVC;
- (void)addDefaultBackButton;
- (void)addLeftButtonWithImage:(UIImage *)image action:(SEL)action;
- (void)addRightButtonWithImage:(UIImage *)image action:(SEL)action;
- (void)fadeTitleWithAlpha:(CGFloat)alpha;

@end
