//
//  CommunityBaseInfoTableViewCell.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "CommunityBaseInfoTableViewCell.h"

@implementation CommunityBaseInfoTableViewCell

- (void)awakeFromNib {
    [_bgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_bgView.layer setBorderWidth:1.0f];
    [_bgView.layer setCornerRadius:5.f];
    [_bgView.layer setMasksToBounds:YES];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)cellHeight{
    return 95.;
}

+ (NSString *)identify{
    return @"cmmBaseCell";
}

@end
