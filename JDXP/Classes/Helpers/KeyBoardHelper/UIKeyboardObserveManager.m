//
//  UIKeyboardObserveManager.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/8/6.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "UIKeyboardObserveManager.h"
#import "UIKeyBoardViewFinder.h"

static const NSTimeInterval kKeyboardAnimationMinDuration = 0.25;

CFMutableSetRef WLSetCreateMutableWeakPointer()
{
    CFSetCallBacks callBack = kCFTypeSetCallBacks;
    // weak pointer
    callBack.retain = NULL;
    callBack.release = NULL;
    
    return CFSetCreateMutable(NULL, 0, &callBack);
}

CFMutableArrayRef WLArrayCreateMutableWeakPointer()
{
    CFArrayCallBacks callBack = kCFTypeArrayCallBacks;
    // weak pointer
    callBack.retain = NULL;
    callBack.release = NULL;
    
    return CFArrayCreateMutable(NULL, 0, &callBack);
}

static Boolean PointerEqual(const void *ptr1, const void *ptr2) {
    return ptr1 == ptr2;
}
static CFHashCode PointerHash(const void *ptr) {
    return (CFHashCode)(ptr);
}

CFMutableDictionaryRef WLDictionaryCreateMutableWeakPointerToWeakPointer()
{
    CFDictionaryKeyCallBacks kcb = kCFTypeDictionaryKeyCallBacks;
    
    // weak, pointer keys
    kcb.retain = NULL;
    kcb.release = NULL;
    kcb.equal = PointerEqual;
    kcb.hash = PointerHash;
    
    CFDictionaryValueCallBacks vcb = kCFTypeDictionaryValueCallBacks;
    
    // weak, pointer values
    vcb.retain = NULL;
    vcb.release = NULL;
    vcb.equal = PointerEqual;
    
    return CFDictionaryCreateMutable(NULL, 0, &kcb, &vcb);
}

CFMutableDictionaryRef WLDictionaryCreateMutableWeakPointerToStrongObject()
{
    CFDictionaryKeyCallBacks kcb = kCFTypeDictionaryKeyCallBacks;
    
    // weak, pointer keys
    kcb.retain = NULL;
    kcb.release = NULL;
    kcb.equal = PointerEqual;
    kcb.hash = PointerHash;
    
    // strong, object values
    CFDictionaryValueCallBacks vcb = kCFTypeDictionaryValueCallBacks;
    
    return CFDictionaryCreateMutable(NULL, 0, &kcb, &vcb);
}

UIViewAnimationOptions UIViewAnimationOptionsConvertFromUIViewAnimationCurve(UIViewAnimationCurve curve)
{
    UIViewAnimationOptions options = 0;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            options = UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            options = UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            options = UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            options = UIViewAnimationOptionCurveLinear;
            break;
        default:
            options = UIViewAnimationOptionCurveEaseInOut;
            break;
    }
    return options;
}

@interface SenderInfo : NSObject
@property (nonatomic, assign) id <UIKeyboardObserveManagerDelegate> delegate;
@property (nonatomic, assign) BOOL enableAutoAdjustContainerView;
@property (nonatomic, assign) CGFloat inputViewBottomToKeyboardTopOffset;
@end

@implementation SenderInfo
@end

#pragma mark - UIKeyboardShowHideObserver
@interface UIKeyboardObserveManager ()
@property (assign, nonatomic, readonly) CGFloat visibleKeyboardHeight;
@property (assign, nonatomic, readonly) id currentEditingWeakSender;
@property (assign, nonatomic, getter=isKeyboardShowing) BOOL keyboardShowing;
// 缓存的容器
@property (nonatomic, retain) UIView* cachedContainerView;
@property (nonatomic, assign) CGRect cachedContainerFrame;

//---------- 以下 3 个容器不能 Toll-Free, 因为其元素使用弱引用 ----------

// 内部元素: 弱引用
@property (nonatomic, retain) NSObject* /*CFMutableSetRef*/ weakSenderSet;
// 内部元素: 弱引用 id (weakSender) -> 强引用 SenderInfo* (info)
@property (nonatomic, retain) NSObject* /*CFMutableDictionaryRef*/ weakSenderToInfoDict;
// 内部元素: 弱引用
@property (nonatomic, retain) NSObject* /*CFMutableArrayRef*/ weakSenderStack;
@end

