//
//  InfoHeaderTableViewCell.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "InfoHeaderTableViewCell.h"

@implementation InfoHeaderTableViewCell

- (void)awakeFromNib {
    [_leftHeadImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    [_leftHeadImage addGestureRecognizer:tap];
    
    [_editBtn.layer setBorderWidth:0.5f];
    [_editBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_editBtn.layer setCornerRadius:5.f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identify{
    return @"firstCell";
}

- (void)imgTap:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(imgClick)]) {
        [_delegate imgClick];
    }
}

@end
