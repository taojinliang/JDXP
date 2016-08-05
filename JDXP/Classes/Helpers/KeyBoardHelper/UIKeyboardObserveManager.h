//
//  UIKeyboardObserveManager.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/8/6.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UIKeyboardObserveManagerDelegate;

@interface UIKeyboardObserveManager : NSObject
/**
 *  @brief  显示状态中的键盘视图 (如果没有找到，显示 nil)
 */
@property (assign, nonatomic, readonly) UIView* visibleKeyboardView;
/**
 *  @brief  单例入口
 *  @return 单例
 */
+ (instancetype)sharedManager;
/**
 *  @brief  设置键盘打开/关闭观察者
 *  @param delegate         观察者回调代理 (弱引用)
 *  @param weakSender       发送者 (UITextField / UITextView, 弱引用)
 *  @param enableAutoAdjust 是否开启 根据键盘自动调整容器视图
 *  @param offset           输入框底边与软键盘上边的距离 (关闭自动调整容器视图时，忽略此参数)
 *  @warning weakSender 不能为 nil
 */
- (void)setKeyboardObserverDelegate:(id <UIKeyboardObserveManagerDelegate>)delegate
                       forInputView:(UIView *)weakSender
      enableAutoAdjustContainerView:(BOOL)enableAutoAdjust
 inputViewBottomToKeyboardTopOffset:(CGFloat)offset;
/**
 *  @brief  移除键盘打开/关闭观察者
 *  @param weakSender 发送者 (UITextField / UITextView, 弱引用)
 *  @warning weakSender 不能为 nil
 */
- (void)removeObserverForInputView:(id)weakSender;

@end

///////////////////////////////////////////////////////////////////////
UIViewAnimationOptions UIViewAnimationOptionsConvertFromUIViewAnimationCurve(UIViewAnimationCurve curve);

@protocol UIKeyboardObserveManagerDelegate <NSObject>

// 注意，切换键盘时也会产生 UIKeyboardWillShowNotification，所以很可能方法被调用多次。
// 在此方法中'不要'写与调用次数有关的代码。在键盘第一次产生时，如果不是默认的英文键盘也会调用多次方法。
// 另外，由于以上原因，计算 offset 是不可靠的!!
- (void)wl_KeyboardObserveManager:(UIKeyboardObserveManager*)manager
         keyboardWillShowWithSize:(CGSize)keyboardSize
                animationDuration:(NSTimeInterval)animationDuration
                   animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)wl_KeyboardObserveManager:(UIKeyboardObserveManager*)manager
         keyboardWillHideWithSize:(CGSize)keyboardSize
                animationDuration:(NSTimeInterval)animationDuration
                   animationCurve:(UIViewAnimationCurve)animationCurve;
@end

@interface UIView (KeyboardObserveManager)
+ (UIViewController*)topMostController;
+ (UIViewController*)currentViewController;
@end

