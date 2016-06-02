//
//  LawItemView.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/25.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "LawItemView.h"

@interface LawItemView(){
    NSArray *_dataSource;
    UILabel *_titleLabel;
    UIImageView *_imgView;
}

@end

@implementation LawItemView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialItems];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialItems];
    }
    return self;
}

- (void)initialItems{
    
    [self.layer setBorderWidth:0.5f];
    [self.layer setBorderColor:[Util getColor:@"DCDCDC"].CGColor];
    
    _dataSource = @[@{@"法律法规":@"law_1"},@{@"法律常识":@"law_2"},@{@"法律文书":@"law_3"},@{@"常见问题":@"law_4"}];
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setTextColor:[UIColor redColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self addSubview:_titleLabel];
    
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSDictionary *data = _dataSource[_lawType];
    NSArray *key = data.allKeys;
    NSString *txt = [NSString stringWithFormat:@"%@",key[0]];
//    NSMutableAttributedString *mutiString = [[NSMutableAttributedString alloc] initWithString:txt];
//    [mutiString addAttribute:NSBaselineOffsetAttributeName value:@(1) range:NSMakeRange(0,txt.length)];
//    [_titleLabel setAttributedText:mutiString];
    [_titleLabel setText:txt];
    [_titleLabel setFrame:CGRectMake(7, 3, self.frame.size.width,16)];
    
    UIImage *img = [UIImage imageNamed:data[key[0]]];
    [_imgView setImage:img];
    [_imgView setFrame:CGRectMake(self.frame.size.width - 5 - 20, self.frame.size.height - 5 - 20, 20, 20)];

}

- (void)setLawType:(NSInteger)lawType{
    _lawType = lawType;
    [self setNeedsDisplay];
}
@end
