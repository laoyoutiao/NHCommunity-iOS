//
//  msgTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/26.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *unReadImg;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDesc;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
+ (CGFloat)cellHeight;
@end
