//
//  JDXPWebViewController.m
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDXPWebViewController.h"
#import "LIAppUtils.h"
#import "Masonry.h"
#import "NSStringAdditions.h"

#import "XPNavigationBar.h"

@interface JDXPWebViewController()<UIWebViewDelegate>
@property (nonatomic, strong) XPNavigationBar *topView;
@property(nonatomic,strong) UIWebView *m_webView;
@end


@implementation JDXPWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.m_webView];
    
    [self loadWebWithUrl:self.protocolUrl];
    
    [self layoutPageSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.m_webView.delegate = nil;
    [LIAppUtils hideLoadIng];
}

#pragma mark attribute
- (void)loadWebWithUrl:(NSString*)url
{
    NSURL *webUrl = [NSURL URLWithString:url];
    [self.m_webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
}

#pragma mark web delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [LIAppUtils startLoadIng:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [LIAppUtils hideLoadIng];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [LIAppUtils showLoadInfo:@"加载失败"];
}

#pragma mark - response

- (void)doBackAciton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private mothed

- (void)layoutPageSubviews {
    __weak typeof(self) weakSelf = self;
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.and.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(64);
    }];
    
    [self.m_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
        make.left.bottom.and.right.mas_equalTo(weakSelf.view);
    }];
    
}

#pragma mark - setter and getter


- (XPNavigationBar *)topView {
    if (!_topView) {
        _topView = [[XPNavigationBar alloc] initWithTarget:self];
        _topView.title = self.protocolTitle;
        [_topView addDefaultBackButton];
    }
    
    return _topView;
}

-(UIWebView *)m_webView{
    if (_m_webView == nil) {
        _m_webView = [[UIWebView alloc] init];
        _m_webView.delegate = self;
        _m_webView.scalesPageToFit = YES;
    }
    return _m_webView;
}

@end

