//
//  UIKeyBoardViewFinder.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/8/6.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "UIKeyBoardViewFinder.h"

@implementation UIKeyBoardViewFinder
+ (UIView *)tryFindIPhoneKeyBoardView
{
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        return nil;
    }
    
    for (UIWindow* window in [[UIApplication sharedApplication] windows]) {
        for (UIView* view in window.subviews) {
            NSString* classname = [NSString stringWithUTF8String:object_getClassName(view)];
            // iOS 3、4、5、6、7
            if ([classname isEqualToString:@"UIKeyboard"] || [classname isEqualToString:@"UIPeripheralHostView"])
            {
                return view;
            }
            // iOS 8
            else if ( [classname isEqualToString:@"UIInputSetContainerView"] )
            {
                for (UIView* __host in view.subviews) {
                    NSString* clsName_2 = [NSString stringWithUTF8String:object_getClassName(__host)];
                    if ([clsName_2 isEqualToString:@"UIInputSetHostView"]) {
                        return __host;
                    }
                }
            }
        }
    }
    return nil;
}

+ (UIView *)tryFindIPhoneKeyBoardView_NilOnIOS8OrLater
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 往键盘上添加自定义view时, 在 iOS8 上为了兼容第三方键盘, 这里直接返回 nil（认为没有找到）
        return nil;
    }
    return [self tryFindIPhoneKeyBoardView];
}

@end


