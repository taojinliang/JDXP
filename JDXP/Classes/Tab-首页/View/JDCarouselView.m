//
//  JDCarouselView.m
//  JDXP
//
//  Created by MacBookPro on 16/1/26.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDCarouselView.h"
#import "JDCarouselCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "LIAppMacro.h"

#define REUSE_IDENTIFIER [JDCarouselCollectionCell description]

#define MIN_MOVING_TIMEINTERVAL 0.1 //最小滚动时间间隔
#define DEFAULT_MOVING_TIMEINTERVAL 3.0 //默认滚动时间间隔

@interface JDCarouselView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/**
 *  定时器
 */
@property(nonatomic, strong) NSTimer *timer;
@end


@implementation JDCarouselView
@synthesize imageURLs = _imageURLs;

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.collectionViewLayout = layout;
        [self registerClass:[JDCarouselCollectionCell class] forCellWithReuseIdentifier:REUSE_IDENTIFIER];
        [self registerNofitication];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -Public Method
-(void)startMoving{
    //大于等于2张图时，才自动轮播，因此UIScrollerViewDelegate不需要考虑0张图或一张图的情况
    if (![self isOnlyOneOrNoPage:self.imageURLs]) {
        [self addTimer];
    }
}

-(void)stopMoving{
    [self removeTimer];
}

#pragma mark - Private Method
-(void)addTimer{
    [self removeTimer];
    NSTimeInterval speed = self.movingTimeInterval < MIN_MOVING_TIMEINTERVAL ? DEFAULT_MOVING_TIMEINTERVAL : self.movingTimeInterval;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveToNextPage) userInfo:nil repeats:YES];
}

-(void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)moveToNextPage{
    CGPoint newContentOffset = (CGPoint){self.contentOffset.x + SCREEN_WIDTH,0};
    [self setContentOffset:newContentOffset animated:YES];
}

-(void)adjustCurrentPage:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH - 1;
    
    if (scrollView.contentOffset.x < SCREEN_WIDTH) {
        page = [self.imageURLs count] - 3;
    }else if (scrollView.contentOffset.x > SCREEN_WIDTH*([self.imageURLs count] - 1)){
        page = 0;
    }
    
    if ([self.pageDelegate respondsToSelector:@selector(carousel:didMoveToPage:)]) {
        [self.pageDelegate carousel:self didMoveToPage:page];
    }
}

-(void)registerNofitication{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //至少有一张图，如果self.imageURLs.count = 0显示占位图
    return MAX([self.imageURLs count], 1);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JDCarouselCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSE_IDENTIFIER forIndexPath:indexPath];
    
    if (![self.imageURLs count]) {
        [cell.imageView setImage:self.placeholder];
        return cell;
    }
    
    [cell.imageView sd_setImageWithURL:[self.imageURLs objectAtIndex:indexPath.item] placeholderImage:self.placeholder];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger page = 0;
    NSUInteger lastIndex;
    if (![self isOnlyOneOrNoPage:self.imageURLs]) {
        lastIndex = [self.imageURLs count] - 2;
    }else{
        lastIndex = 0;
    }
    
    if (indexPath.item == 0) {
        page = 0;
    }else if (indexPath.item == lastIndex){
        page = lastIndex - 1;
    }else{
        page = indexPath.item - 1;
    }
    
    if ([self.pageDelegate respondsToSelector:@selector(carousel:didTouchToPage:)]) {
        [self.pageDelegate carousel:self didTouchToPage:page];
    }
}

#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == ([self.imageURLs count] - 1) * SCREEN_WIDTH) {
        [self setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    }

    //轮播滚动的时候 移动到了哪一页
    [self adjustCurrentPage:scrollView];
}


/**
 *  用户手动拖拽，暂停一下自动轮播
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

/**
 *  用户拖拽完成，恢复自动轮播（如果需要的话）并依据滑动方向来进行相应对应的界面变化
 *
 *  @param scrollView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.isAutoMoving) {
        [self addTimer];
    }
    
    //向左滑动时切换imageView
    if (scrollView.contentOffset.x < SCREEN_WIDTH) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.imageURLs count]-2 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    //向右滑动时切换imageView
    if (scrollView.contentOffset.x > ([self.imageURLs count] - 1) * SCREEN_WIDTH - 10) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    //用户手动拖拽的时候 移动到了哪一页
    [self adjustCurrentPage:scrollView];
}

#pragma mark - Notification
/**
 *  程序暂停的时候，应该停止计时器
 */
-(void)applicationWillResignActive{
    [self stopMoving];
}

/**
 *  程勋从暂停状态回归的时候，重新启动计时器
 */
-(void)applicationDidBecomeActive{
    if (self.isAutoMoving) {
        [self startMoving];
    }
}


#pragma mark -Getter and Setter
-(NSArray *)imageURLs{
    if (_imageURLs == nil) {
        _imageURLs = [NSArray array];
    }
    return _imageURLs;
}

-(void)setImageURLs:(NSArray *)imageURLs{
    _imageURLs = imageURLs;
    if ([imageURLs count]) {
        NSMutableArray *arr = [NSMutableArray array];
        if (![self isOnlyOneOrNoPage:imageURLs]) {
            [arr addObject:[imageURLs lastObject]];
        }
        [arr addObjectsFromArray:imageURLs];
        if (![self isOnlyOneOrNoPage:imageURLs]) {
           [arr addObject:[imageURLs firstObject]];
        }
        _imageURLs = [NSArray arrayWithArray:arr];
    }
    [self reloadData];
    
    if ([imageURLs count]) {
        NSInteger currentPageInternalIndex = [self isOnlyOneOrNoPage:imageURLs] ? 0 : 1;
        //最左边一张图其实是最后一张图，因此移动到第二张图，也就是imageURL的第一个URL的图。
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPageInternalIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }

}

/**
 *  0张图或一张图的情况
 *
 *  @param imageURLs
 *
 *  @return BOOL
 */
- (BOOL)isOnlyOneOrNoPage:(NSArray *)imageURLs
{
    return [imageURLs count] <= 1;
}
@end
