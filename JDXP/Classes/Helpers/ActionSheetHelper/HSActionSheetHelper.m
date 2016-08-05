/******************************************************************
 文件名称: HSActionSheetHelper
 系统名称: 领投宝
 模块名称: 客户端
 类 名 称: HSActionSheetHelper
 软件版权: 恒生电子股份有限公司
 功能说明: 帮助类：显示一个在屏幕下方的弹出视图（类似UIActionSheet的弹出方式）
 系统版本:
 开发人员: taojl
 开发时间: 15-06-03
 审核人员:
 相关文档:
 修改记录: 需求编号 修改日期 修改人员 修改说明
 
 ******************************************************************/


#import "HSActionSheetHelper.h"
#import "UtilsMacro.h"

typedef void(^TouchOverlayBlock)();

@interface _ASH_OverlayView : UIView
@property (nonatomic, copy) TouchOverlayBlock touchBlock;
@end
@implementation _ASH_OverlayView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchBlock) {
        self.touchBlock();
    }
}
@end

@interface _HSFakeInputHolder : UIView
@property (nonatomic, readwrite, retain) UIView *inputView;
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;
@property (nonatomic, weak) _ASH_OverlayView* overlayView;
@property (nonatomic, copy) TouchOverlayBlock touchBlock;
@end
@implementation _HSFakeInputHolder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 本视图仅用于展示 inputView，故其本身不需要显示
        self.alpha = 0.0;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (BOOL)becomeFirstResponder
{
    BOOL b = NO;
    @try {
        b = [super becomeFirstResponder];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception);
    }
    if (b) {
        // 弹出内容视图的时候，显示overlay
        [self showHideOverlay:YES];
    }
    return b;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}
- (BOOL)resignFirstResponder
{
    BOOL b = NO;
    @try {
        b = [super resignFirstResponder];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception);
    }
    if (b) {
        // 隐藏内容视图的时候，隐藏overlay
        [self showHideOverlay:NO];
    }
    return b;
}

- (void)showHideOverlay:(BOOL)show
{
    _ASH_OverlayView* overlayView = self.overlayView;
    if (overlayView == nil) {
        NSParameterAssert(show);
        
        UIWindow* window = [[self class] findAppropriateWindow];
        overlayView = [[_ASH_OverlayView alloc] initWithFrame:window.bounds];
        overlayView.touchBlock = self.touchBlock;
        self.overlayView = overlayView;
        
        overlayView.userInteractionEnabled = YES;
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor blackColor];
        [window addSubview:overlayView];
    }
    
    CGFloat beginAlpha = 0, endAlpha = 0;
    if (show) {
        beginAlpha = 0;
        endAlpha = 0.5;
    } else {
        beginAlpha = 0.5;
        endAlpha = 0;
    }
    
    overlayView.alpha = beginAlpha;
    
    [UIView animateWithDuration:0.25 animations:^{
        overlayView.alpha = endAlpha;
    } completion:^(BOOL finished) {
        if (!show) {
            [self.overlayView removeFromSuperview];
            self.overlayView = nil;
        }
    }];
}

+ (UIWindow *)findAppropriateWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            return window;
        }
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

@end

@interface _HS_UIInputViewSubclass : UIInputView
@property (nonatomic, strong) UIView* contentView;
@end
@implementation _HS_UIInputViewSubclass
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}
@end

@interface _HS_UIViewSubclass : UIView
@property (nonatomic, strong) UIView* contentView;
@end
@implementation _HS_UIViewSubclass
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}
@end


@interface HSActionSheetHelper ()
{
    UINavigationBar* _navigationBar;
    __weak _HSFakeInputHolder* _fakeInputHolder;
    UIView* _contentView;
}
@end

@implementation HSActionSheetHelper
@synthesize navigationBar = _navigationBar;

- (instancetype)initWithContentView:(UIView *)contentView
{
    self = [super init];
    if (self) {
        
        Class UIInputViewClass = NSClassFromString(@"UIInputView");
        if (UIInputViewClass) { // >= iOS7 动态模糊
            _HS_UIInputViewSubclass* containerView = [[_HS_UIInputViewSubclass alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleDefault];
            _contentView = containerView;
            containerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.55];
            containerView.contentView = contentView;
        } else { // < iOS7 没有模糊
            _HS_UIViewSubclass* containerView = [[_HS_UIViewSubclass alloc] init];
            _contentView = containerView;
            containerView.backgroundColor = [UIColor whiteColor];
            containerView.contentView = contentView;
        }
        
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_contentView addSubview:contentView];
    }
    return self;
}

- (void)showLifecycleSameAsView:(UIView *)view
{
    _HSFakeInputHolder* fakeInputHolder = [[_HSFakeInputHolder alloc] init];
    _fakeInputHolder = fakeInputHolder;
//    @weakify(self);
    fakeInputHolder.touchBlock = ^{
//        @strongify(self);
        if (self) {
            [self pressedLeftBarButton:nil];
        }
    };

    // fix bug: http://stackoverflow.com/a/19779365
    if ([_contentView isKindOfClass:[_HS_UIInputViewSubclass class]]) {
        _HS_UIInputViewSubclass* v = (_HS_UIInputViewSubclass*)_contentView;
        [v.contentView layoutIfNeeded];
    } else if ([_contentView isKindOfClass:[_HS_UIViewSubclass class]]) {
        _HS_UIViewSubclass* v = (_HS_UIViewSubclass*)_contentView;
        [v.contentView layoutIfNeeded];
    }
    
    _contentView.frame = CGRectZero; // <== iOS9 SDK 编译必须加这句
    fakeInputHolder.inputView = _contentView;
    fakeInputHolder.inputAccessoryView = self.navigationBar;
    [view addSubview:fakeInputHolder];
    [fakeInputHolder becomeFirstResponder];
}
- (void)dismiss
{
    [_fakeInputHolder resignFirstResponder];
    [_fakeInputHolder removeFromSuperview];
    _fakeInputHolder = nil;
}

- (void)pressedLeftBarButton:(id)sender
{
    [self dismiss];
    if (self.delegate) {
        [self.delegate cancelActionSheet:self];
    }
}
- (void)pressedRightBarButton:(id)sender
{
    [self dismiss];
    if (self.delegate) {
        [self.delegate doneActionSheet:self];
    }
}

#pragma mark - property
- (UINavigationBar *)navigationBar
{
    if (_navigationBar == nil) {
        _navigationBar = [[UINavigationBar alloc] init];
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@""];

        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleDone target: self action: @selector(pressedLeftBarButton:)];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStyleDone target: self action: @selector(pressedRightBarButton:)];
        naviItem.leftBarButtonItem = leftButton;
        naviItem.rightBarButtonItem = rightButton;
        
        _navigationBar.items = @[naviItem];
    }
    return _navigationBar;
}

- (void)setTitle:(NSString *)title
{
    UINavigationItem *naviItem = [self.navigationBar.items lastObject];
    naviItem.title = [title copy];
}
- (NSString *)title
{
    UINavigationItem *naviItem = [self.navigationBar.items lastObject];
    return [naviItem.title copy];
}

@end
