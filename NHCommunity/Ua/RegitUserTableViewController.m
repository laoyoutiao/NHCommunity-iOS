//
//  RegitUserTableViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/28.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "RegitUserTableViewController.h"

#import "UserCenterViewController.h"
#import "AppDelegate.h"
#import "HttpManager.h"

@interface RegitUserTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation RegitUserTableViewController


- (void)createLeftUserCenterBtn{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigation_back_btn" highIcon:@"navigation_back_btn_press" target:self action:@selector(showLeft:) edgInset:UIEdgeInsetsMake(0, -5, 0, 5)];
}

- (void)showLeft:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员注册";
    
    [_userName setDelegate:self];
    [_pwd setDelegate:self];
    [_email setDelegate:self];
    [_phoneTxfiel setDelegate:self];
    
    //适配ios7
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:RGB(42.f, 111.f, 231.f, 1.0f)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [self createLeftUserCenterBtn];
    
    
    
    [self.confirmBtn.layer setMasksToBounds:YES];
    [self.confirmBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    CGColorRef colorref = [Util getColorFromRed:254 Green:166 Blue:92 Alpha:1];
    
    [self.confirmBtn.layer setBorderColor:colorref];//边框颜色
    
    CGColorRelease(colorref);
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (IBAction)regiedit:(id)sender{
    NSString *name = _userName.text;
    NSString *pwdstr = _pwd.text;
    NSString *surepwdstr = _surepwd.text;
    NSString *emailStr = _email.text;
    NSString *phoen = _phoneTxfiel.text;

    if (name.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return;
    }
    
    if (pwdstr.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码最少要6位长度"];
        return;
    }
    
    if (pwdstr.length > 12) {
        [SVProgressHUD showErrorWithStatus:@"密码不能超过12位长度"];
        return;
    }
    
    if (![pwdstr isEqualToString:surepwdstr]) {
        [SVProgressHUD showErrorWithStatus:@"密码不一致"];
        return;
    }
    
    if (![Util regularWithString:emailStr withRex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"]) {
        [SVProgressHUD showErrorWithStatus:@"邮箱格式不正确"];
        return;
    }
    
    if (![Util regularWithString:phoen withRex:@"^\\d{11}$"]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
        return;
    }

    NSDictionary *param = @{@"userName":name,
                            @"password":pwdstr,
                            @"email":emailStr,
                            @"mobile":phoen};

    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_REGEDIT] param:param success:^(id responObject) {
        NSLog(@"%@",responObject);
         [SVProgressHUD showSuccessWithStatus:responObject[@"msg"]];
        if ([responObject[@"code"] integerValue] == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showLeft:nil];
            });
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"注册失败"];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
