//
//  HSBarcodeScanViewController.m
//  BreezeLib
//
//  Created by LingBinXing on 15/5/26.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "HSBarcodeScanViewController.h"

@interface HSBarcodeScanViewController ()
@end

@implementation HSBarcodeScanViewController

- (void)loadView
{
    HSBarcodeScanView* scanView = [[HSBarcodeScanView alloc] init];
    scanView.autoScan = NO;
    self.view = scanView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (HSBarcodeScanView *)scanView
{
    return (HSBarcodeScanView *)self.view;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.scanView startScan];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.scanView stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
