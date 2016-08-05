//
//  LIFocusImageView.m
//  LIGHTinvesting
//
//  Created by Deng on 15/11/23.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import "LIFocusImageView.h"
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"

#pragma mark - LIFocusImageItem

@implementation LIFocusImageItem

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag url:(NSString *)url {
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tage = tag;
        self.url = url;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag {
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tage = tag;
    }
    
    return self;
}

+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag {
    return [[LIFocusImageItem alloc] initWithTitle:title image:image tag:tag];
}

@end

#pragma mark - LIFocusImageView

@interface LIFocusImageView () {
    UIColor *_currentPageIndicatorTintColor;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void)setupViews;
- (void)switchFocusImageItems;

@end

static NSString *LI_FOCUS_ITEM_ASS_KEY = @"com.touchmob.sgfocusitems";
static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 10.0; //switch interval time

@implementation LIFocusImageView

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame delegate:(id<LIFocusImageViewDelegate>)delegate focusImageItemsArrray:(NSArray *)items {
    self = [super initWithFrame:frame];
    if (self) {
        objc_setAssociatedObject(self, (__bridge const void *)LI_FOCUS_ITEM_ASS_KEY, items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
        [self initImageFrame];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<LIFocusImageViewDelegate>)delegate focusImageItemsArrray:(NSArray *)items currentPageIndicatorTintColor:(UIColor *)curColor {
    self = [super initWithFrame:frame];
    if (self) {
        _currentPageIndicatorTintColor = curColor;
        objc_setAssociatedObject(self, (__bridge const void *)LI_FOCUS_ITEM_ASS_KEY, items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
        [self initImageFrame];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<LIFocusImageViewDelegate>)delegate focusImageItems:(LIFocusImageItem *)firstItem, ... {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];
        LIFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem) {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, LIFocusImageItem *))) {
                [imageItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (__bridge const void *)LI_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.delegate = delegate;
        
        [self initImageFrame];
    }
    
    return self;
}

- (void)initImageFrame {
    [self initParameters];
    [self setupViews];
}

- (void)dealloc {
    objc_setAssociatedObject(self, (__bridge const void *)LI_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Actions
- (void)pageControlTapped:(id)sender {
    UIPageControl *pc = (UIPageControl *)sender;
    [self moveToTargetPage:pc.currentPage];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    int targetPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)LI_FOCUS_ITEM_ASS_KEY);
    if (targetPage > -1 && targetPage < imageItems.count) {
        LIFocusImageItem *item = [imageItems objectAtIndex:targetPage];
        if ([self.delegate respondsToSelector:@selector(focusImageView:didSelectItem:)]) {
            [self.delegate focusImageView:self didSelectItem:item];
        }
    }
}

#pragma mark - private methods

- (void)initParameters {
    self.switchTimeInterval = SWITCH_FOCUS_PICTURE_INTERVAL;
    self.autoScrolling = YES;
}

- (void)setupViews {
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)LI_FOCUS_ITEM_ASS_KEY);
    CGFloat mainWidth = self.frame.size.width, mainHeight = self.frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, mainWidth, mainHeight)];
    
    CGSize size = CGSizeMake(mainWidth, 20);
    CGRect pcFrame = CGRectMake(mainWidth *.5 - size.width *.5, mainHeight - size.height, size.width, size.height);
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:pcFrame];
    //    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:121.0/255 green:126.0/255 blue:134.0/255 alpha:1.0];
    //renrenfenqi 2014.11.11
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    if (_currentPageIndicatorTintColor) {
        pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    }
    
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:216.0/255 green:217.0/255 blue:219.0/255 alpha:1.0];
    [pageControl addTarget:self action:@selector(pageControlTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scrollView];
    [self addSubview:pageControl];
    
    /*
     scrollView.layer.cornerRadius = 10;
     scrollView.layer.borderWidth = 1 ;
     scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    pageControl.numberOfPages = imageItems.count;
    pageControl.currentPage = 0;
    
    scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:tapGestureRecognize];
    
    CGSize scrollViewSize = scrollView.frame.size;
    scrollView.contentSize = CGSizeMake(scrollViewSize.width * imageItems.count, scrollViewSize.height);
    for (int i = 0; i < imageItems.count; i++) {
        LIFocusImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height)];
        if (item.url) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"genius_default_ADImage_n"]];
        } else {
            imageView.image = item.image;
        }
        
        [scrollView addSubview:imageView];
    }
    
    self.scrollView = scrollView;
    self.pageControl = pageControl;
}

#pragma mark - ScrollView MOve
- (void)moveToTargetPage:(NSInteger)targetPage {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    CGFloat targetX = targetPage * self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
}

- (void)switchFocusImageItems {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    if (self.autoScrolling) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX {
    //    NSLog(@"moveToTargetPosition : %f" , targetX);
    if (targetX >= self.scrollView.contentSize.width) {
        targetX = 0.0;
    }
    
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    self.pageControl.currentPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
}

- (void)setAutoScrolling:(BOOL)enable {
    _autoScrolling = enable;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    if (_autoScrolling) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int tempPageIndex = (int)self.pageControl.currentPage;
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    //TODO 跳转到第一页
//    if ( ((scrollView.contentOffset.x / scrollView.frame.size.width) > self.pageControl.currentPage)
//        && (self.pageControl.currentPage == (self.pageControl.numberOfPages - 1))
//        ) {
//        self.pageControl.currentPage = 0;
//        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
    
    if (tempPageIndex != self.pageControl.currentPage) {
        if ([self.delegate respondsToSelector:@selector(focusImageView:didSelectPage:)]) {
            [self.delegate focusImageView:self didSelectPage:(int)self.pageControl.currentPage];
        }
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
