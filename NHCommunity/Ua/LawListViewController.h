//
//  LawListViewController.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseViewController.h"

@interface LawListViewController : BaseViewController
@property (weak, nonatomic)  UIButton *lawList;
@property (weak, nonatomic)  UIButton *lawKnow;
@property (weak, nonatomic)  UIButton *lawQuestion;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lawType:(NSInteger)lawType;

@end
