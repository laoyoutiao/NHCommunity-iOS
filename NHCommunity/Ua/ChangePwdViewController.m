//
//  ChangePwdViewController.m
//  MobileFieldManager
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "UserCenterViewController.h"
#import "AppDelegate.h"

@interface ChangePwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ChangePwdViewController


- (void)createLeftUserCenterBtn{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"m_user" highIcon:@"m_user" target:self action:@selector(showLeft:) edgInset:UIEdgeInsetsMake(0, -5, 0, 5)];
}

- (void)showLeft:(id)sender{
    UserCenterViewController *left = [[AppDelegate appDelegate] userCenterController];
    [self.revealSideViewController pushViewController:left onDirection:PPRevealSideDirectionLeft animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    
    [self createLeftUserCenterBtn];
    
    [_comfirPwd setDelegate:self];
    [_oldPwd setDelegate:self];
    [_nowPwd setDelegate:self];
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:RGB(42.f, 111.f, 231.f, 1.0f)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [self.confirmBtn.layer setMasksToBounds:YES];
    [self.confirmBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    CGColorRef colorref = [Util getColorFromRed:254 Green:166 Blue:92 Alpha:1];
    
    [self.confirmBtn.layer setBorderColor:colorref];//边框颜色
    
        CGColorRelease(colorref);
    
    // 改变表的背景视图
    UIView *bv = [[UIView alloc] init];
    bv.backgroundColor = TableViewBgColor;
    self.tableView.backgroundView = bv;
    
    [self.tableView setBackgroundColor:TableViewBgColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UISwipeGestureRecognizer *swap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeft:)];
    [swap setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swap];


}


- (IBAction)changePwd:(id)sender{
    NSString *oldStr = _oldPwd.text;
    NSString *pwdStr = _nowPwd.text;
    NSString *comfirStr = _comfirPwd.text;
    
    if ([_oldPwd isFirstResponder]) {
        [_oldPwd resignFirstResponder];
    }
    
    if ([_nowPwd isFirstResponder]) {
        [_nowPwd resignFirstResponder];
    }
    
    if ([_comfirPwd isFirstResponder]) {
        [_nowPwd resignFirstResponder];
    }
    
    if (oldStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"原密码不能为空"];
        return;
    }
    
    if (pwdStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"新密码不能为空"];
        return;
    }
    if (comfirStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"确认密码不能为空"];
        return;
    }

    NSDictionary *param = @{@"userName":[[[GlobalUtil shareInstant] loginInfo] objectForKey:U_NAME],@"oldp":oldStr,@"newp":comfirStr};
    
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_UPDATE_PWD] param:param success:^(id responObject) {
//        NSLog(@"changePwd -- %@",responObject);
        NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
        if (reRequest != nil) {
            __weak __typeof(self)weakSelf = self;
            BOOL reFlag = reRequest.boolValue;
            if (reFlag) {
                [weakSelf changePwd:nil];
            }
        }else{
            [USERDEFUALT setObject:comfirStr forKey:U_PWD];
            [USERDEFUALT synchronize];
            [SVProgressHUD showSuccessWithStatus:responObject[@"msg"]];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"修改密码失败"];
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
