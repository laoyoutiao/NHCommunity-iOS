//
//  UserCenterTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/26.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

@end
