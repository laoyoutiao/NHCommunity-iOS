//
//  QuestionViewController.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseViewController.h"

@interface QuestionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *segView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *askOnlineBtn;
@property (weak, nonatomic) IBOutlet UIButton *porBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UIButton *onlineBenifiBtn;



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title;
@end
