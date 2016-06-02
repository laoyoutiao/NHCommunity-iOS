//
//  SexChoiceTableViewCell.m
//  NHCommunity
//
//  Created by aa on 16/3/22.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "SexChoiceTableViewCell.h"

@implementation SexChoiceTableViewCell

static NSString *name = @"sex";

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identify{
    return name;
}

@end
