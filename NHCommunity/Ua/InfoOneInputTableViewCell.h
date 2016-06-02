//
//  InfoOneInputTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoOneInputTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueInputTxf;

+ (NSString *)identify;
@end
