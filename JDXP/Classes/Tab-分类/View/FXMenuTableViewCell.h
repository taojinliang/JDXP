//
//  FXMenuTableViewCell.h
//  JDXP
//
//  Created by MacBookPro on 16/2/1.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXMenuTableViewCell : UITableViewCell
-(void)configureData:(NSString *)title normalIndexPath:(NSIndexPath *)normalIndexPath selectedIndexPath:(NSIndexPath *)selectedIndexPath;
@end
