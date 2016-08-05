//
//  BarcodeScanView.m
//  HSBarcodeScanner
//
//  Created by LingBinXing on 15/5/22.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

@import AudioToolbox;
@import MobileCoreServices; // kUTTypeImage
@import AssetsLibrary;
#import "HSBarcodeScanView.h"
#import "PureLayout.h"
#import "UIImage+HSBundle.h"
#import "HSBarcodeScanner.h"
#import "NSBundle+Hundsun.h"
#import "UIColorAdditions.h"

static NSString * const kMainColorHex  = @"#51d3f5";
static NSString * const kFocusColorHex = @"#1d343a";

enum {
    LeftTop = 0,
    RightTop,
    LeftBottom,
    RightBottom
};

// 框大小300
static const CGFloat kCropSize = 240.0;

@interface BSButton : UIButton
@end

@interface HSBarcodeScanView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) UIView* overlayView;
@property (nonatomic, strong) UIView* scanAreaContainerView;
@property (nonatomic, strong) UIImageView* scanNetImageView;
@property (nonatomic, strong) NSArray* scanAreaCornerImageViews;

// 取消按钮
@property (nonatomic, strong) BSButton* cancelButton;
// 本地相册选取按钮
@property (nonatomic, strong) BSButton* localButton;
// 补光灯按钮
@property (nonatomic, strong) BSButton* torchButton;
@property (nonatomic, strong) UILabel* hintLabel;

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSArray* mainConstraints;
@property (nonatomic, strong) NSArray* scanNetImageConstraints;
@property (nonatomic, assign) BOOL isAnimatingToEndState;
@property (nonatomic, strong) HSBarcodeScanner* scanner;
@property (nonatomic, strong) NSNumber* feedbackSoundID; // SystemSoundID

@property (nonatomic, assign) CGRect scanAreaRect;
@end

