//
//  LITabStrip.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/9/9.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "LITabStrip.h"
#import <QuartzCore/QuartzCore.h>

#define TABTAGBASE 0x101

@interface LITabStrip ()

@property (nonatomic, strong) CALayer *selectedSegmentLayer;


@end

@implementation LITabStrip

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {

        [self setDefaults];
    }
    
    return self;
}


- (void)setDefaults {
    _scrollView =  [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionIndicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
    self.selectedIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.height = 32.0f;
    self.selectionIndicatorHeight = 5.0f;
    self.selectionIndicatorMode = HsSelectionIndicatorResizesToStringWidth;
    
    self.selectedSegmentLayer = [CALayer layer];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    @synchronized(self)
    {
//        [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (UIView * view in [_scrollView subviews]) {
            [view removeFromSuperview];
        }
        [self.backgroundColor set];
        UIRectFill([self bounds]);
        
        CGFloat width = 0.f;
        int tabIndex = 0;
        int tabCount = (int)[self.sectionTitles count];
        for (NSString *titleString in self.sectionTitles) {
            NSUInteger idx = [self.sectionTitles indexOfObject:titleString];
            CGSize stringSize = [titleString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
            CGFloat y = 0.f;
            CGFloat x = 0.f;
            CGRect labelRect;
            if (self.tabWidthMode == HsTabWidthModeFixed) {
                x = (self.segmentWidth+self.segmentEdgeInset.left+self.segmentEdgeInset.right) * idx+self.segmentEdgeInset.left;
                labelRect = CGRectMake(x, y, self.segmentWidth, rect.size.height-self.selectionIndicatorHeight);
            }
            else{
                x = width + self.segmentEdgeInset.left;
                width = width + self.segmentEdgeInset.left + stringSize.width + self.segmentEdgeInset.right;
                labelRect = CGRectMake(x, y, stringSize.width, rect.size.height-self.selectionIndicatorHeight);
            }
            
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = labelRect;
            btn.titleLabel.font = self.font;
            btn.titleLabel.lineBreakMode = NSLineBreakByClipping;
            if (idx == self.selectedIndex) {
                [btn setTitleColor:self.selectionIndicatorColor forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:self.textColor forState:UIControlStateNormal];
            }
            
            [btn setTitle:titleString forState:UIControlStateNormal];
            btn.tag = idx + TABTAGBASE;
            [btn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            if ([self.showTags count] > tabIndex) {
                NSString *show = [self.showTags objectAtIndex:tabIndex];
                if (show.boolValue) {
                    UIImageView *tagView = [[UIImageView alloc] initWithFrame:CGRectMake(2, (labelRect.size.height - 10)/2, 23, 10)] ;
                    tagView.image = [UIImage imageNamed:@"hgtFlagH.png"];
                    [btn addSubview:tagView];
                }
            }
            
            if (self.showSeperator && tabIndex < tabCount) {
                UIView *vSeperator = [[UIView alloc] initWithFrame:CGRectMake(x + labelRect.size.width + self.segmentEdgeInset.right, 2, 1, _scrollView.frame.size.height-4)] ;
                [_scrollView addSubview:vSeperator];
            }
            tabIndex ++;
        };
        if (self.showSeperator) {
            UIView *sperator = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height-1, _scrollView.frame.size.width, 1)] ;
            [_scrollView addSubview:sperator];
        
        }
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        self.selectedSegmentLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
        [_scrollView.layer addSublayer:self.selectedSegmentLayer];
    }
}

- (CGRect)frameForSelectionIndicator {
    
    CGFloat y = self.selectionIndicatorPositon == HsSelectionIndicatorPositionTop?0:self.height-self.selectionIndicatorHeight;
    CGFloat x = self.segmentEdgeInset.left;
    if (self.tabWidthMode == HsTabWidthModeFixed) {
        x = (self.segmentWidth + self.segmentEdgeInset.left + self.segmentEdgeInset.right) * self.selectedIndex;
    }
    else
    {
        for (int i=0; i<self.selectedIndex; i++) {
            NSString *titleString = [self.sectionTitles objectAtIndex:i];
            CGSize stringSize = [titleString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
            x += stringSize.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
        }
    }
    if (self.selectionIndicatorMode == HsSelectionIndicatorResizesToStringWidth) {
        CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedIndex] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
        if (self.tabWidthMode == HsTabWidthModeFixed) {
            x = x + (self.segmentWidth - stringWidth)/2 + self.segmentEdgeInset.left;
        }
        return CGRectMake(x, y, stringWidth, self.selectionIndicatorHeight);
    } else {
        return CGRectMake(x+self.segmentWidth, y, self.segmentWidth, self.selectionIndicatorHeight);
    }
}

- (void)updateSegmentsRects {
    // If there's no frame set, calculate the width of the control based on the number of segments and their size
    CGFloat totalWidth = 0.f;
    for (NSString *titleString in self.sectionTitles) {
        CGFloat stringWidth = [titleString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
        self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        totalWidth +=stringWidth;
    }
    CGFloat width = 0.f;
    if (self.tabWidthMode == HsTabWidthModeFixed) {
        width = self.segmentWidth * self.sectionTitles.count;
    }
    else {
        width = totalWidth;
    }
    if (CGRectIsEmpty(self.frame)) {
        self.bounds = CGRectMake(0, 0,width, self.height);
        _scrollView.frame = CGRectMake(0, 0, width, self.height);
        _scrollView.contentSize = CGSizeMake(width, self.height);
    } else {
        self.height = self.frame.size.height;
        _scrollView.contentSize = CGSizeMake(width, self.height);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    [self updateSegmentsRects];
}


#pragma mark - event

-(void)tabClicked:(UIButton *)sender{
    if (sender.tag!=self.selectedIndex+TABTAGBASE) {
        [sender setTitleColor:self.selectionIndicatorColor forState:UIControlStateNormal];
        [(UIButton *)[_scrollView viewWithTag:_selectedIndex+TABTAGBASE] setTitleColor:self.textColor forState:UIControlStateNormal];
        [self setSelectedIndex:sender.tag-TABTAGBASE animated:YES];
    }
}

- (void)setSelectedIndex:(NSInteger)index {
    [self setSelectedIndex:index animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated {
    //在赋值新的当前位置时，先把原先的按钮颜色设为不选中状态
    [(UIButton *)[_scrollView viewWithTag:_selectedIndex+TABTAGBASE] setTitleColor:self.textColor forState:UIControlStateNormal];
    
    _selectedIndex = index;

    if (animated) {
        // Restore CALayer animations
        self.selectedSegmentLayer.actions = nil;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setCompletionBlock:^{
            if (self.superview)
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            
            if (self.indexChangeBlock)
                self.indexChangeBlock(index);
        }];
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        [CATransaction commit];
    } else {
        // Disable CALayer animations
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil] ;
        self.selectedSegmentLayer.actions = newActions;
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        
        if (self.superview)
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        if (self.indexChangeBlock)
            self.indexChangeBlock(index);

    }
    //在赋值新的当前位置后，把当前的按钮颜色设为选中状态
    [(UIButton *)[_scrollView viewWithTag:_selectedIndex+TABTAGBASE] setTitleColor:self.selectionIndicatorColor forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.height = frame.size.height;
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    if (self.sectionTitles.count>0 && self.tabWidthMode == HsTabWidthModeFixed) {
        self.segmentWidth = (frame.size.width - (self.segmentEdgeInset.left+self.segmentEdgeInset.right)*self.sectionTitles.count)/self.sectionTitles.count;
    }
    [self setNeedsDisplay];
}


@end
