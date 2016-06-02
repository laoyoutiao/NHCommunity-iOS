//
//  SexChoiceTableViewCell.h
//  NHCommunity
//
//  Created by aa on 16/3/22.
//  Copyright © 2016年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexChoiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *sexInput;
@property (weak, nonatomic) IBOutlet UIButton *choiceSexBtn;
+ (NSString *)identify;
@end
