//
//  ButtonTableViewCell.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/9.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (void)awakeFromNib {
//    [_submitBtn.layer setBorderWidth:1.0f];
//    [_submitBtn.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [_submitBtn.layer setCornerRadius:5.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
