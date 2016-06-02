//
//  ScrollBannerView.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/25.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "ScrollBannerView.h"

@interface ScrollBannerView(){
    
}

@end

@implementation ScrollBannerView

- (instancetype)initWithFrame:(CGRect)frame
                    firstData:(id)firstData
                   secondData:(id)secondData{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < 2; i++) {
            CGFloat imgX = SCREEN_WIDTH / 2 * i + 10;
            CGFloat imgY = 10;
            CGFloat imgW = 65;
            CGFloat imgH = 48;
            UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
            [leftImage setImage:[UIImage imageNamed:@"b"]];
            [self addSubview:leftImage];
            
            CGFloat hW = imgX + imgW + 5;
            CGFloat LW = SCREEN_WIDTH/2 - 10 - imgW - 5 - 5;//80;
            UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(hW, imgY, LW, 15)];
            [headLabel setBackgroundColor:[Util getColor:COLOR_ORGIN]];
            [headLabel setText:@" 前提没用"];
            [headLabel setTextColor:[UIColor whiteColor]];
            [headLabel setFont:[UIFont systemFontOfSize:9.f]];
            [self addSubview:headLabel];
            
            UILabel *namebel = [[UILabel alloc] initWithFrame:CGRectMake(hW, headLabel.frame.size.height + headLabel.frame.origin.y + 2, CGRectGetWidth(headLabel.frame), 15)];
            [namebel setTextColor:[Util getColor:COLOR_ORGIN]];
            [namebel setText:@"前提没用"];
            [namebel setBackgroundColor:[UIColor whiteColor]];
            [namebel setFont:[UIFont systemFontOfSize:9.f]];
            [self addSubview:namebel];
            
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(hW, namebel.frame.size.height + namebel.frame.origin.y + 2, CGRectGetWidth(headLabel.frame), 15)];
            [addressLabel setBackgroundColor:[UIColor clearColor]];
            [addressLabel setText:@"前提没用"];
            [addressLabel setTextColor:[Util getColor:COLOR_LIGHT_GRAY]];
            [addressLabel setFont:[UIFont systemFontOfSize:9.f]];
            [self addSubview:addressLabel];
            
        }
    }
    return self;
}


@end
