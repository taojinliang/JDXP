//
//  ActionButton.h
//  JDXP
//
//  Created by MacBookPro on 16/1/25.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol onActionButtonDelegate <NSObject>
-(void)onTapAction:(NSInteger)tag;
@end

@interface ActionButton : UIButton
@property(nonatomic, weak) id<onActionButtonDelegate> delegate;
-(void)configureData:(NSString *)imageName Title:(NSString *)title;
@end
