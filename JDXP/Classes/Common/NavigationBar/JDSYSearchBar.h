//
//  JDSYSearchBar.h
//  JDXP
//
//  Created by MacBookPro on 16/1/25.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDSearchBarDelegate <NSObject>
-(void)gotoSearchPage;
-(void)gotoVoicePage;
@end

@interface JDSYSearchBar : UIView
@property(nonatomic, weak) id<JDSearchBarDelegate> delegate;
@end
