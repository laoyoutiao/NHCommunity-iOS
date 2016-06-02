//
//  UserCenterTableViewCell.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/26.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "UserCenterTableViewCell.h"

@implementation UserCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47.f)];
    [v setBackgroundColor:[Util getColor:@"2d2f3b"]];
    [self setSelectedBackgroundView:v];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


@end
