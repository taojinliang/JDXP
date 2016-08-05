//
//  LIKeyBoardViewManager.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/8/6.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol LIKeyBoardViewDelegate <NSObject>

- (void)pressedCancelBarButtonItem;
- (void)pressedDoneBarButtonItem;

@end

@interface LIKeyBoardViewManager : NSObject
@property(nonatomic,weak) id <LIKeyBoardViewDelegate> delegate ;
/**
 *  @brief  单例入口
 *  @return 单例
 */
+ (instancetype)sharedManager;

/**
 *  @brief  弹出键盘视图
 *  @return
 */

-(void)popUPKeyBoardView:(UITextField*)inputView;
@end