@implementation HSBarcodeScanView
@synthesize feedbackSoundID = _feedbackSoundID;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoScan = YES;
        self.backgroundColor = [UIColor blackColor];
        self.scanAreaRect = CGRectZero;
        
        self.scanAreaContainerView = [[UIView alloc] initForAutoLayout];
        self.scanAreaContainerView.backgroundColor = [UIColor clearColor];
        self.scanAreaContainerView.clipsToBounds = YES;
        [self addSubview:self.scanAreaContainerView];
        
        UIImage* scanNetImage = [UIImage imageNamed:@"scan_net" inBundleNamed:kBarcodeScanner_bundle];
        self.scanNetImageView = [[UIImageView alloc] initWithImage:scanNetImage];
        [self.scanAreaContainerView addSubview:self.scanNetImageView];
        
        NSMutableArray* cornerImgViews = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger i = 1; i <= 4; ++i) {
            UIImage* img = [UIImage imageNamed:[NSString stringWithFormat:@"scan_%ld", (long)i] inBundleNamed:kBarcodeScanner_bundle];
            UIImageView* imgView = [[UIImageView alloc] initWithImage:img];
            [cornerImgViews addObject:imgView];
            [self.scanAreaContainerView addSubview:imgView];
        }
        self.scanAreaCornerImageViews = cornerImgViews.copy;
        
        
        NSString* i18n = nil;
        
        // 提示Label
        self.hintLabel = [[UILabel alloc] initForAutoLayout];
        i18n = HSLocalizedStringInBundle(@"QRHint", kBarcodeScanner_bundle, nil);
        self.hintLabel.text = i18n;
        self.hintLabel.backgroundColor = [UIColor clearColor];
        self.hintLabel.textColor = [UIColor colorWithHex:kMainColorHex];
        self.hintLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.hintLabel];
        
        // 取消按钮
        self.cancelButton = [[BSButton alloc] initForAutoLayout];
        i18n = HSLocalizedStringInBundle(@"btnCancel", kBarcodeScanner_bundle, nil);
        [self.cancelButton setTitle:i18n forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setImage:[UIImage imageNamed:@"HS_QR_Back.png" inBundleNamed:kBarcodeScanner_bundle] forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"HS_QR_Backpre.png" inBundleNamed:kBarcodeScanner_bundle] forState:UIControlStateHighlighted];
        
        // 本地选取按钮
        self.localButton = [[BSButton alloc] initForAutoLayout];
        i18n = HSLocalizedStringInBundle(@"QRbtnlocal", kBarcodeScanner_bundle, nil);
        [self.localButton setTitle:i18n forState:UIControlStateNormal];
        [self.localButton addTarget:self action:@selector(selectFromLocal:) forControlEvents:UIControlEventTouchUpInside];
        [self.localButton setImage:[UIImage imageNamed:@"HS_QR_Local.png" inBundleNamed:kBarcodeScanner_bundle] forState:UIControlStateNormal];
        [self.localButton setImage:[UIImage imageNamed:@"HS_QR_Localpre.png" inBundleNamed:kBarcodeScanner_bundle] forState:UIControlStateHighlighted];

        // 补光灯按钮
        self.torchButton = [[BSButton alloc] initForAutoLayout];
        i18n = HSLocalizedStringInBundle(@"QRbtntorch", kBarcodeScanner_bundle, nil);
        [self.torchButton setTitle:i18n forState:UIControlStateNormal];
        [self.torchButton addTarget:self action:@selector(setTorch:) forControlEvents:UIControlEventTouchUpInside];
        [self.torchButton setImage:[UIImage imageNamed:@"HS_QR_Light.png" inBundleNamed:kBarcodeScanner_bundle] forState:UIControlStateNormal];
        [self.torchButton setImage:[UIImage imageNamed:@"HS_QR_Lightpre.png" inBundleNamed:kBarcodeScanner_bundle] forState:UIControlStateHighlighted];

        for (UIButton* btn in @[self.cancelButton, self.localButton, self.torchButton]) {
            CGSize imgSize = [btn imageForState:UIControlStateNormal].size;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            CGSize strSize = [[btn titleForState:UIControlStateNormal] sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
#pragma clang diagnostic pop
            btn.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            btn.bounds = CGRectMake(0, 0, imgSize.width>strSize.width?imgSize.width:strSize.width, imgSize.height+strSize.height);
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(imgSize.height, -btn.bounds.size.width, 0, 0)];
            
            [btn setTitleColor:[UIColor colorWithHex:kMainColorHex] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHex:kFocusColorHex] forState:UIControlStateHighlighted];
            
            [self addSubview:btn];
        }

        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)dealloc
{
    // 需要显式析构声音资源
    self.feedbackSoundID = nil;
    [self stopScan];
}

- (void)setup
{
    if (self.scanner == nil) {
        self.scanner = [[HSBarcodeScanner alloc] initWithPreviewView:self];
    }

    self.scanAreaRect =
    CGRectMake((self.bounds.size.width - kCropSize) / 2,
               (self.bounds.size.height - kCropSize) / 2 / 1.35,
               kCropSize, kCropSize);
    
    // 实际扫描范围稍扩大，扩大系数 1/7
    CGFloat fraction = 1.0 / 7.0;
    CGSize oldSize = self.scanAreaRect.size;
    CGRect bounds = self.scanAreaRect;
    bounds.origin.x -= oldSize.width * fraction;
    bounds.origin.y -= oldSize.height * fraction;
    bounds.size.width += oldSize.width * fraction;
    bounds.size.height += oldSize.height * fraction;
    bounds = CGRectIntersection(bounds, self.bounds);
    bounds = CGRectIntegral(bounds);
    
    self.scanner.scanRect = [NSValue valueWithCGRect:bounds];
    if (self.autoScan) {
        [self doScan];
    }
    
    // 动画之前先布局初始状态一次
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    // 开始动画
    self.isAnimatingToEndState = YES;
    [self animateScanNetLayoutWithAnimation];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    UIWindow* window = self.window;
    if (window) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setup];
        });
    } else {
        [self stopScan];
        self.scanner = nil;
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    [self repositionSubviewsZOrder];
}

