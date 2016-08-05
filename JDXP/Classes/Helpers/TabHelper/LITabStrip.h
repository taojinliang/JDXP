//
//  LITabStrip.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/9/9.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

enum HsSelectionIndicatorMode {
    HsSelectionIndicatorResizesToStringWidth = 0, // Indicator width will only be as big as the text width
    HsSelectionIndicatorFillsSegment = 1 // Indicator width will fill the whole segment
};

enum HsSelectionIndicatorPosition {
    HsSelectionIndicatorPositionBottom = 0,
    HsSelectionIndicatorPositionTop = 1
};

enum HsTabWidthMode {
    HsTabWidthModeFlexible = 0,
    HsTabWidthModeFixed = 1 
};


@interface LITabStrip : UIControl
{
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, copy) void (^indexChangeBlock)(NSUInteger index); // you can also use addTarget:action:forControlEvents:

@property (nonatomic, strong) UIFont *font; // default is [UIFont fontWithName:@"Avenir-Light" size:19.0f]
@property (nonatomic, strong) UIColor *textColor; // default is [UIColor blackColor]
@property (nonatomic, strong) UIColor *backgroundColor; // default is [UIColor whiteColor]
@property (nonatomic, strong) UIColor *selectionIndicatorColor; // default is 52, 181, 229
@property (nonatomic, assign) enum HsSelectionIndicatorMode selectionIndicatorMode; // Default is HMSelectionIndicatorResizesToStringWidth
@property (nonatomic, assign) enum HsSelectionIndicatorPosition selectionIndicatorPositon;
@property (nonatomic, assign) enum HsTabWidthMode tabWidthMode;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readwrite) CGFloat height; // default is 32.0
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight; // default is 5.0
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset; // default is UIEdgeInsetsMake(0, 5, 0, 5
@property (nonatomic, readwrite) CGFloat segmentWidth;

@property (nonatomic, assign) BOOL showSeperator;
@property (nonatomic, strong) NSArray *showTags;

//- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;

@end
