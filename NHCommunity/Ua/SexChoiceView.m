//
//  SexChoiceView.m
//  NHCommunity
//
//  Created by aa on 16/3/22.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "SexChoiceView.h"

@interface SexChoiceView(){

}

@end

@implementation SexChoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self toInital];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    [self toInital];
    }

    return self;
}

- (void)toInital{
    [self setBackgroundColor:[UIColor clearColor]];
    [_segView.layer setBorderWidth:0.5f];
    [_segView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calcle:)];
    [_bgView addGestureRecognizer:tap];
}

- (IBAction)man:(id)sender{
    _callBackBlk(@"男");
    [self removeFromSuperview];
}

- (IBAction)women:(id)sender{
    _callBackBlk(@"女");
    [self removeFromSuperview];
}

- (void)calcle:(id)sender{
    [self removeFromSuperview];
}
@end