- (void)doScan
{
    BOOL hasTorch = self.scanner.hasTorch;
    [self.scanner startScanningWithResultBlock:^(NSString *code) {
        if (self.delegate) {
            [self.delegate barcodeScanView:self didScanWithResult:code];
        }
        [self playFeedbackSound];
        [self.scanner stopScanning];
    }];
    if (self.scanner.hasTorch != hasTorch) {
        // startScanning之后，补光灯配置有更新，重新布局界面
        self.didSetupConstraints = NO;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)startScan
{
    [self doScan];
}

- (void)stopScan
{
    [self.scanner stopScanning];
}

#pragma mark - Play sound

- (void)playFeedbackSound
{
    if (self.feedbackSoundID) {
        AudioServicesPlaySystemSound([self.feedbackSoundID unsignedIntValue]);
    }
}

#pragma mark - Events
- (void)cancel:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate barcodeScanView:self didPressCancelButton:sender];
    }
}

- (void)selectFromLocal:(UIButton *)sender
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {//iphone
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        UIViewController* targetViewController = nil;
        if (self.delegate) {
            targetViewController = [self.delegate targetViewControllerForImagePickerInBarcodeScanView:self];
        }
        if (targetViewController == nil) {
            targetViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        }
        [targetViewController presentViewController:ipc animated:YES completion:nil];
    }
    else {//ipad
#warning TODO: >= ios7/8? 新的picker
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:ipc];
        
        [pop presentPopoverFromRect:sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        pop.delegate = self;
    }
    [self stopScan];
}

- (void)setTorch:(UIButton *)sender
{
    [self.scanner setTorchOpened:![self.scanner isTorchOpened]];
}

- (void)decodeImage:(UIImage *)image
{
    if (image) {
        [HSBarcodeScanner scanFromImage:image.CGImage resultBlock:^(NSString *code) {
            if (self.delegate) {
                [self.delegate barcodeScanView:self didScanWithResult:code];
            }
        }];
    } else {
        if (self.delegate) {
            [self.delegate barcodeScanView:self didScanWithResult:nil];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage* image = info[UIImagePickerControllerOriginalImage];
            if (image) {
                [self decodeImage:image];
            } else {
                NSURL* refURL = info[UIImagePickerControllerReferenceURL];
                if (refURL) {
                    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                    [assetLibrary assetForURL:refURL resultBlock:^(ALAsset *asset) {
                        
                        ALAssetRepresentation *rep = [asset defaultRepresentation];
                        Byte *buffer = (Byte*)malloc((size_t)rep.size);
                        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
                        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                        UIImage* assetImage = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                        [self decodeImage:assetImage];
                        
                    } failureBlock:^(NSError *err) {
                        [self decodeImage:nil];
                    }];
                } else {
                    [self decodeImage:nil];
                }
            }
        }
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self doScan];

    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self doScan];
    
    [popoverController dismissPopoverAnimated:YES];
}

