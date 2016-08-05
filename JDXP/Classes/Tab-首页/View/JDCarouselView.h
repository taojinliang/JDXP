//
//  JDCarouselView.h
//  JDXP
//
//  Created by MacBookPro on 16/1/26.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDCarouselView;

@protocol JDCarouselDelegate <NSObject>
/**
 *  告诉代码滚动到了哪一页
 *
 *  @param carousel self
 *  @param page     已经计算好，直接使用即可
 */
-(void)carousel:(JDCarouselView *)carousel didMoveToPage:(NSInteger)page;

/**
 *  告诉代理用户点击了某一页
 *
 *  @param carousel
 *  @param page     imageURL的index
 */
-(void)carousel:(JDCarouselView *)carousel didTouchToPage:(NSInteger)page;

@end



@interface JDCarouselView : UICollectionView
/**
 *  必须赋值，只要给这个imageURL赋值，会自动获取图片。刷新请再次给该值赋值。
 */
@property(nonatomic, strong) NSArray *imageURLs;
/**
 *  没有轮播时的占位图
 */
@property(nonatomic, strong) UIImage *placeholder;
/**
 *  是否自动轮播，默认为NO
 */
@property(nonatomic, getter=isAutoMoving) BOOL autoMoving;
/**
 *  滚动速率 默认为3.0  即3秒翻页一次
 */
@property(nonatomic, assign) NSTimeInterval movingTimeInterval;
/**
 *  代理
 */
@property(nonatomic, weak) id<JDCarouselDelegate> pageDelegate;

/**
 *  开始移动
 */
-(void)startMoving;
/**
 *  停止移动
 */
-(void)stopMoving;

@end
