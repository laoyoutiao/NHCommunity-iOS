//
//  LawListTableViewCell.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/19.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "LiftMarketViewCell.h"

@implementation LiftMarketViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight{
    return 58;
}

+ (NSString *)cellIdentify{
    return @"commCell";
}
@end
