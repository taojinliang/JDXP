//
//  XPFXViewController.m
//  JDXP
//
//  Created by MacBookPro on 16/1/21.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "XPFXViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UtilsMacro.h"
#import "LIAppMacro.h"

#import "DataToolManager.h"
#import "FXImageModel.h"
#import "LIHttpClient.h"
#import "XPNavigationBar.h"
#import "FXImageTableViewCell.h"
#import "JDXPWebViewController.h"

#define kImageCellHeight 250

@interface XPFXViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) XPNavigationBar *navBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation XPFXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化本界面数据
    [self initWithData];
    // 初始化UI
    [self initWithUI];
}

-(void)initWithData{
    self.imageArray = [NSMutableArray array];
    //TODO:
    [self requestImages];
}

-(void)initWithUI{
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    
    [self layoutPageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -请求图片
-(void)requestImages{
    [[LIHttpClient shareManager] sendRequest:[[DataToolManager shareManager] LWS_JP_URL] completionHandler:^(NSInteger errorNo, NSDictionary *dict) {
        if (errorNo == 0) {
            NSArray *array = dict[@"data"][@"items"];
            for (NSDictionary *dic in array) {
                FXImageModel *model = [[FXImageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.imageArray addObject:model];
            }
            
            if ([self.imageArray count]*kImageCellHeight > SCREEN_HEIGHT) {
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([self.imageArray count]*kImageCellHeight);
                }];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXImageTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FXImageTableViewCell class])];
    if (cell==nil) {
        cell=[[FXImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FXImageTableViewCell class])];
    }
    
    FXImageModel* model = self.imageArray[indexPath.row];
    [cell loadData:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kImageCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JDXPWebViewController *web = [[JDXPWebViewController alloc] init];
    FXImageModel* model = self.imageArray[indexPath.row];
    web.protocolTitle = model.short_title;
    web.protocolUrl = model.url;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark -layoutPageSubviews
- (void)layoutPageSubviews {
    @WeakObj(self);
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(selfWeak.view);
        make.height.mas_equalTo(64);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selfWeak.navBar.mas_bottom);
        make.left.bottom.and.right.equalTo(selfWeak.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(selfWeak.scrollView);
        make.width.equalTo(selfWeak.scrollView);
    }];
    

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(selfWeak.contentView);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(selfWeak.tableView.mas_bottom);
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

-(XPNavigationBar *)navBar{
    if (_navBar == nil) {
        _navBar = [[XPNavigationBar alloc] initWithTarget:self];
        _navBar.title = @"发现";
    }
    return _navBar;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FXImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FXImageTableViewCell class])];
    }
    
    return _tableView;
}
@end
