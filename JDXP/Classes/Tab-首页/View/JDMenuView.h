//
//  JDMenuView.h
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDMenuViewDelegate <NSObject>
-(void)gotoJDMenuPage:(NSInteger)index;
@end


@interface JDMenuView : UIView
@property(nonatomic, weak) id<JDMenuViewDelegate> delegate;
-(void)loadData:(NSArray *)array;
@end
