//
//  JDSYViewController.m
//  JDXP
//
//  Created by MacBookPro on 16/1/21.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDSYViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "LIAppUtils.h"
#import "UtilsMacro.h"
#import "NotificationMacro.h"
#import "UIImageView+WebCache.h"

#import "DataToolManager.h"
#import "JDSYNavigationBar.h"
#import "JDCarouselView.h"
#import "HSBarcodeScanViewController.h"
#import "JDMenuView.h"

#define ADCarouselHeight 200


@interface JDSYViewController ()<UIScrollViewDelegate,JDCarouselDelegate,JDSYNavigationBarDelegate,HSBarcodeScanViewDelegate,JDMenuViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
/**
 *  广告滚动栏
 */
@property (nonatomic, strong) JDCarouselView *carouselView;
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  首页菜单栏
 */
@property (nonatomic, strong) JDMenuView *menuView;

@property (nonatomic, strong) UIImageView *AppleView;
/**
 *  测试视图
 */
@property (nonatomic, strong) UIView *testView;
/**
 *  首页导航栏
 */
@property (nonatomic, strong) JDSYNavigationBar *navBar;
/**
 *  必须要WEAK，否则会循环引用
 */
@property (nonatomic, weak) HSBarcodeScanViewController* scanController;
@end

@implementation JDSYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化本界面数据
    [self initWithData];
    // 初始化UI
    [self initWithUI];
}

-(void)initWithData{

}

-(void)initWithUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.carouselView];
    [self.contentView addSubview:self.pageControl];
    [self.contentView addSubview:self.menuView];
    [self.contentView addSubview:self.AppleView];
    [self.contentView addSubview:self.testView];
    
    [self.view addSubview:self.navBar];
    
    [self layoutPageSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.carouselView startMoving];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.carouselView stopMoving];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - JDSYNavigationBarDelegate
-(void)gotoNavBarSearchPage{
    [LIAppUtils showAlertViewWithTitle:@"" message:@"跳转搜索页面"];
}

-(void)gotoNavBarVoicePage{
    [LIAppUtils showAlertViewWithTitle:@"" message:@"语音识别"];
}

-(void)gotoNavBarScanPage{
    HSBarcodeScanViewController* widController = [[HSBarcodeScanViewController alloc] init];
    self.scanController = widController;
    widController.scanView.delegate = self;
    [self.navigationController presentViewController:widController animated:YES completion:nil];
}

-(void)gotoNavBarMessagePage{
    [LIAppUtils showAlertViewWithTitle:@"" message:@"消息"];
}

#pragma mark - HSBarcodeScanViewDelegate
- (void)barcodeScanView:(HSBarcodeScanView *)barcodeScanView didScanWithResult:(NSString *)result
{
    [self.scanController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    DLog(@"%@",result);

}

- (void)barcodeScanView:(HSBarcodeScanView *)barcodeScanView didPressCancelButton:(UIButton *)cancelButton
{
    [self.scanController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)targetViewControllerForImagePickerInBarcodeScanView:(HSBarcodeScanView *)barcodeScanView
{
    return self.scanController;
}

#pragma mark - JDMenuViewDelegate
-(void)gotoJDMenuPage:(NSInteger)index{
    NSString *string = [[[[self imageURLs_Title] objectAtIndex:index] allKeys] objectAtIndex:0];
    [LIAppUtils showAlertViewWithTitle:@"" message:string];
}

#pragma mark -配置 图片数据 标题数据
/**
 *  首页广告栏图片数据
 *
 *  @return
 */
-(NSArray *)imageURLs{
    return [[DataToolManager shareManager] JDSYCarouselImages];
}

/**
 *  首页菜单栏数据
 *
 *  @return
 */
-(NSArray *)imageURLs_Title{
    NSMutableArray *reslutArray = [NSMutableArray array];
    NSArray *images = [[DataToolManager shareManager] JDSYMenuImages];
    NSArray *titles = [[DataToolManager shareManager] JDSYMenuTitles];
    for (NSInteger i = 0; i < [images count]; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:images[i] forKey:titles[i]];
        [reslutArray addObject:dict];
    }
    return reslutArray;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat tmp = offsetY > ADCarouselHeight ? ADCarouselHeight : offsetY;
    self.navBar.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:tmp/ADCarouselHeight];
    [self.navBar changeAlpha:(tmp/ADCarouselHeight)];
    if (offsetY < 0) {
        [UIView animateWithDuration:0.5 animations:^{
        } completion:^(BOOL finished) {
            self.navBar.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
        } completion:^(BOOL finished) {
            self.navBar.alpha = 1;
        }];
    }
}

