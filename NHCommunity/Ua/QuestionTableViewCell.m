//
//  QuestionTableViewCell.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/8.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithData:(NSDictionary *)data{
    id content = data[DATA_KEY_REPLY];
    if (![content isKindOfClass:[NSNull class]]) {
        if ([content stringIsNull]) {
            return 70 - 17 + 5;
        }else{
            CGFloat orginX = 52.f;
            CGFloat maxWidth = SCREEN_WIDTH - 10;
            CGSize textBlockMinSize = CGSizeMake(maxWidth, 1000);
            CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:10.f]
                              constrainedToSize:textBlockMinSize
                                  lineBreakMode:NSLineBreakByTruncatingTail];
            CGFloat height = orginX + size.height + 5;
            return height + 1;
        }
    }else{
        return 70 - 17 + 1;
    }
}

+ (NSString *)identify{
    return @"questionCell";
}
@end
