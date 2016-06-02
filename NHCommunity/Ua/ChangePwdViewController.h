//
//  ChangePwdViewController.h
//  MobileFieldManager
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePwdViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *nowPwd;
@property (weak, nonatomic) IBOutlet UITextField *comfirPwd;

@end
