//
//  ActiveTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/24.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

+ (CGFloat)cellHeight;
@end
