//
//  LawListTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/9/19.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiftMarketViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLaebl;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

+ (CGFloat)cellHeight;

+ (NSString *)cellIdentify;
@end
