//
//  ApplyMemberTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/10/5.
//  Copyright © 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyMemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *inputTxt;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

+ (NSString *)indetify;
@end