#pragma mark -JDCarouselDelegate
-(void)carousel:(JDCarouselView *)carousel didMoveToPage:(NSInteger)page{
//    DLog(@"didMoveToPage %ld",(long)page);
    self.pageControl.currentPage = page;
}

-(void)carousel:(JDCarouselView *)carousel didTouchToPage:(NSInteger)page{
    DLog(@"didTouchToPage %ld",(long)page);
}


#pragma mark -布局
- (void)layoutPageSubviews {
    @WeakObj(self)
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(selfWeak.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(selfWeak.scrollView);
        make.width.equalTo(selfWeak.scrollView);
    }];
    
    [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(selfWeak.contentView);
        make.height.mas_equalTo(ADCarouselHeight);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selfWeak.contentView.mas_centerX);
        make.left.right.mas_equalTo(selfWeak.contentView);
        make.top.mas_equalTo(selfWeak.contentView.mas_top).offset(ADCarouselHeight-20);
        make.bottom.mas_equalTo(selfWeak.contentView.mas_top).offset(ADCarouselHeight);
    }];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.carouselView.mas_bottom);
        make.left.right.mas_equalTo(selfWeak.contentView);
        make.height.mas_equalTo(150);
    }];
    
    [self.AppleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.menuView.mas_bottom).offset(0.5);
        make.left.right.mas_equalTo(selfWeak.contentView);
        make.height.mas_equalTo(100);
    }];
    
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.AppleView.mas_bottom);
        make.left.right.mas_equalTo(selfWeak.contentView);
        make.height.mas_equalTo(1000);
    }];

    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(selfWeak.testView.mas_bottom);
    }];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(selfWeak.view);
        make.height.mas_equalTo(64);
    }];
}

#pragma mark - setter and getter

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    
    return _contentView;
}

-(JDCarouselView *)carouselView{
    if (_carouselView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _carouselView = [[JDCarouselView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _carouselView.imageURLs = [self imageURLs];
        _carouselView.placeholder = [UIImage imageNamed:@"placeholder"];
        _carouselView.pageDelegate = self;
        _carouselView.autoMoving = YES;
        _carouselView.movingTimeInterval = 2.0f;
    }
    return _carouselView;
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = [[self imageURLs] count];
    }
    return _pageControl;
}

-(JDMenuView *)menuView{
    if (_menuView == nil) {
        _menuView = [[JDMenuView alloc] init];
        _menuView.delegate = self;
        [_menuView loadData:[self imageURLs_Title]];
    }
    return _menuView;
}

-(UIImageView *)AppleView{
    if (_AppleView == nil) {
        _AppleView = [[UIImageView alloc] init];
        [_AppleView sd_setImageWithURL:[[DataToolManager shareManager] JDSYMenuNextImage]];
    }
    return _AppleView;
}

- (UIView *)testView {
    if (_testView == nil) {
        _testView = [[UIView alloc] init];
        _testView.backgroundColor = [UIColor clearColor];
    }
    
    return _testView;
}

-(JDSYNavigationBar *)navBar{
    if (!_navBar) {
        _navBar = [[JDSYNavigationBar alloc] init];
        _navBar.backgroundColor = [UIColor clearColor];
        _navBar.barDelegate = self;
    }
    return _navBar;
}

@end