@implementation UIKeyboardObserveManager
@dynamic visibleKeyboardView, visibleKeyboardHeight, currentEditingWeakSender;

+ (instancetype)sharedManager
{
    static UIKeyboardObserveManager* s_mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_mgr = [[UIKeyboardObserveManager alloc] init];
    });
    return s_mgr;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self addKeyboardObserver];
        self.weakSenderSet = CFBridgingRelease(WLSetCreateMutableWeakPointer());
        self.weakSenderToInfoDict = CFBridgingRelease(WLDictionaryCreateMutableWeakPointerToStrongObject());
        self.weakSenderStack = CFBridgingRelease(WLArrayCreateMutableWeakPointer());
    }
    return self;
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)setKeyboardObserverDelegate:(id <UIKeyboardObserveManagerDelegate>)delegate
                       forInputView:(UIView *)weakSender
      enableAutoAdjustContainerView:(BOOL)enableAutoAdjust
 inputViewBottomToKeyboardTopOffset:(CGFloat)offset
{
    NSParameterAssert(weakSender);
    
    CFSetAddValue((CFMutableSetRef)self.weakSenderSet, (__bridge const void *)(weakSender));
    SenderInfo* info = [[SenderInfo alloc] init];
    info.delegate = delegate;
    info.enableAutoAdjustContainerView = enableAutoAdjust;
    info.inputViewBottomToKeyboardTopOffset = offset;
    CFDictionarySetValue((CFMutableDictionaryRef)self.weakSenderToInfoDict, (__bridge const void *)(weakSender), (__bridge const void *)(info));
}

- (void)removeObserverForInputView:(id)weakSender
{
    NSParameterAssert(weakSender);
    
    if (CFSetContainsValue((CFSetRef)self.weakSenderSet, (__bridge const void *)(weakSender))) {
        CFSetRemoveValue((CFMutableSetRef)self.weakSenderSet, (__bridge const void *)(weakSender));
        CFDictionaryRemoveValue((CFMutableDictionaryRef)self.weakSenderToInfoDict, (__bridge const void *)(weakSender));
    }
}

- (UIView*)visibleKeyboardView
{
    return [UIKeyBoardViewFinder tryFindIPhoneKeyBoardView];
}

- (CGFloat)visibleKeyboardHeight
{
    UIView *foundKeyboard = self.visibleKeyboardView;
    if(foundKeyboard && foundKeyboard.bounds.size.height > 100)
        return foundKeyboard.bounds.size.height;
    
    return 0;
}

- (id)currentEditingWeakSender
{
    id lastObject = nil;
    CFIndex lastIndex = CFArrayGetCount((CFArrayRef)self.weakSenderStack) - 1;
    if (lastIndex >= 0) {
        lastObject = CFArrayGetValueAtIndex((CFArrayRef)self.weakSenderStack, lastIndex);
    }
    return lastObject;
}


