//
//  ModuleTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/24.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *marketBtn;
@property (weak, nonatomic) IBOutlet UIButton *communiBtn;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UIButton *activeBtn;
@property (weak, nonatomic) IBOutlet UIButton *benifiBtn;
@property (weak, nonatomic) IBOutlet UIButton *personInfoBtn;

+ (CGFloat)cellHeight;
@end
