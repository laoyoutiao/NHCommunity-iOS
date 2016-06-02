//
//  UserCenterViewController.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/23.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseViewController.h"

@interface UserCenterViewController : BaseViewController
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UITableView *tableView;

- (void)reloadData;
@end
