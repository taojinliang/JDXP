//
//  JDMEViewController.m
//  JDXP
//
//  Created by MacBookPro on 16/1/21.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDMEViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UtilsMacro.h"
#import "LIAppMacro.h"


@interface JDMEViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation JDMEViewController

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
    
    
    [self layoutPageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPageSubviews {
    @WeakObj(self);

    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(selfWeak.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(selfWeak.scrollView);
        make.width.equalTo(selfWeak.scrollView);
    }];
}

#pragma mark - setter and getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    
    return _contentView;
}

@end

