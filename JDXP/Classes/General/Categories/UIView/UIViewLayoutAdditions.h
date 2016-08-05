//
//  UIViewLayoutAdditions.h
//  JDXP
//
//  Created by MacBookPro on 16/1/25.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Masonry_JDXP)
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;
- (void) distributeSpacingVerticallyWith:(NSArray*)views;
@end