#pragma mark - Layout & Animation
- (void)repositionSubviewsZOrder
{
    [self bringSubviewToFront:self.scanAreaContainerView];
    [self bringSubviewToFront:self.hintLabel];
    for (UIButton* btn in @[self.cancelButton, self.localButton, self.torchButton]) {
        [self bringSubviewToFront:btn];
    }
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        self.didSetupConstraints = YES;
        
        [self.mainConstraints autoRemoveConstraints];
        
        self.mainConstraints = [UIView autoCreateConstraintsWithoutInstalling:^{
            
            for (UIView* sub in self.subviews) {
                if (self.scanner) {
                    sub.hidden = NO;
                } else {
                    sub.hidden = YES;
                }
            }
            
            [self.scanAreaContainerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.scanAreaRect.origin.y];
            [self.scanAreaContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.scanAreaRect.origin.x];
            [self.scanAreaContainerView autoSetDimensionsToSize:self.scanAreaRect.size];
            
            [self.scanAreaCornerImageViews[LeftTop] autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [self.scanAreaCornerImageViews[LeftTop] autoPinEdgeToSuperviewEdge:ALEdgeTop];
            
            [self.scanAreaCornerImageViews[RightTop] autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [self.scanAreaCornerImageViews[RightTop] autoPinEdgeToSuperviewEdge:ALEdgeTop];
            
            [self.scanAreaCornerImageViews[LeftBottom] autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [self.scanAreaCornerImageViews[LeftBottom] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-2];
            
            [self.scanAreaCornerImageViews[RightBottom] autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [self.scanAreaCornerImageViews[RightBottom] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-2];
            
            [self.hintLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.scanAreaContainerView withOffset:-2];
            [self.hintLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            
            NSArray* btns = nil;
            if ([self.scanner hasTorch]) {
                self.torchButton.hidden = NO;
                btns = @[self.cancelButton, self.localButton, self.torchButton];
            } else {
                self.torchButton.hidden = YES;
                btns = @[self.cancelButton, self.localButton];
                
                [self.torchButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:btns.lastObject];
                [self.torchButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:btns.lastObject];
            }
            
            CGSize maxSize = CGSizeZero;
            for (UIButton* btn in btns) {
                if (btn.bounds.size.width > maxSize.width) {
                    maxSize.width = btn.bounds.size.width;
                }
                if (btn.bounds.size.height > maxSize.height) {
                    maxSize.height = btn.bounds.size.height;
                }
            }
            [[btns firstObject] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scanAreaContainerView withOffset:10];
            [btns autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSize:maxSize.width insetSpacing:YES];
        }];
        [self.mainConstraints autoInstallConstraints];
    }
    
    [self.scanNetImageConstraints autoRemoveConstraints];
    
    if (self.isAnimatingToEndState) {
        self.scanNetImageConstraints = [self.scanNetImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    } else {
        UIEdgeInsets insetBegin = UIEdgeInsetsZero;
        CGFloat scanAreaHeight = self.scanAreaRect.size.height;
        insetBegin.top -= scanAreaHeight;
        insetBegin.bottom += scanAreaHeight;
        
        self.scanNetImageConstraints = [self.scanNetImageView autoPinEdgesToSuperviewEdgesWithInsets:insetBegin];
    }
    
    [super updateConstraints];
}

- (void)animateScanNetLayoutWithAnimation
{
    self.scanNetImageView.alpha = 0.75;
    
    if (!self.isAnimatingToEndState) {
        
        if (self.window) {
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
            [self layoutIfNeeded];
            
            self.isAnimatingToEndState = !self.isAnimatingToEndState;
            [self animateScanNetLayoutWithAnimation];
        }

    } else {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];

        [UIView animateWithDuration:1.45
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.scanNetImageView.alpha = 1.0;
                             [self layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             
                             self.isAnimatingToEndState = !self.isAnimatingToEndState;
                             if (self.window) {
                                 // 在底部稍微停留一点时间，再继续
                                 [UIView animateWithDuration:0.5 animations:^{
                                     self.scanNetImageView.alpha = 0.0;
                                 } completion:^(BOOL finished) {
                                     if (self.window) {
                                         [self animateScanNetLayoutWithAnimation];
                                     }
                                 }];
                             }
                         }];
    }
}

#pragma mark - Property

- (void)setScanAreaRect:(CGRect)scanAreaRect
{
    if (!CGRectEqualToRect(_scanAreaRect, scanAreaRect)) {
        _scanAreaRect = scanAreaRect;
        self.didSetupConstraints = NO;
    }
}

- (NSNumber *)feedbackSoundID
{
    if (_feedbackSoundID == nil) {
        NSString* path = [kBarcodeScanner_bundle stringByAppendingPathComponent:@"scan"];
        NSURL* URL = [[NSBundle mainBundle] URLForResource:path withExtension:@"wav"];
        SystemSoundID soundID = 0;
        OSStatus s = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(URL), &soundID);
        if (s == noErr) {
            _feedbackSoundID = @(soundID);
        }
    }
    return _feedbackSoundID;
}

- (void)setFeedbackSoundID:(NSNumber *)feedbackSoundID
{
    if (_feedbackSoundID != feedbackSoundID) {
        if (_feedbackSoundID) {
            __unused OSStatus s = AudioServicesDisposeSystemSoundID([_feedbackSoundID unsignedIntValue]);
        }
        _feedbackSoundID = feedbackSoundID;
    }
}

@end

@implementation BSButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    {
        CGRect frame = self.imageView.frame;
        frame.origin.x = (self.bounds.size.width - frame.size.width) / 2;
        self.imageView.frame = frame;
    }
    {
        CGRect frame = self.titleLabel.frame;
        frame.origin.x = (self.bounds.size.width - frame.size.width) / 2;
        self.titleLabel.frame = frame;
    }
}

@end
