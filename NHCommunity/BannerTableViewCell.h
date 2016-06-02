//
//  BannerTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/24.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

+ (CGFloat)cellHeight;
@end
