//
//  LoginViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/23.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BaseNavViewController.h"
#import "RegitUserTableViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_name setDelegate:self];
    [_pwd setDelegate:self];
    [self.loginBtn.layer setBorderWidth:.5f];
    [self.loginBtn.layer setCornerRadius:5.0f];
    [self.loginBtn.layer setBorderColor:_loginBtn.backgroundColor.CGColor];
    
    if (SCREEN_HEIGHT == 480) {
        [_Xcontraint setConstant:-20];
        [self.view updateConstraints];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender{
    [_name resignFirstResponder];
    [_pwd resignFirstResponder];
    NSString *nameStr = _name.text;
    NSString *pwdStr = _pwd.text;
    if (nameStr.length == 0) {
        [self showErrorWithStatus:@"名字不能为空"];
        return;
    }
    
    if (pwdStr.length == 0) {
        [self showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    [[GlobalUtil shareInstant] saveUserName:nameStr pwd:pwdStr];
    
    [self showLoading];
    __weak __typeof(self)weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_LOGIN]]];
//        [request setHTTPMethod:@"POST"];
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        NSString *uname = [GlobalUtil shareInstant].loginInfo[U_NAME];
//        NSString *upwd = [GlobalUtil shareInstant].loginInfo[U_PWD];
//        [dict setObject:uname forKey:@"username"];
//        [dict setObject:upwd forKey:@"password"];
//        NSString *body = [NSString stringWithFormat:@"username=%@&password=%@",uname,upwd];
//        NSData *httpBody = [body dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:httpBody];
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData *  data, NSError *  connectionError) {
//            NSLog(@"--- data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//        }];
    
        [[HttpManager shareInstant] doLoginWithCallBack:^(BOOL flag,NSString *errorMsg) {
            if (flag) {
                [weakSelf hiddenLoading];
                [[GlobalUtil shareInstant] setLogin:YES];
                [[AppDelegate appDelegate] initialMainController];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[AppDelegate appDelegate] requestUserInfo];
                });
            }else{
                [self showErrorWithStatus:errorMsg];
            }
        }];
//    });
    
}

- (IBAction)regedit:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([RegitUserTableViewController class]) bundle:nil];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:NULL];
    
   
}

- (IBAction)loginWithCus:(id)sender{
    [[GlobalUtil shareInstant] setLoginWithCus:YES];
    [[GlobalUtil shareInstant] setLogin:NO];
    [[AppDelegate appDelegate] initialMainController];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (SCREEN_HEIGHT == 480) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -80, SCREEN_WIDTH, self.view.frame.size.height);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (SCREEN_HEIGHT == 480) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_pwd resignFirstResponder];
    [_name resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
