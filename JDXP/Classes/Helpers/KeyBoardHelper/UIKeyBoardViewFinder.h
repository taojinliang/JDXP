//
//  UIKeyBoardViewFinder.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/8/6.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//软键盘视图查找器
@interface UIKeyBoardViewFinder : NSObject
/**
 *  @brief  尝试查找软键盘 View
 *  @return 软键盘 View, 或nil
 */
+ (UIView *)tryFindIPhoneKeyBoardView;
/**
 *  @brief  尝试查找软键盘 View (iOS8 及以上返回 nil)
 *  @return 软键盘 View, 或 nil
 *  @warning 为了兼容第三方键盘, 往键盘上添加自定义 view 时务必用此方法
 */
+ (UIView *)tryFindIPhoneKeyBoardView_NilOnIOS8OrLater;
@end