- (void)addKeyboardObserver
{
    // 键盘观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 输入框观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewTextDidBeginEditingNotificationCB:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewTextDidEndEditingNotificationCB:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewTextDidBeginEditingNotificationCB:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewTextDidEndEditingNotificationCB:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)removeKeyboardObserver
{
    // 键盘观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    // 输入框观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}

#pragma mark - 键盘逻辑处理
#pragma mark * 调用顺序:
#pragma mark * BeginEditing -> KeyboardWillShow [-> KeyboardWillHide] -> EndEditing

- (void)inputViewTextDidBeginEditingNotificationCB:(NSNotification*)aNotification
{
    UIView* sender = aNotification.object;
    
    if (CFSetContainsValue((CFSetRef)self.weakSenderSet, (__bridge const void *)(sender))) {
        if (0 == CFArrayGetCount((CFArrayRef)self.weakSenderStack)) {
            self.cachedContainerView = [UIView currentViewController].view;
            self.cachedContainerFrame = self.cachedContainerView.frame;
        }
        CFArrayAppendValue((CFMutableArrayRef)self.weakSenderStack, (__bridge const void *)(sender));
    }
}

- (void)inputViewTextDidEndEditingNotificationCB:(NSNotification*)aNotification
{
    UIView* sender = aNotification.object;
    
    // 键盘结束显示状态, 清空栈; 否则说明键盘打开状态切换了输入框, 不出栈
    if (!self.keyboardShowing) {
        if (CFSetContainsValue((CFSetRef)self.weakSenderSet, (__bridge const void *)(sender))) {
            self.cachedContainerView = nil;
            self.cachedContainerFrame = CGRectZero;
            CFArrayRemoveAllValues((CFMutableArrayRef)self.weakSenderStack);
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.keyboardShowing = YES;
    UIView* sender = self.currentEditingWeakSender;
    
    if (sender) {
        SenderInfo* info = CFDictionaryGetValue((CFDictionaryRef)self.weakSenderToInfoDict, (__bridge const void *)(sender));
        id <UIKeyboardObserveManagerDelegate> delegate = info.delegate;
        
        CGRect keyboardEndRect =
        [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGSize keyboardSize = keyboardEndRect.size;
        NSTimeInterval animationDuration =
        [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve animationCurve =
        [[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        
        if (info.enableAutoAdjustContainerView) {
            UIView* rootView = [UIApplication sharedApplication].keyWindow;
            CGPoint senderPoint = [sender convertPoint:CGPointZero toView:rootView];
            
            CGFloat thisToBottomHeight = CGRectGetMaxY(rootView.frame) - (senderPoint.y + CGRectGetHeight(sender.bounds));
            
            UIView* currentViewControllerView = self.cachedContainerView;
            CGRect frame = currentViewControllerView.frame;
            
            CGFloat adjustOffset = keyboardSize.height - thisToBottomHeight + info.inputViewBottomToKeyboardTopOffset;
            
            if (adjustOffset != 0 && frame.origin.y - adjustOffset <= 0) {
                frame.origin.y -= adjustOffset;
                
                if (animationDuration > 0) {
                    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionsConvertFromUIViewAnimationCurve(animationCurve) animations:^{
                        currentViewControllerView.frame = frame;
                    } completion:nil];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:kKeyboardAnimationMinDuration delay:0 options:UIViewAnimationOptionsConvertFromUIViewAnimationCurve(animationCurve) animations:^{
                            currentViewControllerView.frame = frame;
                        } completion:nil];
                    });
                }
            }
        }
        
        [delegate wl_KeyboardObserveManager:self
                   keyboardWillShowWithSize:keyboardSize
                          animationDuration:animationDuration
                             animationCurve:animationCurve];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.keyboardShowing = NO;
    UIView* sender = self.currentEditingWeakSender;
    
    if (sender) {
        SenderInfo* info = CFDictionaryGetValue((CFDictionaryRef)self.weakSenderToInfoDict, (__bridge const void *)(sender));
        id <UIKeyboardObserveManagerDelegate> delegate = info.delegate;
        
        CGRect keyboardBeginRect =
        [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGSize keyboardSize = keyboardBeginRect.size;
        NSTimeInterval animationDuration =
        [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve animationCurve =
        [[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        
        if (info.enableAutoAdjustContainerView) {
            UIView* currentViewControllerView = self.cachedContainerView;
            CGRect frame = self.cachedContainerFrame;
            
            [UIView animateWithDuration:animationDuration ?: kKeyboardAnimationMinDuration delay:0 options:UIViewAnimationOptionsConvertFromUIViewAnimationCurve(animationCurve) animations:^{
                currentViewControllerView.frame = frame;
            } completion:nil];
        }
        
        [delegate wl_KeyboardObserveManager:self
                   keyboardWillHideWithSize:keyboardSize
                          animationDuration:animationDuration
                             animationCurve:animationCurve];
    }
}

@end

@implementation UIView (KeyboardObserveManager)

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //  Getting topMost ViewController
    while ([topController presentedViewController])	topController = [topController presentedViewController];
    
    //  Returning topMost ViewController
    return topController;
}

+ (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController]) {
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    }
    
    return currentViewController;
}

@end

