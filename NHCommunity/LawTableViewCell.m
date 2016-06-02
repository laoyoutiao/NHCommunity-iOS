//
//  LawTableViewCell.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/24.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "LawTableViewCell.h"

@implementation LawTableViewCell

- (void)lawTap:(UITapGestureRecognizer *)gesture{
    LawItemView *view = (LawItemView *)[gesture view];
    NSInteger tag = view.tag - 300000;
    if (_delegate && [_delegate respondsToSelector:@selector(lawItemClick:)]) {
        [_delegate lawItemClick:tag];
    }
    
}
- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lawTap:)];
    [_law1 addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lawTap:)];
    [_law2 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lawTap:)];
    [_law3 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lawTap:)];
    [_law4 addGestureRecognizer:tap3];
    
    [_law1 setTag:300000];
    [_law2 setTag:300001];
    [_law3 setTag:300002];
    [_law4 setTag:300003];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state 208 180
}

- (void)refreshLawView{
    [_law1 setLawType:0];
    [_law2 setLawType:1];
    [_law3 setLawType:2];
    [_law4 setLawType:3];
}

+ (CGFloat)cellHeight{
    return 97;
}
@end
