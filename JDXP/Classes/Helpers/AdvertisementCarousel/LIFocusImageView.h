//
//  LIFocusImageView.h
//  LIGHTinvesting
//
//  Created by Deng on 15/11/23.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - LIFocusImageItem

@interface LIFocusImageItem : NSObject

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, assign) NSInteger tage;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag url:(NSString *)url;
- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;

@end

@class LIFocusImageView;
@protocol LIFocusImageViewDelegate <NSObject>
- (void)focusImageView:(LIFocusImageView *)imageView didSelectItem:(LIFocusImageItem *)item;
@optional
- (void)focusImageView:(LIFocusImageView *)imageView didSelectPage:(NSInteger)curPage;

@end

#pragma mark - LIFocusImageView

@interface LIFocusImageView : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic) NSTimeInterval switchTimeInterval; // default for 10.0s
@property (nonatomic, assign) BOOL autoScrolling;
@property (nonatomic, assign) id<LIFocusImageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<LIFocusImageViewDelegate>)delegate focusImageItems:(LIFocusImageItem *)items,...NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFrame:(CGRect)frame delegate:(id<LIFocusImageViewDelegate>)delegate focusImageItemsArrray:(NSArray *)items;
- (id)initWithFrame:(CGRect)frame delegate:(id<LIFocusImageViewDelegate>)delegate focusImageItemsArrray:(NSArray *)items currentPageIndicatorTintColor:(UIColor *)curColor;

@end
