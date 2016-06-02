//
//  CompanylistTableViewCell.m
//  NHCommunity
//
//  Created by Arsenal on 15/12/28.
//  Copyright © 2015年 ku. All rights reserved.
//

#import "CompanylistTableViewCell.h"

@implementation CompanylistTableViewCell

static NSString *identtify = @"compalylist";


- (void)awakeFromNib {
    //    self.backgroundColor = [UIColor clearColor];
    //    [self.contentView setBackgroundColor:[UIColor clearColor]];
    //
    //    UIView *bgVew = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 70)];
    //    [bgVew setBackgroundColor:[UIColor whiteColor]];
    //    [bgVew.layer setBorderColor:[UIColor whiteColor].CGColor];
    //    [bgVew.layer setBorderWidth:0.5f];
    //    [bgVew.layer setCornerRadius:5.f];
    //    [self.contentView insertSubview:bgVew atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (NSString *)indetify{
    return identtify;
}
@end
