//
//  LIKeyBoardViewManager.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/8/6.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "LIKeyBoardViewManager.h"
#import "UIKeyboardObserveManager.h"
#import "LIAppUtils.h"



@interface LIKeyBoardViewManager()
@end

@implementation LIKeyBoardViewManager

+ (instancetype)sharedManager
{
    static LIKeyBoardViewManager* s_mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_mgr = [[LIKeyBoardViewManager alloc] init];
    });
    return s_mgr;
}

-(void)popUPKeyBoardView:(UITextField*)inputView{
    [[UIKeyboardObserveManager sharedManager] setKeyboardObserverDelegate:nil forInputView:inputView enableAutoAdjustContainerView:YES inputViewBottomToKeyboardTopOffset:15];
    {
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [LIAttributeConfig deviceSizeWidth], 44)];
        toolbar.barStyle = UIBarStyleDefault;
        UIBarButtonItem* item0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pressedCancelBarButtonItem:)];
        UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pressedDoneBarButtonItem:)];
        [toolbar setItems:@[item0, item1, item2]];
        inputView.inputAccessoryView = toolbar;
    }
}


- (void)pressedCancelBarButtonItem:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pressedCancelBarButtonItem)]) {
        [self.delegate pressedCancelBarButtonItem];
    }
}

- (void)pressedDoneBarButtonItem:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pressedDoneBarButtonItem)]) {
        [self.delegate pressedDoneBarButtonItem];
    }
}
@end
