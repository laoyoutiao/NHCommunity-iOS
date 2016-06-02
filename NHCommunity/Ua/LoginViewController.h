//
//  LoginViewController.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/23.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Xcontraint;

@end
