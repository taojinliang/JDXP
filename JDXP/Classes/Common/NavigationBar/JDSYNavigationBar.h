//
//  JDSYNavigationBar.h
//  JDXP
//
//  Created by MacBookPro on 16/1/25.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDSYNavigationBarDelegate <NSObject>

-(void)gotoNavBarScanPage;
-(void)gotoNavBarMessagePage;
-(void)gotoNavBarSearchPage;
-(void)gotoNavBarVoicePage;

@end

@interface JDSYNavigationBar : UIView
@property(nonatomic, weak) id<JDSYNavigationBarDelegate> barDelegate;
/**
 *
 * 首页导航栏搜索框背景色变化
 *  @param tmp 
 */
-(void)changeAlpha:(CGFloat)tmp;
@end
